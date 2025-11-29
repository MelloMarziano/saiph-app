import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class UniformidadController extends GetxController {
  final RxList<Club> clubes = <Club>[].obs;
  final RxBool loading = true.obs;
  final RxMap<String, UniformStatus> statusByClub =
      <String, UniformStatus>{}.obs;
  final Rx<Club?> selectedClub = Rx<Club?>(null);
  final RxList<Renglon> renglones = <Renglon>[].obs;
  final RxBool saving = false.obs;
  final RxBool completado = false.obs;
  final RxInt total = 0.obs;
  final RxString nombreUsuario = ''.obs;
  final RxString emailUsuario = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage();
    final user = box.read('user');
    if (user is Map) {
      nombreUsuario.value = (user['nombre'] ?? '').toString();
      emailUsuario.value = (user['email'] ?? '').toString();
    }
    _loadClubesYEstados();
    _initRenglones();
  }

  void _initRenglones() {
    final base = <Renglon>[
      Renglon(
        id: 'dis_camisa',
        nombre: 'Camisas: galones y 2 bolsillos',
        maxPuntos: 10,
      ),
      Renglon(
        id: 'dis_pantalon',
        nombre: 'Pantalones: sin pinzas, 2 bolsillos',
        maxPuntos: 5,
      ),
      Renglon(
        id: 'dis_falda',
        nombre: 'Falda corte A debajo rodillas',
        maxPuntos: 5,
      ),
      Renglon(id: 'dis_zapatos', nombre: 'Zapatos negros', maxPuntos: 5),
      Renglon(id: 'dis_medias', nombre: 'Medias negras 3/4', maxPuntos: 5),
      Renglon(id: 'dis_boina', nombre: 'Boina negra emblema GM', maxPuntos: 5),
      Renglon(id: 'dis_correa', nombre: 'Correa metálica GM', maxPuntos: 5),
      Renglon(
        id: 'ins_bas_tri',
        nombre: 'Triángulo, Globo y Arco',
        maxPuntos: 5,
      ),
      Renglon(id: 'ins_bas_pano', nombre: 'Pañoleta y Anillo', maxPuntos: 3),
      Renglon(
        id: 'ins_bas_campo',
        nombre: 'Insignia de Campo Actual',
        maxPuntos: 4,
      ),
      Renglon(
        id: 'ins_bas_cargo',
        nombre: 'Insignia Cargo de Dirigentes',
        maxPuntos: 5,
      ),
      Renglon(
        id: 'ins_bas_cordon',
        nombre: 'Cordón de Mando director',
        maxPuntos: 5,
      ),
      Renglon(
        id: 'ins_bas_galon_dir',
        nombre: 'Galoneras del director',
        maxPuntos: 5,
      ),
      Renglon(
        id: 'ins_clase_dist',
        nombre: 'Distintivo de Clase',
        maxPuntos: 5,
      ),
      Renglon(
        id: 'ins_clase_botones',
        nombre: 'Botones de Clases Investidas',
        maxPuntos: 5,
      ),
      Renglon(
        id: 'ins_clase_galon_rango',
        nombre: 'Galoneras de Clases (Rango)',
        maxPuntos: 5,
      ),
      Renglon(
        id: 'banda_min1',
        nombre: 'Banda (mínimo 1 especialidad)',
        maxPuntos: 5,
      ),
      Renglon(id: 'banda_emblema_gi', nombre: 'Emblema GI', maxPuntos: 5),
      Renglon(id: 'banda_bandera', nombre: 'Bandera Nacional', maxPuntos: 5),
      Renglon(
        id: 'banda_nombre_sangre',
        nombre: 'Nombre con tipo de sangre',
        maxPuntos: 3,
      ),
      Renglon(
        id: 'faltas_graves',
        nombre: 'Faltas Graves',
        maxPuntos: 30,
        esFaltaGrave: true,
      ),
      Renglon(
        id: 'falta_sucio',
        nombre: 'Uniforme sucio',
        maxPuntos: 10,
        esFaltaGrave: true,
      ),
      Renglon(
        id: 'falta_inadecuado',
        nombre: 'Uso inadecuado de uniforme/insignias',
        maxPuntos: 10,
        esFaltaGrave: true,
      ),
      Renglon(
        id: 'falta_no_avala',
        nombre: 'Prendas no avaladas por la iglesia',
        maxPuntos: 10,
        esFaltaGrave: true,
      ),
    ];
    renglones.assignAll(base);
    _recalcularTotal();
  }

  Future<void> _loadClubesYEstados() async {
    loading.value = true;
    try {
      final snapClubes = await FirebaseFirestore.instance
          .collection('clubes')
          .get();
      final list = snapClubes.docs
          .map((d) => Club.fromMap(d.id, d.data()))
          .toList();
      list.sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );
      clubes.assignAll(list);
      final snapEstados = await FirebaseFirestore.instance
          .collection('uniformidad_evaluaciones')
          .get();
      final map = <String, UniformStatus>{};
      for (final d in snapEstados.docs) {
        final data = d.data();
        final clubId = (data['clubId'] ?? d.id).toString();
        map[clubId] = UniformStatus(
          status: (data['status'] ?? 'Pendiente').toString(),
          total: (data['total'] ?? 100) is int
              ? data['total'] as int
              : int.tryParse('${data['total'] ?? '100'}') ?? 100,
        );
      }
      statusByClub.assignAll(map);
    } finally {
      loading.value = false;
    }
  }

  void abrirClub(Club c) async {
    selectedClub.value = c;
    completado.value = false;
    for (final r in renglones) {
      r.deduc = 0;
      r.comentario = '';
    }
    final doc = await FirebaseFirestore.instance
        .collection('uniformidad_evaluaciones')
        .doc(c.id)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      final status = (data['status'] ?? 'Pendiente').toString();
      completado.value = status.toLowerCase() == 'completado';
      final items = (data['items'] ?? []) as List<dynamic>;
      for (final it in items) {
        final id = (it['id'] ?? '').toString();
        final ded = (it['deduc'] ?? 0);
        final com = (it['comentario'] ?? '').toString();
        final r = renglones.firstWhereOrNull((x) => x.id == id);
        if (r != null) {
          r.deduc = ded is int ? ded : int.tryParse('$ded') ?? 0;
          r.comentario = com;
        }
      }
      _recalcularTotal();
    } else {
      _recalcularTotal();
    }
  }

  void setDeduccion(Renglon r, int value) {
    if (completado.value) return;
    final v = value.clamp(0, r.maxPuntos);
    r.deduc = v;
    _recalcularTotal();
    renglones.refresh();
  }

  void setComentario(Renglon r, String value) {
    if (completado.value) return;
    r.comentario = value;
    renglones.refresh();
  }

  void _recalcularTotal() {
    int baseMax = 0;
    int sumDed = 0;
    for (final r in renglones) {
      if (!r.esFaltaGrave) {
        baseMax += r.maxPuntos;
      }
      sumDed += r.deduc;
    }
    total.value = (baseMax - sumDed).clamp(0, baseMax);
  }

  Future<void> guardarEvaluacion() async {
    final c = selectedClub.value;
    if (c == null) return;
    saving.value = true;
    try {
      final faltanComentarios = renglones.any(
        (r) => r.deduc > 0 && (r.comentario.trim().isEmpty),
      );
      if (faltanComentarios) {
        saving.value = false;
        Get.snackbar(
          'Campos requeridos',
          'Agrega comentario en renglones con deducción',
        );
        return;
      }
      final items = renglones
          .map(
            (r) => {
              'id': r.id,
              'deduc': r.deduc,
              'comentario': r.deduc > 0 ? r.comentario : '',
            },
          )
          .toList();
      final status = 'Completado';
      await FirebaseFirestore.instance
          .collection('uniformidad_evaluaciones')
          .doc(c.id)
          .set({
            'clubId': c.id,
            'clubNombre': c.nombre,
            'total': total.value,
            'status': status,
            'items': items,
            'updatedAt': FieldValue.serverTimestamp(),
            'updatedBy': nombreUsuario.value.isNotEmpty
                ? nombreUsuario.value
                : emailUsuario.value,
          });
      statusByClub[c.id] = UniformStatus(status: status, total: total.value);
      completado.value = true;
    } finally {
      saving.value = false;
    }
  }
}

class Renglon {
  final String id;
  final String nombre;
  final int maxPuntos;
  final bool esFaltaGrave;
  int deduc;
  String comentario;
  Renglon({
    required this.id,
    required this.nombre,
    required this.maxPuntos,
    this.esFaltaGrave = false,
    this.deduc = 0,
    this.comentario = '',
  });
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

class UniformStatus {
  final String status;
  final int total;
  UniformStatus({required this.status, required this.total});
}
