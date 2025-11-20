import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Peloton {
  final String id;
  final String nombre;
  final String instructor;
  final String tipoMarcha;
  final int cantidadMiembros;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  Peloton({
    required this.id,
    required this.nombre,
    required this.instructor,
    required this.tipoMarcha,
    required this.cantidadMiembros,
    this.createdAt,
    this.updatedAt,
  });

  factory Peloton.fromMap(String id, Map<String, dynamic> map) {
    DateTime? ca;
    final c = map['createdAt'];
    if (c is Timestamp) ca = c.toDate();
    DateTime? ua;
    final u = map['updatedAt'];
    if (u is Timestamp) ua = u.toDate();
    return Peloton(
      id: id,
      nombre: (map['nombre'] ?? '') as String,
      instructor: (map['instructor'] ?? '') as String,
      tipoMarcha: (map['tipoMarcha'] ?? '') as String,
      cantidadMiembros: (map['cantidadMiembros'] ?? 0) is int
          ? map['cantidadMiembros'] as int
          : int.tryParse('${map['cantidadMiembros'] ?? '0'}') ?? 0,
      createdAt: ca,
      updatedAt: ua,
    );
  }
}

class MarchaController extends GetxController {
  final RxList<Peloton> pelotones = <Peloton>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPelotones();
  }

  Future<void> loadPelotones() async {
    isLoading.value = true;
    error.value = '';
    try {
      final snap = await FirebaseFirestore.instance
          .collection('pelotones')
          .orderBy('createdAt', descending: true)
          .get();
      pelotones.assignAll(snap.docs.map((d) => Peloton.fromMap(d.id, d.data())));
    } on FirebaseException catch (e) {
      error.value = e.message ?? e.code;
    } catch (e) {
      error.value = '$e';
    } finally {
      isLoading.value = false;
    }
  }
}
