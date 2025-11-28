import 'package:dumcapp/screens/disciplina/disciplina_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dumcapp/routes/app_routes.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter/cupertino.dart';
import 'package:cool_alert/cool_alert.dart';

class DisciplinaScreen extends StatelessWidget {
  const DisciplinaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DisciplinaController>(
      init: DisciplinaController(),
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: Obx(
            () => controller.selectedClub.value == null
                ? _buildClubList(controller)
                : _buildDiscipline(context, controller),
          ),
        ),
      ),
    );
  }

  Widget _buildClubList(DisciplinaController controller) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: Colors.deepPurple,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.offNamed(AppRoutes.HOME),
                      child: const Icon(
                        LucideIcons.arrow_left,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Disciplina',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
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
                    const Text(
                      'Seleccionar club',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: controller.setSearch,
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre de club…',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _zoneChip(controller, label: 'Todas', value: ''),
                          const SizedBox(width: 8),
                          for (int i = 1; i <= 11; i++) ...[
                            _zoneChip(
                              controller,
                              label: 'Zona $i',
                              value: 'Zona $i',
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: controller.filteredClubs.isEmpty
                          ? [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: const Text(
                                  'No hay clubes disponibles',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ]
                          : controller.filteredClubs
                                .map(
                                  (c) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _clubTileSelectable(controller, c),
                                  ),
                                )
                                .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        controller.isLoading.value
            ? Container(
                color: Colors.black.withValues(alpha: 0.15),
                child: const Center(
                  child: CupertinoActivityIndicator(radius: 16),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildDiscipline(
    BuildContext context,
    DisciplinaController controller,
  ) {
    final club = controller.selectedClub.value!;
    final total = controller.totalDiscipline;
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: controller.clearSelection,
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
                          'Control de Disciplina',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          club.nombre,
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
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.nombre,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Director: ${club.director}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Zona: ${club.zona} • Miembros: ${club.cantidadMiembros}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '$total',
                      style: const TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Puntos de Disciplina',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _flagCard(
                      color: Colors.amber,
                      title: 'Falta Amarilla',
                      subtitle: 'Advertencia (0 pts) • 3 amarillas = 1 azul',
                      countFn: () => controller.yellow.value,
                      onDec: () => controller.adjustYellow(-1),
                      onInc: () => controller.adjustYellow(1),
                    ),
                    const SizedBox(height: 12),
                    _flagCard(
                      color: Colors.blue,
                      title: 'Falta Azul',
                      subtitle: '-10 puntos cada una',
                      countFn: () => controller.effectiveBlue,
                      onDec: () => controller.adjustBlue(-1),
                      onInc: () => controller.adjustBlue(1),
                    ),
                    const SizedBox(height: 12),
                    _flagCard(
                      color: Colors.red,
                      title: 'Falta Roja',
                      subtitle: '-25 puntos cada una • 4 rojas: pierden todo',
                      countFn: () => controller.red.value,
                      onDec: () => controller.adjustRed(-1),
                      onInc: () => controller.adjustRed(1),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.logs.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black12.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Registros de banderas',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...controller.logs.map(
                                    (log) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              _avatar(log.author),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  '${log.author} • ${_formatDate(log.createdAt)}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              _badge(
                                                'Amarillas',
                                                log.yellowCount,
                                                Colors.amber,
                                              ),
                                              const SizedBox(width: 8),
                                              _badge(
                                                'Azules',
                                                log.blueCount,
                                                Colors.blue,
                                              ),
                                              const SizedBox(width: 8),
                                              _badge(
                                                'Rojas',
                                                log.redCount,
                                                Colors.red,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            log.reason,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Razón de la bandera',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: controller.setReason,
                          decoration: InputDecoration(
                            hintText: 'Escribe el motivo…',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black12)),
              ),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.circle, color: Colors.amber),
                      const SizedBox(width: 4),
                      Obx(() => Text('${controller.totalYellow}')),
                      const SizedBox(width: 12),
                      const Icon(LucideIcons.circle, color: Colors.blue),
                      const SizedBox(width: 4),
                      Obx(() => Text('${controller.totalEffectiveBlue}')),
                      const SizedBox(width: 12),
                      const Icon(LucideIcons.circle, color: Colors.red),
                      const SizedBox(width: 4),
                      Obx(() => Text('${controller.totalRed}')),
                    ],
                  ),
                  const Spacer(),
                  Obx(
                    () => GestureDetector(
                      onTap: controller.isSubmitting.value
                          ? null
                          : () {
                              if (controller.reason.value.trim().isEmpty) {
                                Get.snackbar(
                                  'Razón requerida',
                                  'Debes escribir el motivo antes de enviar',
                                );
                                return;
                              }
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                title: 'Confirmación',
                                text: '¿Guardar esta entrada de disciplina?',
                                confirmBtnText: 'Guardar',
                                cancelBtnText: 'Cancelar',
                                showCancelBtn: true,
                                onConfirmBtnTap: () async {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                  await controller.submit();
                                },
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: controller.isSubmitting.value
                              ? Colors.black26
                              : Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: controller.isSubmitting.value
                            ? const Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Guardando...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Guardar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Obx(
          () => controller.isLogsLoading.value
              ? Container(
                  color: Colors.black.withValues(alpha: 0.15),
                  child: const Center(
                    child: CupertinoActivityIndicator(radius: 16),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
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
          _avatar(c.nombre, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Director: ${c.director}',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  'Zona: ${c.zona} • Miembros: ${c.cantidadMiembros}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _clubTileSelectable(DisciplinaController controller, Club c) {
    return GestureDetector(
      onTap: () => controller.selectClub(c),
      child: _clubTileWithBadge(controller, c),
    );
  }

  Widget _clubTileWithBadge(DisciplinaController controller, Club c) {
    controller.loadClubFlagSummary(c.id);
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
          _avatar(c.nombre, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Director: ${c.director}',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  'Zona: ${c.zona} • Miembros: ${c.cantidadMiembros}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Obx(() {
            final s = controller.clubFlags[c.id];
            if (s == null) return const SizedBox.shrink();
            final items = <Widget>[];
            if (s.yellow > 0) {
              items.add(_colorCountBadge(Colors.amber, s.yellow));
            }
            if (s.blue > 0) {
              if (items.isNotEmpty) items.add(const SizedBox(width: 6));
              items.add(_colorCountBadge(Colors.blue, s.blue));
            }
            if (s.red > 0) {
              if (items.isNotEmpty) items.add(const SizedBox(width: 6));
              items.add(_colorCountBadge(Colors.red, s.red));
            }
            if (items.isEmpty) return const SizedBox.shrink();
            return Row(children: items);
          }),
        ],
      ),
    );
  }

  Widget _countBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.6)),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _colorCountBadge(Color color, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
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
            '$count',
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _flagCard({
    required Color color,
    required String title,
    required String subtitle,
    required int Function() countFn,
    required VoidCallback onDec,
    required VoidCallback onInc,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
            () => Text(
              '${countFn()}',
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roundButton(
                color: Colors.red,
                icon: LucideIcons.minus,
                onTap: onDec,
              ),
              const SizedBox(width: 12),
              _roundButton(
                color: Colors.green,
                icon: LucideIcons.plus,
                onTap: onInc,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundButton({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
        ),
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

  Widget _zoneChip(
    DisciplinaController controller, {
    required String label,
    required String value,
  }) {
    final selected =
        (controller.zoneFilter.value.isEmpty && value.isEmpty) ||
        controller.zoneFilter.value == value;
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _avatar(String name, {double size = 32}) {
    final bg = _avatarColorFor(name);
    final initials = _initials(name);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _badge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
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
            '$label: $count',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Color _avatarColorFor(String seed) {
    final palette = [
      Colors.deepPurple,
      Colors.indigo,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.blueGrey,
      Colors.cyan,
      Colors.green,
      Colors.redAccent,
      Colors.amber,
    ];
    final code = seed.codeUnits.fold<int>(0, (a, b) => a + b);
    return palette[code % palette.length];
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    final a = parts.first[0];
    final b = parts.length > 1 ? parts.last[0] : '';
    return (a + b).toUpperCase();
  }
}
