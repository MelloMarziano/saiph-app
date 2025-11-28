import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class DisciplinaController extends GetxController {
  final RxList<Club> clubes = <Club>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLogsLoading = false.obs;
  final Rx<Club?> selectedClub = Rx<Club?>(null);
  final RxMap<String, FlagSummary> clubFlags = <String, FlagSummary>{}.obs;
  final RxString searchQuery = ''.obs;
  final RxString zoneFilter = ''.obs; // vacío = todas
  final RxInt yellow = 0.obs;
  final RxInt blue = 0.obs;
  final RxInt red = 0.obs;
  final RxString reason = ''.obs;
  final RxList<DisciplineLog> logs = <DisciplineLog>[].obs;
  final RxBool isSubmitting = false.obs;
  String currentNombre = '';
  String currentEmail = '';
  final RxString rol = ''.obs;
  final RxInt baselineYellow = 0.obs;
  final RxInt baselineBlue = 0.obs;
  final RxInt baselineRed = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadClubes();
    final box = GetStorage();
    final user = box.read('user');
    if (user is Map) {
      currentNombre = (user['nombre'] ?? '').toString();
      currentEmail = (user['email'] ?? '').toString();
      rol.value = (user['rol'] ?? '').toString();
    }
  }

  Future<void> _loadClubes() async {
    isLoading.value = true;
    try {
      final snap = await FirebaseFirestore.instance.collection('clubes').get();
      clubes.assignAll(snap.docs.map((d) => Club.fromMap(d.id, d.data())));
    } finally {
      isLoading.value = false;
    }
  }

  void selectClub(Club c) {
    selectedClub.value = c;
    isLogsLoading.value = true;
    resetCounts();
    loadLogs();
  }

  void clearSelection() {
    selectedClub.value = null;
    isLogsLoading.value = false;
    resetCounts();
  }

  void resetCounts() {
    reason.value = '';
  }

  void adjustYellow(int delta) {
    yellow.value = (yellow.value + delta).clamp(baselineYellow.value, 999);
  }

  void adjustBlue(int delta) {
    blue.value = (blue.value + delta).clamp(baselineBlue.value, 999);
  }

  void adjustRed(int delta) {
    red.value = (red.value + delta).clamp(baselineRed.value, 999);
  }

  int get effectiveBlue => blue.value + (yellow.value ~/ 3);
  int get totalYellow => yellow.value;
  int get totalRed => red.value;
  int get totalEffectiveBlue => effectiveBlue;
  int get baseCredit => 100;
  int get totalDiscipline => totalRed >= 4
      ? 0
      : (baseCredit - totalEffectiveBlue * 10 - totalRed * 25).clamp(
          0,
          baseCredit,
        );

  void setReason(String v) {
    reason.value = v;
  }

  void setSearch(String v) {
    searchQuery.value = v;
  }

  bool get isAdmin {
    final r = rol.value.trim().toLowerCase();
    return r == 'admin' || r.contains('administrador');
  }

  void setZone(String? v) {
    zoneFilter.value = (v ?? '').trim();
  }

  List<Club> get filteredClubs {
    final q = searchQuery.value.trim().toLowerCase();
    final z = zoneFilter.value.trim().toLowerCase();
    return clubes.where((c) {
      final nameOk = q.isEmpty || c.nombre.toLowerCase().contains(q);
      final zoneOk =
          z.isEmpty ||
          c.zona.toLowerCase() == z ||
          c.zona.toLowerCase().startsWith(z);
      return nameOk && zoneOk;
    }).toList();
  }

  Future<void> submit() async {
    if (selectedClub.value == null) return;
    if (reason.value.trim().isEmpty) {
      Get.snackbar(
        'Razón requerida',
        'Debes escribir el motivo antes de enviar',
      );
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      final now = DateTime.now();
      final addYellow = math.max(0, yellow.value - baselineYellow.value);
      final addBlue = math.max(0, blue.value - baselineBlue.value);
      final addRed = math.max(0, red.value - baselineRed.value);
      final newId = await _addEntry(
        selectedClub.value!,
        reason.value,
        addYellow,
        addBlue,
        addRed,
      );
      logs.insert(
        0,
        DisciplineLog(
          id: newId,
          author: (currentNombre.isNotEmpty ? currentNombre : currentEmail),
          createdAt: now,
          reason: reason.value,
          yellowCount: addYellow,
          blueCount: addBlue,
          redCount: addRed,
        ),
      );
      baselineYellow.value += addYellow;
      baselineBlue.value += addBlue;
      baselineRed.value += addRed;
      yellow.value = baselineYellow.value;
      blue.value = baselineBlue.value;
      red.value = baselineRed.value;
      final sc = selectedClub.value!;
      clubFlags[sc.id] = FlagSummary(
        yellow: baselineYellow.value,
        blue: baselineBlue.value,
        red: baselineRed.value,
      );
      reason.value = '';
      Get.snackbar('Enviado', 'Se registró la entrada de disciplina');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar la entrada');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> _addEntry(
    Club club,
    String reason,
    int yellowCount,
    int blueCount,
    int redCount,
  ) async {
    final ref = await FirebaseFirestore.instance
        .collection('disciplinas')
        .doc(club.id)
        .collection('registros')
        .add({
          'clubId': club.id,
          'clubNombre': club.nombre,
          'amarillas': yellowCount,
          'azules': blueCount,
          'rojas': redCount,
          'reason': reason,
          'creadoPor': (currentNombre.isNotEmpty
              ? currentNombre
              : currentEmail),
          'createdAt': FieldValue.serverTimestamp(),
        });
    return ref.id;
  }

  Future<void> loadLogs() async {
    final club = selectedClub.value;
    if (club == null) return;
    isLogsLoading.value = true;
    final snap = await FirebaseFirestore.instance
        .collection('disciplinas')
        .doc(club.id)
        .collection('registros')
        .orderBy('createdAt', descending: true)
        .get();
    logs.assignAll(
      snap.docs.map((d) {
        final data = d.data();
        final ts = data['createdAt'];
        DateTime dt;
        if (ts is Timestamp) {
          dt = ts.toDate();
        } else {
          dt = DateTime.now();
        }
        return DisciplineLog(
          id: d.id,
          author: (data['creadoPor'] ?? data['author'] ?? '') as String,
          createdAt: dt,
          reason: (data['reason'] ?? '') as String,
          yellowCount: (data['amarillas'] ?? 0) is int
              ? data['amarillas'] as int
              : int.tryParse('${data['amarillas'] ?? '0'}') ?? 0,
          blueCount: (data['azules'] ?? 0) is int
              ? data['azules'] as int
              : int.tryParse('${data['azules'] ?? '0'}') ?? 0,
          redCount: (data['rojas'] ?? 0) is int
              ? data['rojas'] as int
              : int.tryParse('${data['rojas'] ?? '0'}') ?? 0,
        );
      }),
    );
    int sumY = 0;
    int sumB = 0;
    int sumR = 0;
    for (final l in logs) {
      sumY += l.yellowCount;
      sumB += l.blueCount;
      sumR += l.redCount;
    }
    baselineYellow.value = sumY;
    baselineBlue.value = sumB;
    baselineRed.value = sumR;
    yellow.value = baselineYellow.value;
    blue.value = baselineBlue.value;
    red.value = baselineRed.value;
    clubFlags[club.id] = FlagSummary(
      yellow: baselineYellow.value,
      blue: baselineBlue.value,
      red: baselineRed.value,
    );
    isLogsLoading.value = false;
  }

  Future<void> resetClubDiscipline() async {
    final club = selectedClub.value;
    if (club == null) return;
    isLogsLoading.value = true;
    try {
      final col = FirebaseFirestore.instance
          .collection('disciplinas')
          .doc(club.id)
          .collection('registros');
      final snap = await col.get();
      final batch = FirebaseFirestore.instance.batch();
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
      logs.clear();
      baselineYellow.value = 0;
      baselineBlue.value = 0;
      baselineRed.value = 0;
      yellow.value = 0;
      blue.value = 0;
      red.value = 0;
      clubFlags[club.id] = const FlagSummary(yellow: 0, blue: 0, red: 0);
      Get.snackbar('Reinicio', 'Disciplina del club reseteada');
    } catch (_) {
      Get.snackbar('Error', 'No se pudo resetear la disciplina');
    } finally {
      isLogsLoading.value = false;
    }
  }

  Future<void> loadClubFlagSummary(String clubId) async {
    if (clubFlags.containsKey(clubId)) return;
    final snap = await FirebaseFirestore.instance
        .collection('disciplinas')
        .doc(clubId)
        .collection('registros')
        .get();
    int sumY = 0;
    int sumB = 0;
    int sumR = 0;
    for (final d in snap.docs) {
      final data = d.data();
      final y = (data['amarillas'] ?? 0) is int
          ? data['amarillas'] as int
          : int.tryParse('${data['amarillas'] ?? '0'}') ?? 0;
      final b = (data['azules'] ?? 0) is int
          ? data['azules'] as int
          : int.tryParse('${data['azules'] ?? '0'}') ?? 0;
      final r = (data['rojas'] ?? 0) is int
          ? data['rojas'] as int
          : int.tryParse('${data['rojas'] ?? '0'}') ?? 0;
      sumY += y;
      sumB += b;
      sumR += r;
    }
    clubFlags[clubId] = FlagSummary(yellow: sumY, blue: sumB, red: sumR);
  }

  Future<void> deleteLog(String logId) async {
    final club = selectedClub.value;
    if (club == null) return;
    isLogsLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('disciplinas')
          .doc(club.id)
          .collection('registros')
          .doc(logId)
          .delete();
      logs.removeWhere((l) => l.id == logId);
      int sumY = 0;
      int sumB = 0;
      int sumR = 0;
      for (final l in logs) {
        sumY += l.yellowCount;
        sumB += l.blueCount;
        sumR += l.redCount;
      }
      baselineYellow.value = sumY;
      baselineBlue.value = sumB;
      baselineRed.value = sumR;
      yellow.value = baselineYellow.value;
      blue.value = baselineBlue.value;
      red.value = baselineRed.value;
      clubFlags[club.id] = FlagSummary(
        yellow: baselineYellow.value,
        blue: baselineBlue.value,
        red: baselineRed.value,
      );
      Get.snackbar('Eliminado', 'Registro de disciplina eliminado');
    } catch (_) {
      Get.snackbar('Error', 'No se pudo eliminar el registro');
    } finally {
      isLogsLoading.value = false;
    }
  }
}

class Club {
  final String id;
  final String nombre;
  final String director;
  final String zona;
  final int cantidadMiembros;
  Club({
    required this.id,
    required this.nombre,
    required this.director,
    required this.zona,
    required this.cantidadMiembros,
  });

  factory Club.fromMap(String id, Map<String, dynamic> map) {
    return Club(
      id: id,
      nombre: map['nombre'] ?? '',
      director: map['director'] ?? '',
      zona: map['zona'] ?? '',
      cantidadMiembros: (map['cantidadMiembros'] ?? 0) is int
          ? (map['cantidadMiembros'] ?? 0)
          : int.tryParse('${map['cantidadMiembros'] ?? '0'}') ?? 0,
    );
  }
}

class DisciplineLog {
  final String id;
  final String author;
  final DateTime createdAt;
  final String reason;
  final int yellowCount;
  final int blueCount;
  final int redCount;
  DisciplineLog({
    required this.id,
    required this.author,
    required this.createdAt,
    required this.reason,
    required this.yellowCount,
    required this.blueCount,
    required this.redCount,
  });
}

class FlagSummary {
  final int yellow;
  final int blue;
  final int red;
  const FlagSummary({
    required this.yellow,
    required this.blue,
    required this.red,
  });
  int get total => yellow + blue + red;
}
