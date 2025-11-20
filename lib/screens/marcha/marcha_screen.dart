import 'package:dumcapp/screens/marcha/marcha_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
 
import 'package:dumcapp/routes/app_routes.dart';

class MarchaScreen extends StatelessWidget {
  const MarchaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarchaController>(
      init: MarchaController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('Marcha', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.offNamed(AppRoutes.HOME),
          ),
          actions: const [],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error.isNotEmpty) {
            return Center(child: Text('Error: ${controller.error.value}'));
          }
          final list = controller.pelotones;
          if (list.isEmpty) {
            return const Center(child: Text('No hay pelotones'));
          }
          final grouped = <String, List<Peloton>>{};
          for (final p in list) {
            final key = _styleKey(p.tipoMarcha);
            grouped.putIfAbsent(key, () => []);
            grouped[key]!.add(p);
          }
          final order = const ['FANCY DRILL', 'MILITARY DRILL', 'SILENT DRILL', 'SOUNDTRACK'];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (final style in order)
                if (grouped[style]?.isNotEmpty == true) ...[
                  _styleHeader(style),
                  const SizedBox(height: 8),
                  ...grouped[style]!.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.MARCHA_EVALUACION, arguments: p),
                          child: _pelotonTile(p),
                        ),
                      )),
                  const SizedBox(height: 12),
                ],
            ]),
          );
        }),
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

  String _styleKey(String raw) {
    final r = raw.trim().toUpperCase();
    if (r.contains('FANCY')) return 'FANCY DRILL';
    if (r.contains('MILITARY')) return 'MILITARY DRILL';
    if (r.contains('SILENT')) return 'SILENT DRILL';
    if (r.contains('SOUND')) return 'SOUNDTRACK';
    return r;
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
      child: Row(children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(style, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _pelotonTile(Peloton p) {
    final style = _styleKey(p.tipoMarcha);
    final color = _styleColor(style);
    final icon = _styleIcon(style);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]),
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withValues(alpha: 0.8), color]), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Instructor: ${p.instructor}', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 2),
          Text('Estilo: ${p.tipoMarcha}', style: const TextStyle(color: Colors.black54)),
          if (p.createdAt != null) Text('Creado: ${_formatDate(p.createdAt!)}', style: const TextStyle(color: Colors.black38)),
        ])),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
          child: Text('${p.cantidadMiembros} miembros', style: TextStyle(fontWeight: FontWeight.w700, color: color)),
        ),
      ]),
    );
  }
        

  

  

  

  

  

  
}
