import 'package:get/get.dart';
import 'uniformidad_controller.dart';

class UniformidadBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UniformidadController());
  }
}
