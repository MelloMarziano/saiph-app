import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisciplinaController extends GetxController {
  final RxList<Club> clubes = <Club>[].obs;
  final RxBool isLoading = true.obs;
  final Rx<Club?> selectedClub = Rx<Club?>(null);
  final RxInt yellow = 0.obs;
  final RxInt blue = 0.obs;
  final RxInt red = 0.obs;
  final RxString reason = ''.obs;
  final RxList<DisciplineLog> logs = <DisciplineLog>[].obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadClubes();
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
    resetCounts();
    loadLogs();
  }

  void clearSelection() {
    selectedClub.value = null;
    resetCounts();
  }

  void resetCounts() {
    yellow.value = 0;
    blue.value = 0;
    red.value = 0;
    reason.value = '';
  }

  void adjustYellow(int delta) {
    yellow.value = (yellow.value + delta).clamp(0, 999);
  }

  void adjustBlue(int delta) {
    blue.value = (blue.value + delta).clamp(0, 999);
  }

  void adjustRed(int delta) {
    red.value = (red.value + delta).clamp(0, 999);
  }

  int get effectiveBlue => blue.value + (yellow.value ~/ 3);
  int get baseCredit => 100;
  int get totalDiscipline => red.value >= 4
      ? 0
      : (baseCredit - effectiveBlue * 10 - red.value * 25).clamp(0, baseCredit);

  void setReason(String v) {
    reason.value = v;
  }

  Future<void> submit() async {
    if (selectedClub.value == null) return;
    if (reason.value.trim().isEmpty) {
      Get.snackbar('Razón requerida', 'Debes escribir el motivo antes de enviar');
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      final now = DateTime.now();
      await _addEntry(selectedClub.value!, reason.value, yellow.value, blue.value, red.value);
      logs.insert(0, DisciplineLog(author: 'Eliu Ortega', createdAt: now, reason: reason.value, yellowCount: yellow.value, blueCount: blue.value, redCount: red.value));
      reason.value = '';
      Get.snackbar('Enviado', 'Se registró la entrada de disciplina');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _addEntry(Club club, String reason, int yellowCount, int blueCount, int redCount) async {
    await FirebaseFirestore.instance.collection('disciplinas').doc(club.id).collection('registros').add({
      'clubId': club.id,
      'clubNombre': club.nombre,
      'amarillas': yellowCount,
      'azules': blueCount,
      'rojas': redCount,
      'reason': reason,
      'creadoPor': 'Eliu Ortega',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> loadLogs() async {
    final club = selectedClub.value;
    if (club == null) return;
    final snap = await FirebaseFirestore.instance.collection('disciplinas').doc(club.id).collection('registros').orderBy('createdAt', descending: true).get();
    logs.assignAll(snap.docs.map((d) {
      final data = d.data();
      final ts = data['createdAt'];
      DateTime dt;
      if (ts is Timestamp) {
        dt = ts.toDate();
      } else {
        dt = DateTime.now();
      }
      return DisciplineLog(
        author: (data['creadoPor'] ?? data['author'] ?? '') as String,
        createdAt: dt,
        reason: (data['reason'] ?? '') as String,
        yellowCount: (data['amarillas'] ?? 0) is int ? data['amarillas'] as int : int.tryParse('${data['amarillas'] ?? '0'}') ?? 0,
        blueCount: (data['azules'] ?? 0) is int ? data['azules'] as int : int.tryParse('${data['azules'] ?? '0'}') ?? 0,
        redCount: (data['rojas'] ?? 0) is int ? data['rojas'] as int : int.tryParse('${data['rojas'] ?? '0'}') ?? 0,
      );
    }));
  }
}

class Club {
  final String id;
  final String nombre;
  final String director;
  final String zona;
  final int cantidadMiembros;
  Club({required this.id, required this.nombre, required this.director, required this.zona, required this.cantidadMiembros});

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
  final String author;
  final DateTime createdAt;
  final String reason;
  final int yellowCount;
  final int blueCount;
  final int redCount;
  DisciplineLog({required this.author, required this.createdAt, required this.reason, required this.yellowCount, required this.blueCount, required this.redCount});
}