import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dumcapp/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final box = GetStorage();
    final user = box.read('user');
    if (user is Map && (user['email'] ?? '').toString().isNotEmpty) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(colors: [Color(0xFF5B2DFF), Color(0xFFFF6B6B)]);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.flag, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 12),
              const Text('Camporee 2025', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('DUMC APP', style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            ],
          ),
        ),
      ),
    );
  }
}