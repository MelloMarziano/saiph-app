import 'package:dumcapp/screens/marcha/marcha_binding.dart';
import 'package:dumcapp/screens/marcha/marcha_screen.dart';
import 'package:dumcapp/screens/marcha/evaluacion_screen.dart';
import 'package:get/get.dart';

import '../screens/home/home_binding.dart';
import '../screens/home/home_screen.dart';
import '../screens/disciplina/disciplina_binding.dart';
import '../screens/disciplina/disciplina_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.MARCHA,
      page: () => const MarchaScreen(),
      binding: MarchaBinding(),
    ),
    GetPage(
      name: AppRoutes.MARCHA_EVALUACION,
      page: () => const EvaluacionMarchaScreen(),
    ),
    GetPage(
      name: AppRoutes.DISCIPLINA,
      page: () => const DisciplinaScreen(),
      binding: DisciplinaBinding(),
    ),

    // GetPage(
    //   name: AppRoutes.REGISTER,
    //   page: () => const RegisterScreen(),
    //   binding: RegisterBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.PROFILE,
    //   page: () => const ProfileScreen(),
    //   // Perfil simple: no binding dedicado, el controlador puede inicializarse en pantalla si se requiere
    // ),
    // GetPage(
    //   name: AppRoutes.CONFIGURACION,
    //   page: () => const ConfiguracionScreen(),
    //   binding: ConfiguracionBinding(),
    // ),
  ];
}
