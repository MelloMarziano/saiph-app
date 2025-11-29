import 'package:get/get.dart';
import 'pase_lista_controller.dart';

class PaseListaBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PaseListaController());
  }
}
