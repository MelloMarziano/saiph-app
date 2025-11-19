import 'package:dumcapp/screens/marcha/marcha_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:dumcapp/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';

class MarchaScreen extends StatelessWidget {
  const MarchaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarchaController>(
      init: MarchaController(),
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: Obx(
            () => controller.selectedStyle.isEmpty
                ? _buildPelotonesList(controller)
                : _buildEvaluation(controller),
          ),
        ),
      ),
    );
  }

  Widget _buildPelotonesList(MarchaController controller) {
    final groups = controller.groupedByStyle;
    final order = controller.styleOrder;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.offNamed(AppRoutes.HOME),
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Volver al Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Seleccionar pelotón', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    for (final style in order)
                      if (groups[style]?.isNotEmpty == true) ...[
                        _styleHeader(style),
                        const SizedBox(height: 8),
                        ...groups[style]!.map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _pelotonTile(controller, p),
                            )),
                        const SizedBox(height: 12),
                      ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Obx(() => controller.isLoading.value
            ? Container(
                color: Colors.black.withValues(alpha: 0.15),
                child: const Center(child: CupertinoActivityIndicator(radius: 16)),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildEvaluation(MarchaController controller) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              GestureDetector(onTap: controller.clearSelection, child: const Icon(LucideIcons.arrow_left, color: Colors.white)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(controller.currentPeloton?.nombre ?? controller.selectedStyle.value,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  Text('Estilo: ${controller.selectedStyle.value}', style: const TextStyle(color: Colors.white70)),
                ]),
              ),
              Obx(() => Text('Total: ${controller.finalTotal} / ${controller.maxTotal}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
            ]),
          ),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(controller.selectedStyle.value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            Obx(() => Text('Total: ${controller.finalTotal} / ${controller.maxTotal}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 16),
        ]),
      ),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ...List.generate(controller.modules.length, (i) => _moduleRow(controller, i)),
            const SizedBox(height: 16),
            const Text('Faltas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            _faultRow(
              title: 'Faltas generales',
              subtitle: 'Cada falta resta 5 pts y descalifica',
              count: controller.generalFaults,
              onInc: () => controller.adjustGeneralFaults(1),
              onDec: () => controller.adjustGeneralFaults(-1),
            ),
            const SizedBox(height: 8),
            _penaltyText('Penalización general', controller.penaltyGeneral),
            const SizedBox(height: 12),
            _faultRow(
              title: 'Faltas del estilo',
              subtitle: 'Cada falta resta 2 pts (NO descalifica)',
              count: controller.styleFaults,
              onInc: () => controller.adjustStyleFaults(1),
              onDec: () => controller.adjustStyleFaults(-1),
            ),
            const SizedBox(height: 8),
            _penaltyText('Penalización por estilo', controller.penaltyStyle),
            const SizedBox(height: 24),
            Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Puntaje final: ${controller.finalTotal}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  if (controller.disqualified)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Text('DESCALIFICADO PARA CLASIFICACIÓN',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
                    ),
                ])),
            const SizedBox(height: 16),
          ]),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, border: const Border(top: BorderSide(color: Colors.black12))),
        child: Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  title: 'Confirmación',
                  middleText: '¿Reiniciar todos los puntos?',
                  textConfirm: 'Sí',
                  textCancel: 'No',
                  onConfirm: () {
                    controller.resetAll();
                    Get.back();
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: const Text('Reiniciar evaluación',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _pelotonTile(MarchaController controller, Peloton p) {
    final color = _styleColor(controller.styleKey(p.tipoMarcha));
    final icon = _styleIcon(controller.styleKey(p.tipoMarcha));
    return GestureDetector(
      onTap: () => controller.selectPeloton(p),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color.withValues(alpha: 0.8), color]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Instructor: ${p.instructor}', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 2),
                  Text('Estilo: ${p.tipoMarcha}', style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moduleRow(MarchaController controller, int index) {
    final m = controller.modules[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          _roundButton(color: Colors.red, icon: LucideIcons.minus, onTap: () => controller.adjustModule(index, -1)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Obx(
                  () => Text('Puntos: ${m.value.value} / ${m.max}', style: const TextStyle(color: Colors.black54)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _roundButton(color: Colors.green, icon: LucideIcons.plus, onTap: () => controller.adjustModule(index, 1)),
        ],
      ),
    );
  }

  Color _styleColor(String style) {
    switch (style) {
      case 'FANCY DRILL':
        return Colors.purple;
      case 'MILITARY DRILL':
        return Colors.blue;
      case 'SILENT DRILL':
        return Colors.green;
      case 'SOUNDTRACK':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _styleIcon(String style) {
    switch (style) {
      case 'FANCY DRILL':
        return LucideIcons.sparkles;
      case 'MILITARY DRILL':
        return LucideIcons.shield;
      case 'SILENT DRILL':
        return LucideIcons.volume_x;
      case 'SOUNDTRACK':
        return LucideIcons.music_2;
      default:
        return LucideIcons.flag;
    }
  }

  Widget _styleHeader(String style) {
    final color = _styleColor(style);
    final icon = _styleIcon(style);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(style, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _roundButton({required Color color, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(22)),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _faultRow({
    required String title,
    required String subtitle,
    required RxInt count,
    required VoidCallback onInc,
    required VoidCallback onDec,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          _roundButton(color: Colors.red, icon: LucideIcons.minus, onTap: onDec),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 6),
                Obx(() => Text('Cantidad: ${count.value}')),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _roundButton(color: Colors.green, icon: LucideIcons.plus, onTap: onInc),
        ],
      ),
    );
  }

  Widget _penaltyText(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Text('$label = $value'),
    );
  }
}
