import 'package:dumcapp/screens/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dumcapp/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.wifi, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Conectado',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Obx(() => Text(
                                controller.rol.value.isEmpty ? 'Usuario' : controller.rol.value,
                                style: const TextStyle(color: Colors.white),
                              )),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: controller.onSignOut,
                            child: const Text(
                              'Salir',
                              style: TextStyle(color: Colors.amber),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            '¡Bienvenido, ${controller.nombre.value.isEmpty ? 'Usuario' : controller.nombre.value}!',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          )),
                      const SizedBox(height: 8),
                      const Text(
                        'Camporee 2025 - Sistema de Evaluación',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      _metricCard(
                        controller.completedEvaluations,
                        'Evaluaciones completadas',
                        Colors.deepPurple,
                      ),
                      const SizedBox(height: 12),
                      _metricCard(
                        controller.registeredClubs,
                        'Clubes registrados',
                        Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _metricCard(
                        controller.pendingSync,
                        'Pendientes de sincronización',
                        Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      Obx(() => controller.pendingSync.value > 0
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton.icon(
                                onPressed: controller.syncing.value ? null : controller.syncPendingNow,
                                icon: const Icon(Icons.sync),
                                label: Text(controller.syncing.value ? 'Sincronizando…' : 'Sincronizar ahora'),
                              ),
                            )
                          : const SizedBox.shrink()),
                      const SizedBox(height: 24),
                      _actionTile(
                        color: Colors.blue,
                        icon: Icons.assignment,
                        title: 'Evaluación Uniformidad',
                        subtitle: 'Evalúa diseño, insignias y presentación',
                        onTap: () => Get.snackbar('Acceso', 'Uniformidad'),
                      ),
                      const SizedBox(height: 12),
                      _actionTile(
                        color: Colors.orange,
                        icon: Icons.warning_amber_rounded,
                        title: 'Disciplina',
                        subtitle: 'Registra faltas y sistema de crédito',
                        onTap: () => Get.toNamed(AppRoutes.DISCIPLINA),
                      ),
                      const SizedBox(height: 12),
                      _actionTile(
                        color: Colors.green,
                        icon: Icons.groups,
                        title: 'Pase de Lista',
                        subtitle: 'Control de asistencia en 10 eventos',
                        onTap: () => Get.snackbar('Acceso', 'Pase de Lista'),
                      ),
                      const SizedBox(height: 12),
                      _actionTile(
                        color: Colors.purple,
                        icon: Icons.flag,
                        title: 'Marcha',
                        subtitle: 'Evaluación de participación y orden',
                        onTap: () => Get.toNamed(AppRoutes.MARCHA),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Clubes registrados',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Column(
                            children: controller.clubs
                                .map((c) => Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.black12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(c.nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
                                                const SizedBox(height: 2),
                                                Text('Instructor: ${c.instructor}', style: const TextStyle(color: Colors.black54)),
                                              ],
                                            ),
                                          ),
                                          Text(c.tipoMarcha, style: const TextStyle(color: Colors.deepPurple)),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          )),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.MARCHA),
                          child: const Text('Ver todos'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Mis evaluaciones completadas',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Column(
                            children: controller.myEvaluations
                                .map((e) => Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.black12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text((e['pelotonNombre'] ?? '') as String, style: const TextStyle(fontWeight: FontWeight.w700)),
                                          const SizedBox(height: 2),
                                          Text('Total: ${(e['totalParcial'] ?? 0)}', style: const TextStyle(color: Colors.black54)),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          )),
                      const SizedBox(height: 24),
                      const Text(
                        'Pendientes de sincronización',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Column(
                            children: controller.pendingItems
                                .map((e) => Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.black12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${(e['data']?['pelotonNombre'] ?? '')}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                                const SizedBox(height: 2),
                                                Text('Evaluador: ${e['data']?['evaluadorNombre'] ?? e['data']?['evaluadorEmail'] ?? ''}', style: const TextStyle(color: Colors.black54)),
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.cloud_off, color: Colors.orange),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _metricCard(RxInt count, String label, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              '${count.value}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.8), color],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Text(
                        'Comenzar evaluación',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_right_alt, color: Colors.deepPurple),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
