import 'package:get/get.dart';

import 'marcha_controller.dart';

class MarchaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MarchaController());
  }
}
