import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'uniformidad_controller.dart';

class UniformidadScreen extends StatelessWidget {
  const UniformidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UniformidadController>();
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedClub.value != null) {
          controller.selectedClub.value = null;
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: Obx(() {
          final selected = controller.selectedClub.value;
          return selected == null
              ? _clubList(context, controller)
              : _clubDetail(context, controller, selected);
        }),
      ),
    );
  }

  Widget _clubList(BuildContext context, UniformidadController controller) {
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
                  'Uniformidad',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CupertinoActivityIndicator());
              }
              if (controller.clubes.isEmpty) {
                return const Center(child: Text('No hay clubes'));
              }
              final zones =
                  controller.clubes
                      .map((c) => _normZone(c.zona))
                      .toSet()
                      .toList()
                    ..sort(
                      (a, b) => (int.tryParse(a) ?? 0).compareTo(
                        int.tryParse(b) ?? 0,
                      ),
                    );
              final children = <Widget>[];
              for (final z in zones) {
                children.add(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Text(
                      'Zona $z',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
                final clubsZ = controller.clubes
                    .where((c) => _normZone(c.zona) == z)
                    .toList();
                for (final c in clubsZ) {
                  final st = controller.statusByClub[c.id];
                  final status = st?.status ?? 'Pendiente';
                  final total = st?.total ?? 100;
                  final color = status.toLowerCase() == 'completado'
                      ? Colors.green
                      : Colors.orange;
                  children.add(
                    GestureDetector(
                      onTap: () => controller.abrirClub(c),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Row(
                          children: [
                            _avatar(c.nombre),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Status: $status',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: color.withOpacity(0.6),
                                ),
                              ),
                              child: Text(
                                '$total',
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
              return ListView(children: children);
            }),
          ),
        ],
      ),
    );
  }

  Widget _clubDetail(
    BuildContext context,
    UniformidadController controller,
    Club c,
  ) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.selectedClub.value != null) {
                      controller.selectedClub.value = null;
                    } else {
                      Get.back();
                    }
                  },
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
                        c.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Zona ${_normZone(c.zona)}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  final locked = controller.completado.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: locked
                          ? Colors.green.withOpacity(0.12)
                          : Colors.orange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (locked ? Colors.green : Colors.orange)
                            .withOpacity(0.6),
                      ),
                    ),
                    child: Text(
                      locked ? 'Completado' : 'Pendiente',
                      style: TextStyle(
                        color: locked ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final items = controller.renglones;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final r = items[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                r.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              '${r.maxPuntos} pts',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          final locked = controller.completado.value;
                          return Row(
                            children: [
                              const Text('Quitar:'),
                              const SizedBox(width: 8),
                              _stepper(
                                value: r.deduc,
                                max: r.maxPuntos,
                                onChanged: locked
                                    ? null
                                    : (v) => controller.setDeduccion(r, v),
                              ),
                              const Spacer(),
                              Text(
                                'Restan ${(r.maxPuntos - r.deduc)}',
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 8),
                        Obx(() {
                          final needComment = r.deduc > 0;
                          final locked = controller.completado.value;
                          if (!needComment) return const SizedBox.shrink();
                          return TextFormField(
                            enabled: !locked,
                            initialValue: r.comentario,
                            onChanged: (t) => controller.setComentario(r, t),
                            maxLines: 2,
                            decoration: const InputDecoration(
                              hintText:
                                  'Comentario obligatorio al quitar puntos',
                              border: OutlineInputBorder(),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
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
                  () =>
                      _pill('Total', controller.total.value, Colors.deepPurple),
                ),
                const Spacer(),
                Obx(() {
                  final locked = controller.completado.value;
                  return GestureDetector(
                    onTap: locked
                        ? null
                        : () async {
                            await controller.guardarEvaluacion();
                            Get.snackbar(
                              'Guardado',
                              'Evaluación de uniformidad guardada',
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
                        locked ? 'Completado' : 'Guardar evaluación',
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
    );
  }

  Widget _stepper({
    required int value,
    required int max,
    required ValueChanged<int>? onChanged,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onChanged == null
              ? null
              : () => onChanged((value + 1).clamp(0, max)),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Text('-'),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text('$value'),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onChanged == null
              ? null
              : () => onChanged((value - 1).clamp(0, max)),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Text('+'),
          ),
        ),
      ],
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
        color: Colors.deepPurple.withOpacity(0.12),
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
