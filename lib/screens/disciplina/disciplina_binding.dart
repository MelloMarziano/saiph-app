import 'package:get/get.dart';

import 'disciplina_controller.dart';

class DisciplinaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DisciplinaController>(() => DisciplinaController());
  }
}