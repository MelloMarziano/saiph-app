import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'pase_lista_controller.dart';

class PaseListaScreen extends StatelessWidget {
  const PaseListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaseListaController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Obx(() {
        final selected = controller.selected.value;
        return selected == null
            ? _eventList(context, controller)
            : _eventDetail(context, controller, selected);
      }),
    );
  }

  Widget _eventList(BuildContext context, PaseListaController controller) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    LucideIcons.arrow_left,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Pase de Lista',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.eventosLoading.value) {
                return const Center(child: CupertinoActivityIndicator());
              }
              if (controller.eventos.isEmpty) {
                return const Center(child: Text('No hay eventos'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.eventos.length,
                itemBuilder: (_, i) {
                  final e = controller.eventos[i];
                  return GestureDetector(
                    onTap: () => controller.selectEvento(e),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.calendar_days,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.nombre,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${e.fecha} • ${e.hora}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          _pill('Presentes', e.presentes, Colors.green),
                          const SizedBox(width: 8),
                          _pill('Ausentes', e.ausentes, Colors.red),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _eventDetail(
    BuildContext context,
    PaseListaController controller,
    PaseEvento e,
  ) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.selected.value = null,
                      child: const Icon(
                        LucideIcons.arrow_left,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.nombre,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${e.fecha} • ${e.hora}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _zoneChips(controller),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.clubesLoading.value) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  final list = controller.filteredClubs;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final c = list[i];
                      return Obx(() {
                        final isAusente = controller.ausentes.contains(c.id);
                        return GestureDetector(
                          onTap: () => controller.toggleAusente(c),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isAusente
                                  ? Colors.red.withOpacity(0.06)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isAusente
                                    ? Colors.red.withOpacity(0.4)
                                    : Colors.black12,
                              ),
                            ),
                            child: Row(
                              children: [
                                _avatar(c.nombre),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Zona ${_normZone(c.zona)}',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isAusente
                                        ? Colors.red
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isAusente ? 'Ausente' : 'Presente',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.black12)),
                ),
                child: Row(
                  children: [
                    Obx(
                      () => _pill(
                        'Presentes',
                        controller.totalPresentes,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => _pill(
                        'Ausentes',
                        controller.totalAusentes,
                        Colors.red,
                      ),
                    ),
                    const Spacer(),
                    Obx(() {
                      final locked = controller.completado.value;
                      return GestureDetector(
                        onTap: locked
                            ? null
                            : () async {
                                await controller.guardarPase();
                                Get.snackbar(
                                  'Guardado',
                                  'Evento marcado como Completado',
                                );
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: locked ? Colors.black12 : Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            locked ? 'Completado' : 'Guardar pase',
                            style: TextStyle(
                              color: locked ? Colors.black54 : Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _zoneChips(PaseListaController controller) {
    final zones =
        controller.clubes.map((c) => _normZone(c.zona)).toSet().toList()..sort(
          (a, b) => (int.tryParse(a) ?? 0).compareTo(int.tryParse(b) ?? 0),
        );
    final widgets = <Widget>[];
    widgets.add(_zoneChip(controller, label: 'Todas', value: ''));
    for (final z in zones) {
      widgets.add(_zoneChip(controller, label: 'Zona $z', value: z));
    }
    return widgets;
  }

  Widget _zoneChip(
    PaseListaController controller, {
    required String label,
    required String value,
  }) {
    final selected =
        (controller.zoneFilter.value.isEmpty && value.isEmpty) ||
        (controller.zoneFilter.value == value);
    return GestureDetector(
      onTap: () => controller.setZone(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.deepPurple : Colors.black12,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _pill(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String name) {
    final t = _initials(name);
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(21),
      ),
      alignment: Alignment.center,
      child: Text(
        t,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final a = parts.isNotEmpty ? parts.first.characters.first : '?';
    final b = parts.length > 1 ? parts[1].characters.first : '';
    return (a + b).toUpperCase();
  }

  String _normZone(String s) {
    final lower = s.toLowerCase().trim();
    final m = RegExp(r"\d+").firstMatch(lower);
    if (m != null) return m.group(0)!;
    return lower;
  }
}
