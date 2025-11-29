import 'package:get/get.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class PaseListaController extends GetxController {
  final RxList<PaseEvento> eventos = <PaseEvento>[].obs;
  final RxBool eventosLoading = true.obs;
  final Rx<PaseEvento?> selected = Rx<PaseEvento?>(null);
  final RxList<Club> clubes = <Club>[].obs;
  final RxBool clubesLoading = false.obs;
  final RxSet<String> ausentes = <String>{}.obs; // clubId ausentes
  final RxString zoneFilter = ''.obs;
  final RxString nombreUsuario = ''.obs;
  final RxString emailUsuario = ''.obs;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _sub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _selectedSub;
  final RxInt remotePresentes = 0.obs;
  final RxInt remoteAusentes = 0.obs;
  final RxList<String> remoteClubesPresentes = <String>[].obs;
  final RxList<String> remoteClubesAusentes = <String>[].obs;
  final RxBool completado = false.obs;

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage();
    final user = box.read('user');
    if (user is Map) {
      nombreUsuario.value = (user['nombre'] ?? '').toString();
      emailUsuario.value = (user['email'] ?? '').toString();
    }
    _sub = FirebaseFirestore.instance
        .collection('pase_lista_eventos')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) {
          eventos.assignAll(
            snap.docs.map((d) => PaseEvento.fromMap(d.id, d.data())).toList(),
          );
          eventosLoading.value = false;
        });
  }

  @override
  void onClose() {
    _sub.cancel();
    _selectedSub?.cancel();
    super.onClose();
  }

  void selectEvento(PaseEvento e) async {
    selected.value = e;
    ausentes.clear();
    _selectedSub?.cancel();
    _selectedSub = FirebaseFirestore.instance
        .collection('pase_lista_eventos')
        .doc(e.id)
        .snapshots()
        .listen((doc) {
          final data = doc.data() ?? {};
          final prs = (data['presentes'] ?? 0);
          final aus = (data['ausentes'] ?? 0);
          remotePresentes.value = prs is int ? prs : int.tryParse('$prs') ?? 0;
          remoteAusentes.value = aus is int ? aus : int.tryParse('$aus') ?? 0;
          final lp = (data['clubesPresentes'] ?? []) as List<dynamic>;
          final la = (data['clubesAusentes'] ?? []) as List<dynamic>;
          remoteClubesPresentes.assignAll(lp.map((e) => e.toString()));
          remoteClubesAusentes.assignAll(la.map((e) => e.toString()));
          final status = (data['status'] ?? '').toString();
          final cerradoFlag = (data['cerrado'] ?? false) == true;
          completado.value =
              cerradoFlag || status.toLowerCase() == 'completado';
          // si ya cargamos clubes, sincronizamos ausentes locales
          if (clubes.isNotEmpty) {
            final ids = clubes
                .where((c) => remoteClubesAusentes.contains(c.nombre))
                .map((c) => c.id)
                .toSet();
            ausentes
              ..clear()
              ..addAll(ids);
          }
        });
    await _loadClubes();
  }

  Future<void> _loadClubes() async {
    clubesLoading.value = true;
    try {
      final snap = await FirebaseFirestore.instance.collection('clubes').get();
      final list = snap.docs.map((d) => Club.fromMap(d.id, d.data())).toList();
      list.sort((a, b) {
        final za = int.tryParse(_normZone(a.zona)) ?? 0;
        final zb = int.tryParse(_normZone(b.zona)) ?? 0;
        if (za != zb) return za.compareTo(zb);
        return a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase());
      });
      clubes.assignAll(list);
      // sincronizar ausentes locales con remoto si disponible
      if (remoteClubesAusentes.isNotEmpty) {
        final ids = list
            .where((c) => remoteClubesAusentes.contains(c.nombre))
            .map((c) => c.id)
            .toSet();
        ausentes
          ..clear()
          ..addAll(ids);
      }
    } finally {
      clubesLoading.value = false;
    }
  }

  void toggleAusente(Club c) {
    final e = selected.value;
    if (e == null) return;
    if (completado.value) return;
    final doc = FirebaseFirestore.instance
        .collection('pase_lista_eventos')
        .doc(e.id);
    final name = c.nombre;
    if (ausentes.contains(c.id)) {
      ausentes.remove(c.id);
      doc.update({
        'ausentes': FieldValue.increment(-1),
        'presentes': FieldValue.increment(1),
        'clubesAusentes': FieldValue.arrayRemove([name]),
        'clubesPresentes': FieldValue.arrayUnion([name]),
      });
    } else {
      ausentes.add(c.id);
      doc.update({
        'ausentes': FieldValue.increment(1),
        'presentes': FieldValue.increment(-1),
        'clubesAusentes': FieldValue.arrayUnion([name]),
        'clubesPresentes': FieldValue.arrayRemove([name]),
      });
    }
  }

  void setZone(String? v) {
    zoneFilter.value = (v ?? '').trim();
  }

  List<Club> get filteredClubs {
    final z = _normZone(zoneFilter.value);
    return clubes.where((c) => z.isEmpty || _normZone(c.zona) == z).toList();
  }

  int get totalClubes => clubes.length;
  int get totalAusentes => remoteAusentes.value;
  int get totalPresentes => remotePresentes.value;

  Future<void> guardarPase() async {
    final e = selected.value;
    if (e == null) return;
    final presentes = clubes
        .where((c) => !ausentes.contains(c.id))
        .map((c) => c.nombre)
        .toList();
    final aus = clubes
        .where((c) => ausentes.contains(c.id))
        .map((c) => c.nombre)
        .toList();
    await FirebaseFirestore.instance
        .collection('pase_lista_eventos')
        .doc(e.id)
        .update({
          'presentes': presentes.length,
          'ausentes': aus.length,
          'clubesPresentes': presentes,
          'clubesAusentes': aus,
          'cerrado': true,
          'status': 'Completado',
          'closedAt': FieldValue.serverTimestamp(),
          'cerradoPor': nombreUsuario.value.isNotEmpty
              ? nombreUsuario.value
              : emailUsuario.value,
        });
    completado.value = true;
  }

  String _normZone(String s) {
    final lower = s.toLowerCase().trim();
    final m = RegExp(r"\d+").firstMatch(lower);
    if (m != null) return m.group(0)!;
    return lower;
  }
}

class PaseEvento {
  final String id;
  final String nombre;
  final String fecha;
  final String hora;
  final int presentes;
  final int ausentes;
  PaseEvento({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.hora,
    required this.presentes,
    required this.ausentes,
  });

  factory PaseEvento.fromMap(String id, Map<String, dynamic> map) {
    return PaseEvento(
      id: id,
      nombre: (map['nombre'] ?? '').toString(),
      fecha: (map['fecha'] ?? '').toString(),
      hora: (map['hora'] ?? '').toString(),
      presentes: (map['presentes'] ?? 0) is int
          ? map['presentes'] as int
          : int.tryParse('${map['presentes'] ?? '0'}') ?? 0,
      ausentes: (map['ausentes'] ?? 0) is int
          ? map['ausentes'] as int
          : int.tryParse('${map['ausentes'] ?? '0'}') ?? 0,
    );
  }
}

class Club {
  final String id;
  final String nombre;
  final String zona;
  Club({required this.id, required this.nombre, required this.zona});
  factory Club.fromMap(String id, Map<String, dynamic> map) {
    return Club(
      id: id,
      nombre: (map['nombre'] ?? '').toString(),
      zona: (map['zona'] ?? '').toString(),
    );
  }
}
