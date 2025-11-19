import 'package:get/get.dart';

class HomeController extends GetxController {
  final completedEvaluations = 0.obs;
  final registeredClubs = 5.obs;
  final pendingSync = 0.obs;

  void onSignOut() {
    Get.snackbar('Sesión', 'Has cerrado sesión');
  }
}
