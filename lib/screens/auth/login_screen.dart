import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dumcapp/routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_loading) return;
    final email = _emailCtrl.text.trim().toLowerCase();
    final pass = _passCtrl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      if (!mounted) return;
      await CoolAlert.show(context: context, type: CoolAlertType.warning, title: 'Faltan datos', text: 'Ingresa correo y contraseña para continuar');
      return;
    }
    setState(() => _loading = true);
    try {
      final q = await FirebaseFirestore.instance.collection('usuarios').where('email', isEqualTo: email).limit(1).get();
      if (q.docs.isEmpty) {
        if (!mounted) return;
        await CoolAlert.show(context: context, type: CoolAlertType.error, title: 'No pudimos iniciar sesión', text: 'No encontramos una cuenta con ese correo. Verifica el correo o contacta al coordinador.');
      } else {
        final doc = q.docs.first;
        final d = doc.data();
        final ok = (d['password'] ?? '') == pass;
        if (!ok) {
          if (!mounted) return;
          await CoolAlert.show(context: context, type: CoolAlertType.error, title: 'Contraseña incorrecta', text: 'La contraseña no coincide. Intenta nuevamente o solicita restablecer tu acceso.');
        } else {
          final box = GetStorage();
          await box.write('user', {
            'id': doc.id,
            'email': email,
            'nombre': d['nombre'] ?? '',
            'rol': d['rol'] ?? '',
          });
          if (!mounted) return;
          await CoolAlert.show(context: context, type: CoolAlertType.success, title: 'Bienvenido', text: '${d['nombre'] ?? email}');
          Get.offAllNamed(AppRoutes.HOME);
        }
      }
    } catch (e) {
      if (!mounted) return;
      await CoolAlert.show(context: context, type: CoolAlertType.error, title: 'No pudimos iniciar sesión', text: 'Ocurrió un problema de conexión o de servidor. Intenta de nuevo y si persiste, contacta al coordinador.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(colors: [Color(0xFF5B2DFF), Color(0xFFFF6B6B)]);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 8))]),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF5B2DFF), borderRadius: BorderRadius.circular(12))),
                const SizedBox(width: 12),
                const Expanded(child: Text('Camporee 2025', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
              ]),
              const SizedBox(height: 16),
              const Text('Inicia sesión', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Correo', hintText: 'ejemplo@correo.com', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B2DFF), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Entrar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 8),
              const Align(alignment: Alignment.center, child: Text('DUMC APP 2025', style: TextStyle(color: Colors.black54))),
            ]),
          ),
        ),
      ),
    );
  }
}