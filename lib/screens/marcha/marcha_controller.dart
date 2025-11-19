import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Module {
  final String name;
  final int max;
  final RxInt value = 0.obs;
  Module(this.name, this.max);
}

class MarchaController extends GetxController {
  final RxString selectedStyle = ''.obs;
  final RxList<Module> modules = <Module>[].obs;
  final RxInt generalFaults = 0.obs;
  final RxInt styleFaults = 0.obs;
  final RxList<Peloton> pelotones = <Peloton>[].obs;
  Peloton? currentPeloton;
  final RxBool isLoading = true.obs;
  List<String> styleOrder = const [
    'FANCY DRILL',
    'MILITARY DRILL',
    'SILENT DRILL',
    'SOUNDTRACK',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadPelotones();
  }

  void selectStyle(String style) {
    selectedStyle.value = style;
    modules.assignAll(_buildModules(style));
    generalFaults.value = 0;
    styleFaults.value = 0;
  }

  void selectPeloton(Peloton p) {
    currentPeloton = p;
    selectStyle(_normalizeStyle(p.tipoMarcha));
  }

  void clearSelection() {
    selectedStyle.value = '';
    modules.clear();
    currentPeloton = null;
    generalFaults.value = 0;
    styleFaults.value = 0;
  }

  void adjustModule(int index, int delta) {
    if (index < 0 || index >= modules.length) return;
    final m = modules[index];
    final next = (m.value.value + delta).clamp(0, m.max);
    m.value.value = next;
  }

  void adjustGeneralFaults(int delta) {
    generalFaults.value = (generalFaults.value + delta).clamp(0, 999);
  }

  void adjustStyleFaults(int delta) {
    styleFaults.value = (styleFaults.value + delta).clamp(0, 999);
  }

  void resetAll() {
    for (final m in modules) {
      m.value.value = 0;
    }
    generalFaults.value = 0;
    styleFaults.value = 0;
  }

  int get rawTotal => modules.fold(0, (acc, m) => acc + m.value.value);
  int get penaltyGeneral => generalFaults.value * 5;
  int get penaltyStyle => styleFaults.value * 2;
  int get finalTotal => (rawTotal - (penaltyGeneral + penaltyStyle)).clamp(0, maxTotal);
  bool get disqualified => generalFaults.value > 0;
  int get maxTotal => modules.fold(0, (acc, m) => acc + m.max);

  List<Module> _buildModules(String style) {
    switch (style) {
      case 'FANCY DRILL':
        return [
          Module('Instructor', 11),
          Module('Reglamentaria', 10),
          Module('Precisión de reglamentaria', 10),
          Module('Pliegue o repliegue (Exhibición)', 12),
          Module('Innovación (Exhibición)', 18),
          Module('Grado de dificultad (Exhibición)', 18),
          Module('Impacto del juez', 6),
          Module('Precisión (Exhibición)', 15),
        ];
      case 'MILITARY DRILL':
        return [
          Module('Instructor', 11),
          Module('Reglamentaria', 10),
          Module('Precisión de reglamentaria', 10),
          Module('Pliegue o repliegue (Exhibición)', 18),
          Module('Innovación (Exhibición)', 30),
          Module('Grado de dificultad (Exhibición)', 3),
          Module('Precisión (Exhibición)', 18),
        ];
      case 'SILENT DRILL':
        return [
          Module('Instructor', 11),
          Module('Reglamentaria', 10),
          Module('Precisión de reglamentaria', 10),
          Module('Pliegue o repliegue (Exhibición)', 18),
          Module('Innovación (Exhibición)', 12),
          Module('Grado de dificultad (Exhibición)', 15),
          Module('Precisión (Exhibición)', 24),
        ];
      case 'SOUNDTRACK':
        return [
          Module('Instructor', 12),
          Module('Reglamentaria', 10),
          Module('Precisión de reglamentaria', 10),
          Module('Pliegue y repliegue (Exhibición)', 12),
          Module('Innovación (Exhibición)', 18),
          Module('Grado de dificultad (Exhibición)', 12),
          Module('Impacto del juez', 6),
          Module('Precisión (Exhibición)', 8),
          Module('Sincronización con la música', 12),
        ];
      default:
        return [];
    }
  }

  Future<void> _loadPelotones() async {
    isLoading.value = true;
    try {
      final snap = await FirebaseFirestore.instance.collection('pelotones').get();
      pelotones.assignAll(snap.docs.map((d) => Peloton.fromMap(d.id, d.data())));
    } finally {
      isLoading.value = false;
    }
  }

  String _normalizeStyle(String raw) {
    final r = raw.trim().toUpperCase();
    if (r.contains('FANCY')) return 'FANCY DRILL';
    if (r.contains('MILITARY')) return 'MILITARY DRILL';
    if (r.contains('SILENT')) return 'SILENT DRILL';
    if (r.contains('SOUND')) return 'SOUNDTRACK';
    return raw.toUpperCase();
  }

  String styleKey(String raw) => _normalizeStyle(raw);

  Map<String, List<Peloton>> get groupedByStyle {
    final map = <String, List<Peloton>>{};
    for (final p in pelotones) {
      final key = styleKey(p.tipoMarcha);
      map.putIfAbsent(key, () => []);
      map[key]!.add(p);
    }
    return map;
  }
}

class Peloton {
  final String id;
  final String nombre;
  final String instructor;
  final String tipoMarcha;
  final int cantidadMiembros;
  Peloton({
    required this.id,
    required this.nombre,
    required this.instructor,
    required this.tipoMarcha,
    required this.cantidadMiembros,
  });

  factory Peloton.fromMap(String id, Map<String, dynamic> map) {
    return Peloton(
      id: id,
      nombre: map['nombre'] ?? '',
      instructor: map['instructor'] ?? '',
      tipoMarcha: map['tipoMarcha'] ?? '',
      cantidadMiembros: (map['cantidadMiembros'] ?? map['cantidadMiembros'] ?? 0) is int
          ? (map['cantidadMiembros'] ?? 0)
          : int.tryParse('${map['cantidadMiembros'] ?? '0'}') ?? 0,
    );
  }
}
