import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dumcapp/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumcapp/screens/marcha/marcha_controller.dart';

class HomeController extends GetxController {
  final completedEvaluations = 0.obs;
  final registeredClubs = 0.obs;
  final pendingSync = 0.obs;
  final nombre = ''.obs;
  final rol = ''.obs;
  final email = ''.obs;
  final RxList<Peloton> clubs = <Peloton>[].obs;
  final RxList<Map<String, dynamic>> myEvaluations =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> pendingItems =
      <Map<String, dynamic>>[].obs;
  final RxBool syncing = false.obs;
  final RxMap<String, int> zoneCounts = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final box = GetStorage();
    final user = box.read('user');
    if (user is Map) {
      nombre.value = (user['nombre'] ?? '').toString();
      rol.value = (user['rol'] ?? '').toString();
      email.value = (user['email'] ?? '').toString();
      loadHomeData();
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  void onSignOut() {
    final box = GetStorage();
    box.remove('user');
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  Future<void> loadHomeData() async {
    await _loadClubs();
    await _loadMyEvaluations();
    _loadPendingFromStorage();
  }

  Future<void> _loadClubs() async {
    try {
      final snapPelotones = await FirebaseFirestore.instance
          .collection('pelotones')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
      final list = snapPelotones.docs
          .map((d) => Peloton.fromMap(d.id, d.data()))
          .toList();
      clubs.assignAll(list);
      final snapClubes = await FirebaseFirestore.instance
          .collection('clubes')
          .get();
      registeredClubs.value = snapClubes.size;
      final counts = <String, int>{};
      for (final d in snapClubes.docs) {
        final data = d.data();
        final raw = (data['zona'] ?? '').toString();
        final key = _normZone(raw);
        if (key.isEmpty) continue;
        counts[key] = (counts[key] ?? 0) + 1;
      }
      zoneCounts.assignAll(_sortedZones(counts));
    } catch (_) {
      // keep previous values
    }
  }

  Map<String, int> _sortedZones(Map<String, int> input) {
    final entries = input.entries.toList();
    entries.sort((a, b) {
      final ai = int.tryParse(a.key) ?? 0;
      final bi = int.tryParse(b.key) ?? 0;
      return ai.compareTo(bi);
    });
    return {for (final e in entries) e.key: e.value};
  }

  String _normZone(String s) {
    final lower = s.toLowerCase().trim();
    final m = RegExp(r"\d+").firstMatch(lower);
    if (m != null) return m.group(0)!;
    return lower;
  }

  Future<void> _loadMyEvaluations() async {
    try {
      Query query = FirebaseFirestore.instance
          .collection('evaluaciones_marcha')
          .orderBy('createdAt', descending: true)
          .limit(10);
      if (email.value.isNotEmpty) {
        query = query.where('evaluadorEmail', isEqualTo: email.value);
      } else if (nombre.value.isNotEmpty) {
        query = query.where('evaluadorNombre', isEqualTo: nombre.value);
      }
      final snap = await query.get();
      myEvaluations.assignAll(
        snap.docs.map((d) {
          final Map<String, dynamic> data = d.data() as Map<String, dynamic>;
          final m = Map<String, dynamic>.from(data);
          m['id'] = d.id;
          return m;
        }),
      );
      completedEvaluations.value = snap.size;
    } catch (_) {
      // keep previous values
    }
  }

  void _loadPendingFromStorage() {
    final box = GetStorage();
    final list = box.read('pending_sync_evaluaciones');
    if (list is List) {
      final casted = list
          .whereType<Map>()
          .map((m) => m.map((k, v) => MapEntry('$k', v)))
          .toList();
      pendingItems.assignAll(casted);
      pendingSync.value = casted.length;
    } else {
      pendingItems.clear();
      pendingSync.value = 0;
    }
  }

  Future<void> syncPendingNow() async {
    if (syncing.value) return;
    syncing.value = true;
    try {
      final box = GetStorage();
      final list = List<Map<String, dynamic>>.from(pendingItems);
      final stillPending = <Map<String, dynamic>>[];
      for (final item in list) {
        final docId = (item['docId'] ?? '') as String;
        final data = item['data'];
        if (docId.isEmpty || data is! Map<String, dynamic>) {
          continue;
        }
        try {
          final ref = FirebaseFirestore.instance
              .collection('evaluaciones_marcha')
              .doc(docId);
          await FirebaseFirestore.instance.runTransaction((t) async {
            final snap = await t.get(ref);
            if (snap.exists) {
              return;
            }
            t.set(ref, data);
          });
        } catch (_) {
          stillPending.add(item);
        }
      }
      pendingItems.assignAll(stillPending);
      pendingSync.value = stillPending.length;
      box.write('pending_sync_evaluaciones', stillPending);
      await _loadMyEvaluations();
    } finally {
      syncing.value = false;
    }
  }
}
