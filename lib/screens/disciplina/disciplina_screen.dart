import 'package:dumcapp/screens/disciplina/disciplina_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dumcapp/routes/app_routes.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter/cupertino.dart';

class DisciplinaScreen extends StatelessWidget {
  const DisciplinaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DisciplinaController>(
      init: DisciplinaController(),
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: Obx(() => controller.selectedClub.value == null
              ? _buildClubList(controller)
              : _buildDiscipline(context, controller)),
        ),
      ),
    );
  }

  Widget _buildClubList(DisciplinaController controller) {
    return Stack(children: [
      SingleChildScrollView(child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.deepPurple,
          child: Row(children: [
            GestureDetector(onTap: () => Get.offNamed(AppRoutes.HOME), child: const Icon(LucideIcons.arrow_left, color: Colors.white)),
            const SizedBox(width: 8),
            const Text('Disciplina', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Seleccionar club', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Column(children: controller.clubes.isEmpty
                ? [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                      child: const Text('No hay clubes disponibles', style: TextStyle(color: Colors.black54)),
                    ),
                  ]
                : controller.clubes
                    .map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _clubTileSelectable(controller, c)))
                    .toList()),
          ]),
        ),
      ])),
      controller.isLoading.value
          ? Container(color: Colors.black.withValues(alpha: 0.15), child: const Center(child: CupertinoActivityIndicator(radius: 16)))
          : const SizedBox.shrink(),
    ]);
  }

  Widget _buildDiscipline(BuildContext context, DisciplinaController controller) {
    final club = controller.selectedClub.value!;
    final total = controller.totalDiscipline;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          GestureDetector(onTap: controller.clearSelection, child: const Icon(LucideIcons.arrow_left, color: Colors.black)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Control de Disciplina', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text(club.nombre, style: const TextStyle(color: Colors.black54)),
          ])),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFFB388FF)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: [
            Text('$total', style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Puntos de Disciplina', style: TextStyle(color: Colors.white)),
          ]),
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            _flagCard(
              color: Colors.amber,
              title: 'Falta Amarilla',
              subtitle: 'Advertencia (0 pts) • 3 amarillas = 1 azul',
              count: controller.yellow,
              onDec: () => controller.adjustYellow(-1),
              onInc: () => controller.adjustYellow(1),
            ),
            const SizedBox(height: 12),
            _flagCard(
              color: Colors.blue,
              title: 'Falta Azul',
              subtitle: '-10 puntos cada una',
              count: controller.blue,
              onDec: () => controller.adjustBlue(-1),
              onInc: () => controller.adjustBlue(1),
            ),
            const SizedBox(height: 12),
            _flagCard(
              color: Colors.red,
              title: 'Falta Roja',
              subtitle: '-25 puntos cada una • 4 rojas: pierden todo',
              count: controller.red,
              onDec: () => controller.adjustRed(-1),
              onInc: () => controller.adjustRed(1),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (controller.logs.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.black12.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Registros de banderas', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        ...controller.logs.map((log) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [
                                  const Icon(LucideIcons.circle, color: Colors.amber, size: 14), const SizedBox(width: 4), Text('${log.yellowCount}'),
                                  const SizedBox(width: 12),
                                  const Icon(LucideIcons.circle, color: Colors.blue, size: 14), const SizedBox(width: 4), Text('${log.blueCount}'),
                                  const SizedBox(width: 12),
                                  const Icon(LucideIcons.circle, color: Colors.red, size: 14), const SizedBox(width: 4), Text('${log.redCount}'),
                                  const Spacer(),
                                  Text('${log.author} • ${_formatDate(log.createdAt)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                ]),
                                const SizedBox(height: 6),
                                Text(log.reason, style: const TextStyle(color: Colors.black87)),
                              ]),
                            )),
                      ]),
                    ),
                ])),
            const SizedBox(height: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Razón de la bandera', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Obx(() => TextField(
                    onChanged: controller.setReason,
                    decoration: InputDecoration(
                      hintText: 'Escribe el motivo…',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  )),
            ]),
          ]),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
        child: Row(children: [
          Row(children: [
            const Icon(LucideIcons.circle, color: Colors.amber), const SizedBox(width: 4), Obx(() => Text('${controller.yellow.value}')),
            const SizedBox(width: 12),
            const Icon(LucideIcons.circle, color: Colors.blue), const SizedBox(width: 4), Obx(() => Text('${controller.effectiveBlue}')),
            const SizedBox(width: 12),
            const Icon(LucideIcons.circle, color: Colors.red), const SizedBox(width: 4), Obx(() => Text('${controller.red.value}')),
          ]),
          const Spacer(),
          Obx(() => GestureDetector(
                onTap: controller.isSubmitting.value
                    ? null
                    : () {
                        if (controller.reason.value.trim().isEmpty) {
                          Get.snackbar('Razón requerida', 'Debes escribir el motivo antes de enviar');
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirmación'),
                            content: const Text('¿Guardar esta entrada de disciplina?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await controller.submit();
                                },
                                child: const Text('Guardar'),
                              ),
                            ],
                          ),
                        );
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.isSubmitting.value ? Colors.black26 : Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: controller.isSubmitting.value
                      ? const Row(children: [
                          SizedBox(width: 18, height: 18, child: CupertinoActivityIndicator()),
                          SizedBox(width: 8),
                          Text('Guardando...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ])
                      : const Text('Enviar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              )),
        ]),
      ),
    ]);
  }

  Widget _clubTile(Club c) {
    return Container(
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
            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
            child: const Icon(LucideIcons.shield_alert, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Director: ${c.director}', style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 2),
              Text('Zona: ${c.zona} • Miembros: ${c.cantidadMiembros}', style: const TextStyle(color: Colors.black54)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _clubTileSelectable(DisciplinaController controller, Club c) {
    return GestureDetector(onTap: () => controller.selectClub(c), child: _clubTile(c));
  }

  Widget _flagCard({required Color color, required String title, required String subtitle, required RxInt count, required VoidCallback onDec, required VoidCallback onInc}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.6))),
      child: Column(children: [
        Row(children: [Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 8), Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700)), const Spacer(), Text(subtitle, style: const TextStyle(color: Colors.black54))]),
        const SizedBox(height: 12),
        Obx(() => Text('${count.value}', style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.w800))),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _roundButton(color: Colors.red, icon: LucideIcons.minus, onTap: onDec),
          const SizedBox(width: 12),
          _roundButton(color: Colors.green, icon: LucideIcons.plus, onTap: onInc),
        ])
      ]),
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

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    final d = two(dt.day);
    final m = two(dt.month);
    final y = dt.year.toString();
    final hh = two(dt.hour);
    final mm = two(dt.minute);
    return '$d/$m/$y $hh:$mm';
  }
}