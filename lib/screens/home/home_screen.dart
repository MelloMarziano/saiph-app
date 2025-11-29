import 'package:dumcapp/screens/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
                          Obx(
                            () => Text(
                              controller.rol.value.isEmpty
                                  ? 'Usuario'
                                  : controller.rol.value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
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
                      Obx(
                        () => Text(
                          '¡Bienvenido, ${controller.nombre.value.isEmpty ? 'Usuario' : controller.nombre.value}!',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Camporee 2025 - Sistema de Evaluación',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _smallMetricCard(
                              controller.completedEvaluations,
                              'Evaluaciones',
                              Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _smallMetricCard(
                              controller.registeredClubs,
                              'Clubes',
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _smallMetricCard(
                              controller.pendingSync,
                              'Pendientes',
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => controller.pendingSync.value > 0
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: ElevatedButton.icon(
                                  onPressed: controller.syncing.value
                                      ? null
                                      : controller.syncPendingNow,
                                  icon: const Icon(Icons.sync),
                                  label: Text(
                                    controller.syncing.value
                                        ? 'Sincronizando…'
                                        : 'Sincronizar ahora',
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Clubes por zona',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => _zoneBarChart(controller.zoneCounts)),
                      const SizedBox(height: 12),
                      _actionTile(
                        color: Colors.indigo,
                        icon: Icons.assignment_turned_in,
                        title: 'Uniformidad',
                        subtitle: 'Evaluaciones por club',
                        onTap: () => Get.toNamed(AppRoutes.UNIFORMIDAD),
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
                        subtitle: 'Control de asistencia por eventos',
                        onTap: () => Get.toNamed(AppRoutes.PASE_LISTA),
                      ),
                      const SizedBox(height: 12),
                      _actionTile(
                        color: Colors.purple,
                        icon: Icons.flag,
                        title: 'Marcha',
                        subtitle: 'Módulo deshabilitado',
                        onTap: () => Get.snackbar(
                          'Módulo deshabilitado',
                          'Marcha no está habilitado',
                        ),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(height: 24),
                      const Text(
                        'Mis evaluaciones completadas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Column(
                          children: controller.myEvaluations
                              .map(
                                (e) => Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (e['pelotonNombre'] ?? '') as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Total: ${(e['totalParcial'] ?? 0)}',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Pendientes de sincronización',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Column(
                          children: controller.pendingItems
                              .map(
                                (e) => Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${(e['data']?['pelotonNombre'] ?? '')}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Evaluador: ${e['data']?['evaluadorNombre'] ?? e['data']?['evaluadorEmail'] ?? ''}',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.cloud_off,
                                        color: Colors.orange,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
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

  Widget _smallMetricCard(RxInt count, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              '${count.value}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _zoneBarChart(Map<String, int> data) {
    if (data.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: const Text('No hay datos'),
      );
    }
    final entries = data.entries.toList();
    final maxY = entries
        .map((e) => e.value)
        .fold<int>(0, (a, b) => a > b ? a : b)
        .toDouble();
    final palette = <Color>[
      Colors.deepPurple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.amber,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
    ];
    final groups = <BarChartGroupData>[];
    for (int i = 0; i < entries.length; i++) {
      final e = entries[i];
      final color = palette[i % palette.length];
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: e.value.toDouble(),
              color: color,
              width: 18,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
          // no tooltip indicators; números se muestran mediante topTitles
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            maxY: maxY + (maxY * 0.15),
            gridData: FlGridData(
              show: true,
              horizontalInterval: maxY <= 4 ? 1 : (maxY / 4).ceilToDouble(),
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 18,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= entries.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '${entries[i].value}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) => Text(
                    '${value.toInt()}',
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= entries.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Z${entries[i].key}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: groups,
          ),
        ),
      ),
    );
  }

  Widget _zonePieChart(Map<String, int> data) {
    if (data.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: const Text('No hay datos'),
      );
    }
    // total no requerido, se omiten labels dentro del gráfico
    final palette = <Color>[
      Colors.deepPurple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.amber,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
    ];
    final sections = <PieChartSectionData>[];
    int idx = 0;
    data.forEach((zone, count) {
      final color = palette[idx % palette.length];
      final value = count.toDouble();
      sections.add(
        PieChartSectionData(color: color, value: value, title: '', radius: 46),
      );
      idx++;
    });
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PieChart(
              PieChartData(
                sectionsSpace: 1,
                centerSpaceRadius: 28,
                sections: sections,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: _zoneLegend(data, palette)),
        ],
      ),
    );
  }

  List<Widget> _zoneLegend(Map<String, int> data, List<Color> palette) {
    final widgets = <Widget>[];
    int idx = 0;
    data.forEach((zone, count) {
      final color = palette[idx % palette.length];
      widgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              Text(
                'Z$zone ($count)',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
      idx++;
    });
    return widgets;
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
