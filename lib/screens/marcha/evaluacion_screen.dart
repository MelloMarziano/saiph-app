import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'marcha_controller.dart';
import '../../routes/app_routes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cool_alert/cool_alert.dart';

class EvaluacionMarchaScreen extends StatefulWidget {
  const EvaluacionMarchaScreen({super.key});

  @override
  State<EvaluacionMarchaScreen> createState() => _EvaluacionMarchaScreenState();
}

class _Item {
  final String name;
  final int max;
  int value;
  final TextEditingController comment;
  _Item(this.name, this.max)
      : value = 0,
        comment = TextEditingController();
}

class _Exhibicion {
  final int index;
  int pliegue;
  int deformaciones;
  final TextEditingController comment;
  final TextEditingController commentPliegue;
  final TextEditingController commentDeformaciones;
  _Exhibicion(this.index)
      : pliegue = 0,
        deformaciones = 0,
        comment = TextEditingController(),
        commentPliegue = TextEditingController(),
        commentDeformaciones = TextEditingController();
}

class _ExhibicionMS {
  final int index;
  int pliegue;
  int creatividad;
  final TextEditingController comment;
  final TextEditingController commentPliegue;
  final TextEditingController commentCreatividad;
  _ExhibicionMS(this.index)
      : pliegue = 0,
        creatividad = 0,
        comment = TextEditingController(),
        commentPliegue = TextEditingController(),
        commentCreatividad = TextEditingController();
}

class _InnovacionF {
  final int index;
  int originalidad;
  int ejecucion;
  int composicion;
  final TextEditingController comment;
  final TextEditingController commentOriginalidad;
  final TextEditingController commentEjecucion;
  final TextEditingController commentComposicion;
  _InnovacionF(this.index)
      : originalidad = 0,
        ejecucion = 0,
        composicion = 0,
        comment = TextEditingController(),
        commentOriginalidad = TextEditingController(),
        commentEjecucion = TextEditingController(),
        commentComposicion = TextEditingController();
}

class _InnovacionM {
  final int index;
  int originalidad;
  int plenas;
  int cadencias;
  int intervalos;
  int contramarcha;
  final TextEditingController comment;
  final TextEditingController commentOriginalidad;
  final TextEditingController commentPlenas;
  final TextEditingController commentCadencias;
  final TextEditingController commentIntervalos;
  final TextEditingController commentContramarcha;
  _InnovacionM(this.index)
      : originalidad = 0,
        plenas = 0,
        cadencias = 0,
        intervalos = 0,
        contramarcha = 0,
        comment = TextEditingController(),
        commentOriginalidad = TextEditingController(),
        commentPlenas = TextEditingController(),
        commentCadencias = TextEditingController(),
        commentIntervalos = TextEditingController(),
        commentContramarcha = TextEditingController();
}

 

class _GradoF {
  final int index;
  int tiempos;
  int deformacion;
  final TextEditingController comment;
  final TextEditingController commentTiempos;
  final TextEditingController commentDeformacion;
  _GradoF(this.index)
      : tiempos = 0,
        deformacion = 0,
        comment = TextEditingController(),
        commentTiempos = TextEditingController(),
        commentDeformacion = TextEditingController();
}

class _ImpactoF {
  final int index;
  int valor;
  final TextEditingController comment;
  _ImpactoF(this.index)
      : valor = 0,
        comment = TextEditingController();
}

class _PrecisionF {
  final int index;
  int valor;
  final TextEditingController comment;
  _PrecisionF(this.index)
      : valor = 0,
        comment = TextEditingController();
}

class _GradoM {
  final int index;
  int valor;
  final TextEditingController comment;
  _GradoM(this.index)
      : valor = 0,
        comment = TextEditingController();
}

class _PrecisionM {
  final int index;
  int valor;
  final TextEditingController comment;
  _PrecisionM(this.index)
      : valor = 0,
        comment = TextEditingController();
}

class _GradoS {
  final int index;
  int valor;
  final TextEditingController comment;
  _GradoS(this.index)
      : valor = 0,
        comment = TextEditingController();
}

class _PrecisionS {
  final int index;
  int valor;
  final TextEditingController comment;
  _PrecisionS(this.index)
      : valor = 0,
        comment = TextEditingController();
}

class _GradoT {
  final int index;
  int tiempos;
  int deformacion;
  final TextEditingController comment;
  final TextEditingController commentTiempos;
  final TextEditingController commentDeformacion;
  _GradoT(this.index)
      : tiempos = 0,
        deformacion = 0,
        comment = TextEditingController(),
        commentTiempos = TextEditingController(),
        commentDeformacion = TextEditingController();
}

class _ImpactoT {
  final int index;
  int valor;
  final TextEditingController comment;
  _ImpactoT(this.index)
      : valor = 0,
        comment = TextEditingController();
}

class _PrecisionT {
  final int index;
  int valor;
  final TextEditingController comment;
  _PrecisionT(this.index)
      : valor = 0,
        comment = TextEditingController();
}

class _SyncT {
  final int index;
  int valor;
  final TextEditingController comment;
  _SyncT(this.index)
      : valor = 0,
        comment = TextEditingController();
}

class _FaltaItem {
  final String name;
  bool selected;
  _FaltaItem(this.name) : selected = false;
}

class _InnovacionS {
  final int index;
  int originalidadBordon;
  int intervalos;
  final TextEditingController comment;
  final TextEditingController commentOriginalidadBordon;
  final TextEditingController commentIntervalos;
  _InnovacionS(this.index)
      : originalidadBordon = 0,
        intervalos = 0,
        comment = TextEditingController(),
        commentOriginalidadBordon = TextEditingController(),
        commentIntervalos = TextEditingController();
}

class _InnovacionT {
  final int index;
  int originalidad;
  int ejecucion;
  final TextEditingController comment;
  final TextEditingController commentOriginalidad;
  final TextEditingController commentEjecucion;
  _InnovacionT(this.index)
      : originalidad = 0,
        ejecucion = 0,
        comment = TextEditingController(),
        commentOriginalidad = TextEditingController(),
        commentEjecucion = TextEditingController();
}

class _EvaluacionMarchaScreenState extends State<EvaluacionMarchaScreen> {
  Peloton? _peloton;
  List<_Item> _items = [];
  List<_Exhibicion> _exhibicionesFS = [];
  List<_ExhibicionMS> _exhibicionesMS = [];
  List<_InnovacionF> _innovacionesF = [];
  List<_InnovacionM> _innovacionesM = [];
  List<_InnovacionS> _innovacionesS = [];
  List<_InnovacionT> _innovacionesT = [];
  List<_GradoF> _gradoF = [];
  List<_ImpactoF> _impactoF = [];
  List<_PrecisionF> _precisionF = [];
  List<_GradoM> _gradoM = [];
  List<_PrecisionM> _precisionM = [];
  List<_GradoS> _gradoS = [];
  List<_PrecisionS> _precisionS = [];
  List<_GradoT> _gradoT = [];
  List<_ImpactoT> _impactoT = [];
  List<_PrecisionT> _precisionT = [];
  List<_SyncT> _syncT = [];
  List<_FaltaItem> _faltasGenerales = [];
  List<_FaltaItem> _faltasEstiloFancy = [];
  List<_FaltaItem> _faltasEstiloMilitary = [];
  List<_FaltaItem> _faltasEstiloSilent = [];
  List<_FaltaItem> _faltasEstiloSoundtrack = [];
  bool _saving = false;
  bool _expandGeneral = true;
  bool _expandFS = false;
  bool _expandMS = false;
  bool _expandIno = false;
  bool _expandGD = false;
  bool _expandGDM = false;
  bool _expandGDT = false;
  bool _expandImpF = false;
  bool _expandImpT = false;
  bool _expandPrecF = false;
  bool _expandPrecM = false;
  bool _expandGDS = false;
  bool _expandPrecS = false;
  bool _expandPrecT = false;
  bool _expandSyncT = false;
  bool _expandFaltasG = false;
  bool _expandFaltasEst = false;

  @override
  void dispose() {
    for (final i in _items) {
      i.comment.dispose();
    }
    for (final e in _exhibicionesFS) {
      e.comment.dispose();
      e.commentPliegue.dispose();
      e.commentDeformaciones.dispose();
    }
    for (final e in _exhibicionesMS) {
      e.comment.dispose();
      e.commentPliegue.dispose();
      e.commentCreatividad.dispose();
    }
    for (final i in _innovacionesF) {
      i.comment.dispose();
      i.commentOriginalidad.dispose();
      i.commentEjecucion.dispose();
      i.commentComposicion.dispose();
    }
    for (final i in _innovacionesM) {
      i.comment.dispose();
      i.commentOriginalidad.dispose();
      i.commentPlenas.dispose();
      i.commentCadencias.dispose();
      i.commentIntervalos.dispose();
      i.commentContramarcha.dispose();
    }
    for (final i in _innovacionesS) {
      i.comment.dispose();
      i.commentOriginalidadBordon.dispose();
      i.commentIntervalos.dispose();
    }
    for (final i in _innovacionesT) {
      i.comment.dispose();
      i.commentOriginalidad.dispose();
      i.commentEjecucion.dispose();
    }
    for (final g in _gradoF) {
      g.comment.dispose();
      g.commentTiempos.dispose();
      g.commentDeformacion.dispose();
    }
    for (final im in _impactoF) {
      im.comment.dispose();
    }
    for (final pr in _precisionF) {
      pr.comment.dispose();
    }
    for (final gm in _gradoM) {
      gm.comment.dispose();
    }
    for (final pm in _precisionM) {
      pm.comment.dispose();
    }
    for (final gs in _gradoS) {
      gs.comment.dispose();
    }
    for (final ps in _precisionS) {
      ps.comment.dispose();
    }
    for (final gt in _gradoT) {
      gt.comment.dispose();
      gt.commentTiempos.dispose();
      gt.commentDeformacion.dispose();
    }
    for (final it in _impactoT) {
      it.comment.dispose();
    }
    for (final pt in _precisionT) {
      pt.comment.dispose();
    }
    for (final st in _syncT) {
      st.comment.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Peloton? p = Get.arguments is Peloton ? Get.arguments as Peloton : null;
    if (_peloton != p && p != null) {
      _peloton = p;
      _items = _buildItems(p.tipoMarcha);
      _exhibicionesFS = _buildExhibicionesFS(p.tipoMarcha);
      _exhibicionesMS = _buildExhibicionesMS(p.tipoMarcha);
      _innovacionesF = _buildInnovacionesF(p.tipoMarcha);
      _innovacionesM = _buildInnovacionesM(p.tipoMarcha);
      _innovacionesS = _buildInnovacionesS(p.tipoMarcha);
      _innovacionesT = _buildInnovacionesT(p.tipoMarcha);
      _gradoF = _buildGradoF(p.tipoMarcha);
      _impactoF = _buildImpactoF(p.tipoMarcha);
      _precisionF = _buildPrecisionF(p.tipoMarcha);
      _gradoM = _buildGradoM(p.tipoMarcha);
      _precisionM = _buildPrecisionM(p.tipoMarcha);
      _gradoS = _buildGradoS(p.tipoMarcha);
      _precisionS = _buildPrecisionS(p.tipoMarcha);
      _gradoT = _buildGradoT(p.tipoMarcha);
      _impactoT = _buildImpactoT(p.tipoMarcha);
      _precisionT = _buildPrecisionT(p.tipoMarcha);
      _syncT = _buildSyncT(p.tipoMarcha);
      _faltasGenerales = _buildFaltasGenerales();
      _faltasEstiloFancy = _buildFaltasEstiloFancy(p.tipoMarcha);
      _faltasEstiloMilitary = _buildFaltasEstiloMilitary(p.tipoMarcha);
      _faltasEstiloSilent = _buildFaltasEstiloSilent(p.tipoMarcha);
      _faltasEstiloSoundtrack = _buildFaltasEstiloSoundtrack(p.tipoMarcha);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Evaluación de Marcha', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offNamed(AppRoutes.MARCHA),
        ),
      ),
      body: _peloton == null
          ? const Center(child: Text('No se recibió pelotón'))
          : Column(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_peloton!.nombre, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text('Instructor: ${_peloton!.instructor}', style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 2),
                    Text('Estilo: ${_peloton!.tipoMarcha}', style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 2),
                    Text('Miembros: ${_peloton!.cantidadMiembros}', style: const TextStyle(color: Colors.black54)),
                  ]),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _accordion(
                      'Criterios generales',
                      _expandGeneral,
                      () {
                        setState(() {
                          _expandGeneral = !_expandGeneral;
                        });
                      },
                      _items.map((i) => _itemCard(i)).toList(),
                    ),
                    if (_exhibicionesFS.isNotEmpty)
                      _accordion(
                        'Exhibición (Fancy/Soundtrack) • 12 pts',
                        _expandFS,
                        () {
                          setState(() {
                            _expandFS = !_expandFS;
                          });
                        },
                        _exhibicionesFS.map((e) => _exhibicionCard(e)).toList(),
                      ),
                    if (_exhibicionesMS.isNotEmpty)
                      _accordion(
                        'Exhibición (Military/Silent) • 18 pts',
                        _expandMS,
                        () {
                          setState(() {
                            _expandMS = !_expandMS;
                          });
                        },
                        _exhibicionesMS.map((e) => _exhibicionMSCard(e)).toList(),
                      ),
                    if (_innovacionesF.isNotEmpty)
                      _accordion(
                        'Innovación (Fancy) • 18 pts',
                        _expandIno,
                        () {
                          setState(() {
                            _expandIno = !_expandIno;
                          });
                        },
                        _innovacionesF.map((e) => _innovacionCard(e)).toList(),
                      ),
                    if (_innovacionesM.isNotEmpty)
                      _accordion(
                        'Innovación (Military) • 30 pts',
                        _expandIno,
                        () {
                          setState(() {
                            _expandIno = !_expandIno;
                          });
                        },
                        _innovacionesM.map((e) => _innovacionMCard(e)).toList(),
                      ),
                    if (_innovacionesS.isNotEmpty)
                      _accordion(
                        'Innovación (Silent) • 12 pts',
                        _expandIno,
                        () {
                          setState(() {
                            _expandIno = !_expandIno;
                          });
                        },
                        _innovacionesS.map((e) => _innovacionSCard(e)).toList(),
                      ),
                    if (_innovacionesT.isNotEmpty)
                      _accordion(
                        'Innovación (Soundtrack) • 18 pts',
                        _expandIno,
                        () {
                          setState(() {
                            _expandIno = !_expandIno;
                          });
                        },
                        _innovacionesT.map((e) => _innovacionTCard(e)).toList(),
                      ),
                    if (_gradoT.isNotEmpty)
                      _accordion(
                        'Grado de dificultad (Soundtrack) • 12 pts',
                        _expandGDT,
                        () {
                          setState(() {
                            _expandGDT = !_expandGDT;
                          });
                        },
                        _gradoT.map((e) => _gradoTCard(e)).toList(),
                      ),
                    if (_impactoT.isNotEmpty)
                      _accordion(
                        'Impacto del juez (Soundtrack) • 6 pts',
                        _expandImpT,
                        () {
                          setState(() {
                            _expandImpT = !_expandImpT;
                          });
                        },
                        _impactoT.map((e) => _impactoTCard(e)).toList(),
                      ),
                    if (_precisionT.isNotEmpty)
                      _accordion(
                        'Precisión (Soundtrack) • 6 pts',
                        _expandPrecT,
                        () {
                          setState(() {
                            _expandPrecT = !_expandPrecT;
                          });
                        },
                        _precisionT.map((e) => _precisionTCard(e)).toList(),
                      ),
                    if (_syncT.isNotEmpty)
                      _accordion(
                        'Sincronización con la música (Soundtrack) • 12 pts',
                        _expandSyncT,
                        () {
                          setState(() {
                            _expandSyncT = !_expandSyncT;
                          });
                        },
                        _syncT.map((e) => _syncTCard(e)).toList(),
                      ),
                    if (_gradoF.isNotEmpty)
                      _accordion(
                        'Grado de dificultad (Fancy) • 18 pts',
                        _expandGD,
                        () {
                          setState(() {
                            _expandGD = !_expandGD;
                          });
                        },
                        _gradoF.map((e) => _gradoFCard(e)).toList(),
                      ),
                    if (_gradoM.isNotEmpty)
                      _accordion(
                        'Grado de dificultad (Military) • 3 pts',
                        _expandGDM,
                        () {
                          setState(() {
                            _expandGDM = !_expandGDM;
                          });
                        },
                        _gradoM.map((e) => _gradoMCard(e)).toList(),
                      ),
                    if (_gradoS.isNotEmpty)
                      _accordion(
                        'Grado de dificultad (Silent) • 15 pts',
                        _expandGDS,
                        () {
                          setState(() {
                            _expandGDS = !_expandGDS;
                          });
                        },
                        _gradoS.map((e) => _gradoSCard(e)).toList(),
                      ),
                    if (_impactoF.isNotEmpty)
                      _accordion(
                        'Impacto del juez (Fancy) • 6 pts',
                        _expandImpF,
                        () {
                          setState(() {
                            _expandImpF = !_expandImpF;
                          });
                        },
                        _impactoF.map((e) => _impactoFCard(e)).toList(),
                      ),
                    if (_precisionF.isNotEmpty)
                      _accordion(
                        'Precisión (Fancy) • 15 pts',
                        _expandPrecF,
                        () {
                          setState(() {
                            _expandPrecF = !_expandPrecF;
                          });
                        },
                        _precisionF.map((e) => _precisionFCard(e)).toList(),
                      ),
                    if (_precisionM.isNotEmpty)
                      _accordion(
                        'Precisión (Military) • 18 pts',
                        _expandPrecM,
                        () {
                          setState(() {
                            _expandPrecM = !_expandPrecM;
                          });
                        },
                        _precisionM.map((e) => _precisionMCard(e)).toList(),
                      ),
                    if (_precisionS.isNotEmpty)
                      _accordion(
                        'Precisión (Silent) • 24 pts',
                        _expandPrecS,
                        () {
                          setState(() {
                            _expandPrecS = !_expandPrecS;
                          });
                        },
                        _precisionS.map((e) => _precisionSCard(e)).toList(),
                      ),
                    if (_faltasGenerales.isNotEmpty)
                      _accordion(
                        'Tiempos / faltas generales (−5 por falta)',
                        _expandFaltasG,
                        () {
                          setState(() {
                            _expandFaltasG = !_expandFaltasG;
                          });
                        },
                        [_faltasList(_faltasGenerales, 5)],
                      ),
                    if (_faltasEstiloFancy.isNotEmpty)
                      _accordion(
                        'Faltas del estilo (Fancy) (−2 por falta)',
                        _expandFaltasEst,
                        () {
                          setState(() {
                            _expandFaltasEst = !_expandFaltasEst;
                          });
                        },
                        [_faltasList(_faltasEstiloFancy, 2)],
                      ),
                    if (_faltasEstiloMilitary.isNotEmpty)
                      _accordion(
                        'Faltas del estilo (Military) (−2 por falta)',
                        _expandFaltasEst,
                        () {
                          setState(() {
                            _expandFaltasEst = !_expandFaltasEst;
                          });
                        },
                        [_faltasList(_faltasEstiloMilitary, 2)],
                      ),
                    if (_faltasEstiloSilent.isNotEmpty)
                      _accordion(
                        'Faltas del estilo (Silent) (−2 por falta)',
                        _expandFaltasEst,
                        () {
                          setState(() {
                            _expandFaltasEst = !_expandFaltasEst;
                          });
                        },
                        [_faltasList(_faltasEstiloSilent, 2)],
                      ),
                    if (_faltasEstiloSoundtrack.isNotEmpty)
                      _accordion(
                        'Faltas del estilo (Soundtrack) (−2 por falta)',
                        _expandFaltasEst,
                        () {
                          setState(() {
                            _expandFaltasEst = !_expandFaltasEst;
                          });
                        },
                        [_faltasList(_faltasEstiloSoundtrack, 2)],
                      ),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('Total parcial', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      Text('${_items.fold<int>(0, (a, b) => a + b.value) + _exhibicionesFS.fold<int>(0, (a, b) => a + b.pliegue + b.deformaciones) + _exhibicionesMS.fold<int>(0, (a, b) => a + b.pliegue + b.creatividad) + _innovacionesF.fold<int>(0, (a, b) => a + b.originalidad + b.ejecucion + b.composicion) + _innovacionesM.fold<int>(0, (a, b) => a + b.originalidad + b.plenas + b.cadencias + b.intervalos + b.contramarcha) + _innovacionesS.fold<int>(0, (a, b) => a + b.originalidadBordon + b.intervalos) + _innovacionesT.fold<int>(0, (a, b) => a + b.originalidad + b.ejecucion) + _gradoF.fold<int>(0, (a, b) => a + b.tiempos + b.deformacion) + _gradoM.fold<int>(0, (a, b) => a + b.valor) + _gradoS.fold<int>(0, (a, b) => a + b.valor) + _gradoT.fold<int>(0, (a, b) => a + b.tiempos + b.deformacion) + _impactoF.fold<int>(0, (a, b) => a + b.valor) + _impactoT.fold<int>(0, (a, b) => a + b.valor) + _precisionF.fold<int>(0, (a, b) => a + b.valor) + _precisionM.fold<int>(0, (a, b) => a + b.valor) + _precisionS.fold<int>(0, (a, b) => a + b.valor) + _precisionT.fold<int>(0, (a, b) => a + b.valor) + _syncT.fold<int>(0, (a, b) => a + b.valor) - (_faltasGenerales.where((f) => f.selected).length * 5) - (_faltasEstiloFancy.where((f) => f.selected).length * 2) - (_faltasEstiloMilitary.where((f) => f.selected).length * 2) - (_faltasEstiloSilent.where((f) => f.selected).length * 2) - (_faltasEstiloSoundtrack.where((f) => f.selected).length * 2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: _saving
                        ? null
                        : () async {
                            await CoolAlert.show(
                              context: context,
                              type: CoolAlertType.confirm,
                              text: '¿Confirmas guardar la evaluación?',
                              confirmBtnText: 'Guardar',
                              cancelBtnText: 'Cancelar',
                              onConfirmBtnTap: () async {
                                Navigator.of(context).pop();
                                await _performSave();
                              },
                            );
                          },
                    child: _saving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Guardar evaluación', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ]),
    );
  }

  Future<void> _performSave() async {
    setState(() => _saving = true);
    String? _docId;
    DocumentReference<Map<String, dynamic>>? _ref;
    Map<String, dynamic>? _evalData;
    try {
      final box = GetStorage();
      final user = box.read('user');
      final evaluadorNombre = (user is Map && (user['nombre'] ?? '').toString().isNotEmpty) ? (user['nombre'] as String) : '';
      final evaluadorEmail = (user is Map && (user['email'] ?? '').toString().isNotEmpty) ? (user['email'] as String) : '';
      if (evaluadorNombre.isEmpty && evaluadorEmail.isEmpty) {
        await CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: 'Inicia sesión para guardar evaluaciones',
        );
        Get.offAllNamed(AppRoutes.MARCHA);
        setState(() => _saving = false);
        return;
      }
      _docId = '${_peloton!.id}_${evaluadorEmail.isNotEmpty ? evaluadorEmail : evaluadorNombre}';
      _ref = FirebaseFirestore.instance.collection('evaluaciones_marcha').doc(_docId);
      _evalData = {
        'pelotonId': _peloton!.id,
        'pelotonNombre': _peloton!.nombre,
        'instructor': _peloton!.instructor,
        'tipoMarcha': _peloton!.tipoMarcha,
        'cantidadMiembros': _peloton!.cantidadMiembros,
        'evaluadorNombre': evaluadorNombre,
        'evaluadorEmail': evaluadorEmail,
        'items': _items
            .map((e) => {
                  'name': e.name,
                  'value': e.value,
                  'max': e.max,
                  'comment': e.comment.text.trim(),
                })
            .toList(),
        'exhibiciones': [
          ..._exhibicionesFS.map((e) => {
                'type': 'FS',
                'index': e.index,
                'pliegueRepliegue': e.pliegue,
                'deformaciones': e.deformaciones,
                'maxPorExhibicion': 4,
                'comment': e.comment.text.trim(),
                'commentPliegueRepliegue': e.commentPliegue.text.trim(),
                'commentDeformaciones': e.commentDeformaciones.text.trim(),
              }),
          ..._exhibicionesMS.map((e) => {
                'type': 'MS',
                'index': e.index,
                'pliegueRepliegue': e.pliegue,
                'creatividad': e.creatividad,
                'maxPorExhibicion': 6,
                'comment': e.comment.text.trim(),
                'commentPliegueRepliegue': e.commentPliegue.text.trim(),
                'commentCreatividad': e.commentCreatividad.text.trim(),
              }),
          ..._innovacionesF.map((e) => {
                'type': 'FI',
                'index': e.index,
                'originalidad': e.originalidad,
                'ejecucion': e.ejecucion,
                'composicion': e.composicion,
                'maxPorExhibicion': 6,
                'comment': e.comment.text.trim(),
                'commentOriginalidad': e.commentOriginalidad.text.trim(),
                'commentEjecucion': e.commentEjecucion.text.trim(),
                'commentComposicion': e.commentComposicion.text.trim(),
              }),
          ..._innovacionesM.map((e) => {
                'type': 'MI',
                'index': e.index,
                'originalidad': e.originalidad,
                'plenas': e.plenas,
                'cadenciasNumericas': e.cadencias,
                'intervalos': e.intervalos,
                'contraMarcha': e.contramarcha,
                'maxPorExhibicion': 10,
                'comment': e.comment.text.trim(),
                'commentOriginalidad': e.commentOriginalidad.text.trim(),
                'commentPlenas': e.commentPlenas.text.trim(),
                'commentCadenciasNumericas': e.commentCadencias.text.trim(),
                'commentIntervalos': e.commentIntervalos.text.trim(),
                'commentContraMarcha': e.commentContramarcha.text.trim(),
              }),
          ..._innovacionesS.map((e) => {
                'type': 'SI',
                'index': e.index,
                'originalidadBordon': e.originalidadBordon,
                'intervalos': e.intervalos,
                'maxPorExhibicion': 4,
                'comment': e.comment.text.trim(),
                'commentOriginalidadBordon': e.commentOriginalidadBordon.text.trim(),
                'commentIntervalos': e.commentIntervalos.text.trim(),
              }),
          ..._innovacionesT.map((e) => {
                'type': 'SO',
                'index': e.index,
                'originalidad': e.originalidad,
                'ejecucionInnovadora': e.ejecucion,
                'maxPorExhibicion': 6,
                'comment': e.comment.text.trim(),
                'commentOriginalidad': e.commentOriginalidad.text.trim(),
                'commentEjecucionInnovadora': e.commentEjecucion.text.trim(),
              }),
          ..._gradoF.map((e) => {
                'type': 'FD',
                'index': e.index,
                'pasosDiferentesTiempos': e.tiempos,
                'gradoDificultadDeformacion': e.deformacion,
                'maxPorExhibicion': 6,
                'comment': e.comment.text.trim(),
                'commentPasosDiferentesTiempos': e.commentTiempos.text.trim(),
                'commentGradoDificultadDeformacion': e.commentDeformacion.text.trim(),
              }),
          ..._gradoM.map((e) => {
                'type': 'MD',
                'index': e.index,
                'gradoDificultad': e.valor,
                'maxPorExhibicion': 1,
                'comment': e.comment.text.trim(),
              }),
          ..._gradoS.map((e) => {
                'type': 'SD',
                'index': e.index,
                'gradoDificultad': e.valor,
                'maxPorExhibicion': 5,
                'comment': e.comment.text.trim(),
              }),
          ..._gradoT.map((e) => {
                'type': 'TD',
                'index': e.index,
                'pasosDiferentesTiempos': e.tiempos,
                'gradoDificultadDeformacion': e.deformacion,
                'maxPorExhibicion': 4,
                'comment': e.comment.text.trim(),
                'commentPasosDiferentesTiempos': e.commentTiempos.text.trim(),
                'commentGradoDificultadDeformacion': e.commentDeformacion.text.trim(),
              }),
          ..._impactoF.map((e) => {
                'type': 'FJ',
                'index': e.index,
                'impactoJuez': e.valor,
                'maxPorExhibicion': 2,
                'comment': e.comment.text.trim(),
              }),
          ..._precisionF.map((e) => {
                'type': 'FP',
                'index': e.index,
                'precision': e.valor,
                'maxPorExhibicion': 5,
                'comment': e.comment.text.trim(),
              }),
          ..._precisionM.map((e) => {
                'type': 'MP',
                'index': e.index,
                'precision': e.valor,
                'maxPorExhibicion': 6,
                'comment': e.comment.text.trim(),
              }),
          ..._precisionS.map((e) => {
                'type': 'SP',
                'index': e.index,
                'precision': e.valor,
                'maxPorExhibicion': 8,
                'comment': e.comment.text.trim(),
              }),
          ..._impactoT.map((e) => {
                'type': 'TJ',
                'index': e.index,
                'impactoJuez': e.valor,
                'maxPorExhibicion': 2,
                'comment': e.comment.text.trim(),
              }),
          ..._precisionT.map((e) => {
                'type': 'TP',
                'index': e.index,
                'precision': e.valor,
                'maxPorExhibicion': 2,
                'comment': e.comment.text.trim(),
              }),
          ..._syncT.map((e) => {
                'type': 'TS',
                'index': e.index,
                'sincronizacion': e.valor,
                'maxPorExhibicion': 4,
                'comment': e.comment.text.trim(),
              }),
        ],
        'totalParcial': _items.fold<int>(0, (a, b) => a + b.value) + _exhibicionesFS.fold<int>(0, (a, b) => a + b.pliegue + b.deformaciones) + _exhibicionesMS.fold<int>(0, (a, b) => a + b.pliegue + b.creatividad) + _innovacionesF.fold<int>(0, (a, b) => a + b.originalidad + b.ejecucion + b.composicion) + _innovacionesM.fold<int>(0, (a, b) => a + b.originalidad + b.plenas + b.cadencias + b.intervalos + b.contramarcha) + _innovacionesS.fold<int>(0, (a, b) => a + b.originalidadBordon + b.intervalos) + _innovacionesT.fold<int>(0, (a, b) => a + b.originalidad + b.ejecucion) + _gradoF.fold<int>(0, (a, b) => a + b.tiempos + b.deformacion) + _gradoM.fold<int>(0, (a, b) => a + b.valor) + _gradoS.fold<int>(0, (a, b) => a + b.valor) + _gradoT.fold<int>(0, (a, b) => a + b.tiempos + b.deformacion) + _impactoF.fold<int>(0, (a, b) => a + b.valor) + _impactoT.fold<int>(0, (a, b) => a + b.valor) + _precisionF.fold<int>(0, (a, b) => a + b.valor) + _precisionM.fold<int>(0, (a, b) => a + b.valor) + _precisionS.fold<int>(0, (a, b) => a + b.valor) + _precisionT.fold<int>(0, (a, b) => a + b.valor) + _syncT.fold<int>(0, (a, b) => a + b.valor) - (_faltasGenerales.where((f) => f.selected).length * 5) - (_faltasEstiloFancy.where((f) => f.selected).length * 2) - (_faltasEstiloMilitary.where((f) => f.selected).length * 2) - (_faltasEstiloSilent.where((f) => f.selected).length * 2) - (_faltasEstiloSoundtrack.where((f) => f.selected).length * 2),
        'faltasGenerales': _faltasGenerales.where((f) => f.selected).map((f) => f.name).toList(),
        'faltasEstiloFancy': _faltasEstiloFancy.where((f) => f.selected).map((f) => f.name).toList(),
        'faltasEstiloMilitary': _faltasEstiloMilitary.where((f) => f.selected).map((f) => f.name).toList(),
        'faltasEstiloSilent': _faltasEstiloSilent.where((f) => f.selected).map((f) => f.name).toList(),
        'faltasEstiloSoundtrack': _faltasEstiloSoundtrack.where((f) => f.selected).map((f) => f.name).toList(),
        'descalificadoPorFaltasGenerales': _faltasGenerales.any((f) => f.selected),
        'createdAt': FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance.runTransaction((t) async {
        final snap = await t.get(_ref!);
        if (snap.exists) {
          throw 'YA_EXISTE';
        }
        t.set(_ref!, _evalData!);
      });
      for (final i in _items) {
        i.value = 0;
        i.comment.clear();
      }
      for (final e in _exhibicionesFS) {
        e.pliegue = 0;
        e.deformaciones = 0;
        e.comment.clear();
        e.commentPliegue.clear();
        e.commentDeformaciones.clear();
      }
      for (final e in _exhibicionesMS) {
        e.pliegue = 0;
        e.creatividad = 0;
        e.comment.clear();
        e.commentPliegue.clear();
        e.commentCreatividad.clear();
      }
      for (final i in _innovacionesF) {
        i.originalidad = 0;
        i.ejecucion = 0;
        i.composicion = 0;
        i.comment.clear();
        i.commentOriginalidad.clear();
        i.commentEjecucion.clear();
        i.commentComposicion.clear();
      }
      for (final i in _innovacionesM) {
        i.originalidad = 0;
        i.plenas = 0;
        i.cadencias = 0;
        i.intervalos = 0;
        i.contramarcha = 0;
        i.comment.clear();
        i.commentOriginalidad.clear();
        i.commentPlenas.clear();
        i.commentCadencias.clear();
        i.commentIntervalos.clear();
        i.commentContramarcha.clear();
      }
      for (final i in _innovacionesS) {
        i.originalidadBordon = 0;
        i.intervalos = 0;
        i.comment.clear();
        i.commentOriginalidadBordon.clear();
        i.commentIntervalos.clear();
      }
      for (final i in _innovacionesT) {
        i.originalidad = 0;
        i.ejecucion = 0;
        i.comment.clear();
        i.commentOriginalidad.clear();
        i.commentEjecucion.clear();
      }
      for (final g in _gradoF) {
        g.tiempos = 0;
        g.deformacion = 0;
        g.comment.clear();
        g.commentTiempos.clear();
        g.commentDeformacion.clear();
      }
      for (final gm in _gradoM) {
        gm.valor = 0;
        gm.comment.clear();
      }
      for (final im in _impactoF) {
        im.valor = 0;
        im.comment.clear();
      }
      for (final pr in _precisionF) {
        pr.valor = 0;
        pr.comment.clear();
      }
      for (final pm in _precisionM) {
        pm.valor = 0;
        pm.comment.clear();
      }
      for (final gs in _gradoS) {
        gs.valor = 0;
        gs.comment.clear();
      }
      for (final ps in _precisionS) {
        ps.valor = 0;
        ps.comment.clear();
      }
      for (final gt in _gradoT) {
        gt.tiempos = 0;
        gt.deformacion = 0;
        gt.comment.clear();
        gt.commentTiempos.clear();
        gt.commentDeformacion.clear();
      }
      for (final it in _impactoT) {
        it.valor = 0;
        it.comment.clear();
      }
      for (final pt in _precisionT) {
        pt.valor = 0;
        pt.comment.clear();
      }
      for (final st in _syncT) {
        st.valor = 0;
        st.comment.clear();
      }
      for (final f in _faltasGenerales) {
        f.selected = false;
      }
      for (final f in _faltasEstiloFancy) {
        f.selected = false;
      }
      for (final f in _faltasEstiloMilitary) {
        f.selected = false;
      }
      for (final f in _faltasEstiloSilent) {
        f.selected = false;
      }
      for (final f in _faltasEstiloSoundtrack) {
        f.selected = false;
      }
      setState(() {});
      if (!mounted) return;
      await CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'Se guardó la evaluación',
      );
      Get.offAllNamed(AppRoutes.MARCHA);
    } catch (e) {
      if (e == 'YA_EXISTE') {
        if (!mounted) return;
        await CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          text: 'Ya existe una evaluación para este pelotón hecha por ti',
        );
        Get.offAllNamed(AppRoutes.MARCHA);
      } else if (e is FirebaseException && (e.code == 'unavailable' || e.code == 'network-request-failed')) {
        final box = GetStorage();
        final list = box.read('pending_sync_evaluaciones');
        final pending = (list is List) ? List<Map<String, dynamic>>.from(list.whereType<Map>().map((m) => m.map((k, v) => MapEntry('$k', v)))) : <Map<String, dynamic>>[];
        if (_docId != null && _evalData != null) {
          pending.add({'docId': _docId, 'data': _evalData});
        }
        box.write('pending_sync_evaluaciones', pending);
        if (!mounted) return;
        await CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          text: 'Sin conexión. Se guardó localmente y se sincronizará luego.',
        );
        Get.offAllNamed(AppRoutes.MARCHA);
      } else {
        if (!mounted) return;
        await CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: '$e',
        );
        Get.offAllNamed(AppRoutes.MARCHA);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  List<_Item> _buildItems(String rawStyle) {
    final s = _styleKey(rawStyle);
    switch (s) {
      case 'SOUNDTRACK':
        return [
          _Item('Instructor', 12),
          _Item('Reglamentaria', 10),
          _Item('Precisión de reglamentaria', 10),
        ];
      case 'FANCY DRILL':
      case 'MILITARY DRILL':
      case 'SILENT DRILL':
        return [
          _Item('Instructor', 11),
          _Item('Reglamentaria', 10),
          _Item('Precisión de reglamentaria', 10),
        ];
      default:
        return [
          _Item('Instructor', 11),
          _Item('Reglamentaria', 10),
          _Item('Precisión de reglamentaria', 10),
        ];
    }
  }

  List<_Exhibicion> _buildExhibicionesFS(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'FANCY DRILL' || s == 'SOUNDTRACK') {
      return [
        _Exhibicion(1),
        _Exhibicion(2),
        _Exhibicion(3),
      ];
    }
    return [];
  }

  List<_ExhibicionMS> _buildExhibicionesMS(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'MILITARY DRILL' || s == 'SILENT DRILL') {
      return [
        _ExhibicionMS(1),
        _ExhibicionMS(2),
        _ExhibicionMS(3),
      ];
    }
    return [];
  }

  List<_InnovacionF> _buildInnovacionesF(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'FANCY DRILL') {
      return [
        _InnovacionF(1),
        _InnovacionF(2),
        _InnovacionF(3),
      ];
    }
    return [];
  }

  List<_InnovacionM> _buildInnovacionesM(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'MILITARY DRILL') {
      return [
        _InnovacionM(1),
        _InnovacionM(2),
        _InnovacionM(3),
      ];
    }
    return [];
  }

  List<_InnovacionS> _buildInnovacionesS(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'SILENT DRILL') {
      return [
        _InnovacionS(1),
        _InnovacionS(2),
        _InnovacionS(3),
      ];
    }
    return [];
  }

  List<_InnovacionT> _buildInnovacionesT(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'SOUNDTRACK') {
      return [
        _InnovacionT(1),
        _InnovacionT(2),
        _InnovacionT(3),
      ];
    }
    return [];
  }

  List<_GradoF> _buildGradoF(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'FANCY DRILL') {
      return [_GradoF(1), _GradoF(2), _GradoF(3)];
    }
    return [];
  }

  List<_ImpactoF> _buildImpactoF(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'FANCY DRILL') {
      return [_ImpactoF(1), _ImpactoF(2), _ImpactoF(3)];
    }
    return [];
  }

  List<_PrecisionF> _buildPrecisionF(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'FANCY DRILL') {
      return [_PrecisionF(1), _PrecisionF(2), _PrecisionF(3)];
    }
    return [];
  }

  List<_GradoM> _buildGradoM(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'MILITARY DRILL') {
      return [_GradoM(1), _GradoM(2), _GradoM(3)];
    }
    return [];
  }

  List<_PrecisionM> _buildPrecisionM(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'MILITARY DRILL') {
      return [_PrecisionM(1), _PrecisionM(2), _PrecisionM(3)];
    }
    return [];
  }

  List<_GradoS> _buildGradoS(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'SILENT DRILL') {
      return [_GradoS(1), _GradoS(2), _GradoS(3)];
    }
    return [];
  }

  List<_PrecisionS> _buildPrecisionS(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'SILENT DRILL') {
      return [_PrecisionS(1), _PrecisionS(2), _PrecisionS(3)];
    }
    return [];
  }

  List<_GradoT> _buildGradoT(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'SOUNDTRACK') {
      return [_GradoT(1), _GradoT(2), _GradoT(3)];
    }
    return [];
  }

  List<_ImpactoT> _buildImpactoT(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'SOUNDTRACK') {
      return [_ImpactoT(1), _ImpactoT(2), _ImpactoT(3)];
    }
    return [];
  }

  List<_PrecisionT> _buildPrecisionT(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'SOUNDTRACK') {
      return [_PrecisionT(1), _PrecisionT(2), _PrecisionT(3)];
    }
    return [];
  }

  List<_SyncT> _buildSyncT(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'SOUNDTRACK') {
      return [_SyncT(1), _SyncT(2), _SyncT(3)];
    }
    return [];
  }

  List<_FaltaItem> _buildFaltasGenerales() {
    return [
      _FaltaItem('Agacharse'),
      _FaltaItem('Brincar'),
      _FaltaItem('Manotear'),
      _FaltaItem('Zapatear'),
      _FaltaItem('Hablar en formación'),
      _FaltaItem('Bailar'),
      _FaltaItem('Exceder tiempo general'),
      _FaltaItem('Aplaudir'),
      _FaltaItem('Eslogan denigrante'),
      _FaltaItem('Relajar con el saludo'),
      _FaltaItem('Movimientos fuera del contexto militar'),
    ];
  }

  List<_FaltaItem> _buildFaltasEstiloFancy(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'FANCY DRILL') {
      return [
        _FaltaItem('Utilizar una plena'),
        _FaltaItem('Utilizar el bordón del estilo silent drill'),
      ];
    }
    return [];
  }

  List<_FaltaItem> _buildFaltasEstiloMilitary(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'MILITARY DRILL') {
      return [
        _FaltaItem('Uso de cadencias no numéricas'),
        _FaltaItem('Frases fuera de: club/zona/pelotón'),
        _FaltaItem('Pasos fuera del contexto militar'),
      ];
    }
    return [];
  }

  List<_FaltaItem> _buildFaltasEstiloSilent(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'SILENT DRILL') {
      return [
        _FaltaItem('Hablar'),
      ];
    }
    return [];
  }

  List<_FaltaItem> _buildFaltasEstiloSoundtrack(String rawStyle) {
    final s = _styleKey(rawStyle);
    if (s == 'SOUNDTRACK') {
      return [
        _FaltaItem('Plena'),
        _FaltaItem('Cadencias largas'),
      ];
    }
    return [];
  }

  String _styleKey(String raw) {
    final r = raw.trim().toUpperCase();
    if (r.contains('FANCY')) return 'FANCY DRILL';
    if (r.contains('MILITARY')) return 'MILITARY DRILL';
    if (r.contains('SILENT')) return 'SILENT DRILL';
    if (r.contains('SOUND')) return 'SOUNDTRACK';
    return r;
  }

  Widget _itemCard(_Item i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(i.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${i.value} / ${i.max}', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          GestureDetector(
            onTap: i.value > 0
                ? () {
                    setState(() {
                      i.value = (i.value - 1).clamp(0, i.max);
                    });
                  }
                : null,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: (i.value > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(21),
              ),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: i.value < i.max
                ? () {
                    setState(() {
                      i.value = (i.value + 1).clamp(0, i.max);
                    });
                  }
                : null,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: (i.value < i.max ? Colors.green : Colors.green.withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(21),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        TextField(
          controller: i.comment,
          decoration: InputDecoration(
            labelText: 'Comentario',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ]),
    );
  }

  Widget _exhibicionCard(_Exhibicion e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.pliegue + e.deformaciones} / 4', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text('Pliegue o Repliegue', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.pliegue} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.pliegue > 0
                ? () {
                    setState(() {
                      e.pliegue = (e.pliegue - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.pliegue > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.pliegue < 2
                ? () {
                    setState(() {
                      e.pliegue = (e.pliegue + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.pliegue < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentPliegue,
          decoration: InputDecoration(
            labelText: 'Comentario (pliegue/repliegue)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Deformaciones', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.deformaciones} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.deformaciones > 0
                ? () {
                    setState(() {
                      e.deformaciones = (e.deformaciones - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.deformaciones > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.deformaciones < 2
                ? () {
                    setState(() {
                      e.deformaciones = (e.deformaciones + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.deformaciones < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentDeformaciones,
          decoration: InputDecoration(
            labelText: 'Comentario (deformaciones)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ]),
    );
  }

  Widget _exhibicionMSCard(_ExhibicionMS e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.pliegue + e.creatividad} / 6', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text('Pliegue o Repliegue', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.pliegue} / 4'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.pliegue > 0
                ? () {
                    setState(() {
                      e.pliegue = (e.pliegue - 1).clamp(0, 4);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.pliegue > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.pliegue < 4
                ? () {
                    setState(() {
                      e.pliegue = (e.pliegue + 1).clamp(0, 4);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.pliegue < 4 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentPliegue,
          decoration: InputDecoration(
            labelText: 'Comentario (pliegue/repliegue)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Creatividad al ejecutar el pliegue o repliegue', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.creatividad} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.creatividad > 0
                ? () {
                    setState(() {
                      e.creatividad = (e.creatividad - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.creatividad > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.creatividad < 2
                ? () {
                    setState(() {
                      e.creatividad = (e.creatividad + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.creatividad < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentCreatividad,
          decoration: InputDecoration(
            labelText: 'Comentario (creatividad)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ]),
    );
  }

  Widget _innovacionCard(_InnovacionF e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Innovación', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.originalidad + e.ejecucion + e.composicion} / 6', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text('Originalidad en las combinaciones', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.originalidad} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.originalidad > 0
                ? () {
                    setState(() {
                      e.originalidad = (e.originalidad - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.originalidad > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.originalidad < 2
                ? () {
                    setState(() {
                      e.originalidad = (e.originalidad + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.originalidad < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentOriginalidad,
          decoration: InputDecoration(
            labelText: 'Comentario (originalidad)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Ejecución novedosa / Creatividad', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.ejecucion} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.ejecucion > 0
                ? () {
                    setState(() {
                      e.ejecucion = (e.ejecucion - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.ejecucion > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.ejecucion < 2
                ? () {
                    setState(() {
                      e.ejecucion = (e.ejecucion + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.ejecucion < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentEjecucion,
          decoration: InputDecoration(
            labelText: 'Comentario (ejecución)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Composición de eslogan o cadencias numéricas', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.composicion} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.composicion > 0
                ? () {
                    setState(() {
                      e.composicion = (e.composicion - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.composicion > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.composicion < 2
                ? () {
                    setState(() {
                      e.composicion = (e.composicion + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.composicion < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentComposicion,
          decoration: InputDecoration(
            labelText: 'Comentario (composición)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ]),
    );
  }

  Widget _innovacionMCard(_InnovacionM e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Innovación', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.originalidad + e.plenas + e.cadencias + e.intervalos + e.contramarcha} / 10', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text('Originalidad en las combinaciones', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.originalidad} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.originalidad > 0
                ? () {
                    setState(() {
                      e.originalidad = (e.originalidad - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.originalidad > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.originalidad < 2
                ? () {
                    setState(() {
                      e.originalidad = (e.originalidad + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.originalidad < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentOriginalidad,
          decoration: InputDecoration(
            labelText: 'Comentario (originalidad)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Uso de plenas', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.plenas} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.plenas > 0
                ? () {
                    setState(() {
                      e.plenas = (e.plenas - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.plenas > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.plenas < 2
                ? () {
                    setState(() {
                      e.plenas = (e.plenas + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.plenas < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentPlenas,
          decoration: InputDecoration(
            labelText: 'Comentario (plenas)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Uso de cadencias numéricas', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.cadencias} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.cadencias > 0
                ? () {
                    setState(() {
                      e.cadencias = (e.cadencias - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.cadencias > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.cadencias < 2
                ? () {
                    setState(() {
                      e.cadencias = (e.cadencias + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.cadencias < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentCadencias,
          decoration: InputDecoration(
            labelText: 'Comentario (cadencias numéricas)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Ejecuciones con intervalos (cerrado o medio)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.intervalos} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.intervalos > 0
                ? () {
                    setState(() {
                      e.intervalos = (e.intervalos - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.intervalos > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.intervalos < 2
                ? () {
                    setState(() {
                      e.intervalos = (e.intervalos + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.intervalos < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentIntervalos,
          decoration: InputDecoration(
            labelText: 'Comentario (intervalos)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Uso de contra la marcha en ejecuciones', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.contramarcha} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.contramarcha > 0
                ? () {
                    setState(() {
                      e.contramarcha = (e.contramarcha - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.contramarcha > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.contramarcha < 2
                ? () {
                    setState(() {
                      e.contramarcha = (e.contramarcha + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.contramarcha < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentContramarcha,
          decoration: InputDecoration(
            labelText: 'Comentario (contra marcha)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ]),
    );
  }

  Widget _innovacionSCard(_InnovacionS e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Innovación', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.originalidadBordon + e.intervalos} / 4', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text('Originalidad en las combinaciones con el bordón', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.originalidadBordon} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.originalidadBordon > 0
                ? () {
                    setState(() {
                      e.originalidadBordon = (e.originalidadBordon - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.originalidadBordon > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.originalidadBordon < 2
                ? () {
                    setState(() {
                      e.originalidadBordon = (e.originalidadBordon + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.originalidadBordon < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentOriginalidadBordon,
          decoration: InputDecoration(
            labelText: 'Comentario (originalidad con bordón)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Ejecuciones con intervalos (cerrado o medio)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.intervalos} / 2'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.intervalos > 0
                ? () {
                    setState(() {
                      e.intervalos = (e.intervalos - 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.intervalos > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.intervalos < 2
                ? () {
                    setState(() {
                      e.intervalos = (e.intervalos + 1).clamp(0, 2);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.intervalos < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentIntervalos,
          decoration: InputDecoration(
            labelText: 'Comentario (intervalos)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ]),
    );
  }

  Widget _innovacionTCard(_InnovacionT e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Innovación', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.originalidad + e.ejecucion} / 6', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text('Originalidad en las combinaciones', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.originalidad} / 3'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.originalidad > 0
                ? () {
                    setState(() {
                      e.originalidad = (e.originalidad - 1).clamp(0, 3);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.originalidad > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.originalidad < 3
                ? () {
                    setState(() {
                      e.originalidad = (e.originalidad + 1).clamp(0, 3);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.originalidad < 3 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentOriginalidad,
          decoration: InputDecoration(
            labelText: 'Comentario (originalidad)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Ejecución novedosa / innovadora', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)),
            child: Text('${e.ejecucion} / 3'),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.ejecucion > 0
                ? () {
                    setState(() {
                      e.ejecucion = (e.ejecucion - 1).clamp(0, 3);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.ejecucion > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: e.ejecucion < 3
                ? () {
                    setState(() {
                      e.ejecucion = (e.ejecucion + 1).clamp(0, 3);
                    });
                  }
                : null,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: (e.ejecucion < 3 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: e.commentEjecucion,
          decoration: InputDecoration(
            labelText: 'Comentario (ejecución)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ]),
    );
  }

  Widget _gradoFCard(_GradoF e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Grado de dificultad', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.tiempos + e.deformacion} / 6', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text('Implementación de pasos en diferentes tiempos', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.tiempos} / 3')),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.tiempos > 0 ? () { setState(() { e.tiempos = (e.tiempos - 1).clamp(0, 3); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.tiempos > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.tiempos < 3 ? () { setState(() { e.tiempos = (e.tiempos + 1).clamp(0, 3); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.tiempos < 3 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 8),
        TextField(controller: e.commentTiempos, decoration: InputDecoration(labelText: 'Comentario (tiempos)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Grado de dificultad en la deformación', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.deformacion} / 3')),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.deformacion > 0 ? () { setState(() { e.deformacion = (e.deformacion - 1).clamp(0, 3); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.deformacion > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.deformacion < 3 ? () { setState(() { e.deformacion = (e.deformacion + 1).clamp(0, 3); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.deformacion < 3 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 8),
        TextField(controller: e.commentDeformacion, decoration: InputDecoration(labelText: 'Comentario (deformación)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),),
      ]),
    );
  }

  Widget _impactoFCard(_ImpactoF e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Impacto del juez', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.valor} / 2', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: const SizedBox()),
          GestureDetector(onTap: e.valor > 0 ? () { setState(() { e.valor = (e.valor - 1).clamp(0, 2); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.valor < 2 ? () { setState(() { e.valor = (e.valor + 1).clamp(0, 2); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 12),
        TextField(controller: e.comment, decoration: InputDecoration(labelText: 'Comentario', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),),
      ]),
    );
  }

  Widget _precisionFCard(_PrecisionF e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Precisión', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.valor} / 5', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: const SizedBox()),
          GestureDetector(onTap: e.valor > 0 ? () { setState(() { e.valor = (e.valor - 1).clamp(0, 5); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.valor < 5 ? () { setState(() { e.valor = (e.valor + 1).clamp(0, 5); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor < 5 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 12),
        TextField(controller: e.comment, decoration: InputDecoration(labelText: 'Comentario', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),),
      ]),
    );
  }

  Widget _gradoMCard(_GradoM e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Grado de dificultad', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.valor} / 1', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: const SizedBox()),
          GestureDetector(onTap: e.valor > 0 ? () { setState(() { e.valor = (e.valor - 1).clamp(0, 1); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.valor < 1 ? () { setState(() { e.valor = (e.valor + 1).clamp(0, 1); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor < 1 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 12),
        TextField(controller: e.comment, decoration: InputDecoration(labelText: 'Comentario', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),),
      ]),
    );
  }

  Widget _precisionMCard(_PrecisionM e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Precisión', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.valor} / 6', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: const SizedBox()),
          GestureDetector(onTap: e.valor > 0 ? () { setState(() { e.valor = (e.valor - 1).clamp(0, 6); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.valor < 6 ? () { setState(() { e.valor = (e.valor + 1).clamp(0, 6); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor < 6 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 12),
        TextField(controller: e.comment, decoration: InputDecoration(labelText: 'Comentario', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),),
      ]),
    );
  }

  Widget _gradoTCard(_GradoT e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Grado de dificultad', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.tiempos + e.deformacion} / 4', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text('Implementación de pasos en diferentes tiempos', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.tiempos} / 2')),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.tiempos > 0 ? () { setState(() { e.tiempos = (e.tiempos - 1).clamp(0, 2); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.tiempos > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.tiempos < 2 ? () { setState(() { e.tiempos = (e.tiempos + 1).clamp(0, 2); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.tiempos < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 8),
        TextField(controller: e.commentTiempos, decoration: InputDecoration(labelText: 'Comentario (tiempos)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('Grado de dificultad en la deformación', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.deformacion} / 2')),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.deformacion > 0 ? () { setState(() { e.deformacion = (e.deformacion - 1).clamp(0, 2); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.deformacion > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.deformacion < 2 ? () { setState(() { e.deformacion = (e.deformacion + 1).clamp(0, 2); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.deformacion < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 8),
        TextField(controller: e.commentDeformacion, decoration: InputDecoration(labelText: 'Comentario (deformación)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      ]),
    );
  }

  Widget _impactoTCard(_ImpactoT e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Impacto del juez', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.valor} / 2', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: const SizedBox()),
          GestureDetector(onTap: e.valor > 0 ? () { setState(() { e.valor = (e.valor - 1).clamp(0, 2); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.valor < 2 ? () { setState(() { e.valor = (e.valor + 1).clamp(0, 2); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 12),
        TextField(controller: e.comment, decoration: InputDecoration(labelText: 'Comentario', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),),
      ]),
    );
  }

  Widget _precisionTCard(_PrecisionT e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Precisión', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.valor} / 2', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: const SizedBox()),
          GestureDetector(onTap: e.valor > 0 ? () { setState(() { e.valor = (e.valor - 1).clamp(0, 2); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.valor < 2 ? () { setState(() { e.valor = (e.valor + 1).clamp(0, 2); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor < 2 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 12),
        TextField(controller: e.comment, decoration: InputDecoration(labelText: 'Comentario', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),),
      ]),
    );
  }

  Widget _syncTCard(_SyncT e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Sincronización con la música', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.valor} / 4', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: const SizedBox()),
          GestureDetector(onTap: e.valor > 0 ? () { setState(() { e.valor = (e.valor - 1).clamp(0, 4); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.valor < 4 ? () { setState(() { e.valor = (e.valor + 1).clamp(0, 4); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor < 4 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 12),
        TextField(controller: e.comment, decoration: InputDecoration(labelText: 'Comentario', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),),
      ]),
    );
  }

  Widget _gradoSCard(_GradoS e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Grado de dificultad', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.valor} / 5', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: const SizedBox()),
          GestureDetector(onTap: e.valor > 0 ? () { setState(() { e.valor = (e.valor - 1).clamp(0, 5); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.valor < 5 ? () { setState(() { e.valor = (e.valor + 1).clamp(0, 5); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor < 5 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 12),
        TextField(controller: e.comment, decoration: InputDecoration(labelText: 'Comentario', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),),
      ]),
    );
  }

  Widget _precisionSCard(_PrecisionS e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('Exhibición ${e.index} — Precisión', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.deepPurple.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('${e.valor} / 8', style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: const SizedBox()),
          GestureDetector(onTap: e.valor > 0 ? () { setState(() { e.valor = (e.valor - 1).clamp(0, 8); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor > 0 ? Colors.red : Colors.red.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.remove, color: Colors.white))),
          const SizedBox(width: 8),
          GestureDetector(onTap: e.valor < 8 ? () { setState(() { e.valor = (e.valor + 1).clamp(0, 8); }); } : null, child: Container(width: 36, height: 36, decoration: BoxDecoration(color: (e.valor < 8 ? Colors.green : Colors.green.withValues(alpha: 0.4)), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.add, color: Colors.white))),
        ]),
        const SizedBox(height: 12),
        TextField(controller: e.comment, decoration: InputDecoration(labelText: 'Comentario', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),),
      ]),
    );
  }

  Widget _faltasList(List<_FaltaItem> items, int restaPorFalta) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final f in items)
          GestureDetector(
            onTap: () {
              setState(() {
                f.selected = !f.selected;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: (f.selected ? Colors.red.withValues(alpha: 0.06) : Colors.white),
                border: Border.all(color: f.selected ? Colors.red.withValues(alpha: 0.6) : Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Expanded(child: Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(8)), child: Text('-$restaPorFalta')),
              ]),
            ),
          ),
      ]),
    );
  }

  Widget _accordion(String title, bool expanded, VoidCallback onToggle, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              AnimatedRotation(
                turns: expanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.chevron_right, color: Colors.deepPurple),
              ),
            ]),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: expanded
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(children: children),
                )
              : const SizedBox.shrink(),
        ),
      ]),
    );
  }
}