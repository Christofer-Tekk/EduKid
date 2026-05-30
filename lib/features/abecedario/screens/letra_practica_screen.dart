// lib/features/abecedario/screens/letra_practica_screen.dart

import 'package:flutter/material.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../core/widgets/boton_accion.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/practice_success_dialog.dart';
import '../../../core/widgets/home_button.dart';
import '../../../core/constants/colores_app.dart';
import '../../../data/local/datos_abecedario.dart';
import '../../../data/models/letra_model.dart';
import '../../../data/services/progreso_service.dart';

class LetraPracticaScreen extends StatefulWidget {
  const LetraPracticaScreen({super.key});

  @override
  State<LetraPracticaScreen> createState() => _LetraPracticaScreenState();
}

class _LetraPracticaScreenState extends State<LetraPracticaScreen> {
  final GlobalKey<_PizarraGuidadaState> _pizarraKey = GlobalKey<_PizarraGuidadaState>();
  late LetraModel letra;
  bool _inicializado = false;
  bool _enMinuscula = false;
  bool _mayusculaCompletada = false;
  bool _minusculaCompletada = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inicializado) {
      letra = ModalRoute.of(context)?.settings.arguments as LetraModel;
      _inicializado = true;
    }
  }

  String get _letraActual => _enMinuscula ? letra.letraMinuscula : letra.letraMayuscula;
  bool get _faseActualCompletada => _enMinuscula ? _minusculaCompletada : _mayusculaCompletada;

  void _onLimpiar() {
    _pizarraKey.currentState?.limpiar();
  }

  Future<void> _onVerificar() async {
    // Ahora la validación es mucho más inteligente
    final cobertura = _pizarraKey.currentState?.calcularCobertura() ?? 0;

    // Ajustado: 0.15 de cobertura real sobre la letra es suficiente para un niño
    if (cobertura >= 0.15) {
      setState(() {
        if (_enMinuscula) {
          _minusculaCompletada = true;
        } else {
          _mayusculaCompletada = true;
        }
      });

      if (_mayusculaCompletada && _minusculaCompletada) {
        await ProgresoService.completarLetra(letra.letraMayuscula);
        _mostrarDialogoExito();
      } else if (!_enMinuscula) {
        _mostrarDialogoPasarMinuscula();
      }
    } else {
      _mostrarDialogoIntentarDeNuevo();
    }
  }

  LetraModel? _obtenerSiguienteLetra() {
    final letras = DatosAbecedario.obtenerLetras();
    final index = letras.indexWhere(
      (item) => item.letraMayuscula == letra.letraMayuscula,
    );

    if (index == -1 || index >= letras.length - 1) {
      return null;
    }

    return letras[index + 1];
  }

  void _reiniciarPracticaActual() {
    setState(() {
      _enMinuscula = false;
      _mayusculaCompletada = false;
      _minusculaCompletada = false;
    });
    _pizarraKey.currentState?.limpiar();
  }

  void _irAlSiguienteOMenu() {
    final siguiente = _obtenerSiguienteLetra();

    if (siguiente == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/letra_practica',
      arguments: siguiente,
    );
  }

  // --- DIÁLOGOS (Sin cambios en UI) ---
  void _mostrarDialogoPasarMinuscula() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¡Muy bien! 🎉', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        content: const Text('Ahora practica la letra minúscula',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _enMinuscula = true;
                _pizarraKey.currentState?.limpiar();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF339AF0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Continuar →', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoExito() {
    final siguiente = _obtenerSiguienteLetra();

    PracticeSuccessDialog.show(
      context: context,
      message:
          '¡Muy bien! Completaste la letra ${letra.letraMayuscula}.',
      primaryText: 'Practicar otra vez',
      secondaryText: siguiente == null ? 'Volver al menú' : 'Siguiente letra',
      onPrimary: _reiniciarPracticaActual,
      onSecondary: _irAlSiguienteOMenu,
    );
  }

  void _mostrarDialogoIntentarDeNuevo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¡Inténtalo de nuevo! 💪', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: const Text('Asegúrate de trazar justo encima de la letra gris',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _onLimpiar();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Intentar otra vez', style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      assetPath: 'assets/images/fondo/fondo_abecedario.png',
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _TextoPracticaCard.titulo('Practica'),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HomeButton.iconOnly(),
                      const SizedBox(width: 8),
                      BotonAccion(
                        texto: 'VOLVER',
                        icono: Icons.arrow_back,
                        colorPrincipal: Colors.blue,
                        colorSombra: const Color(0xFF1971C2),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FaseIndicador(letra: letra.letraMayuscula, activo: !_enMinuscula, completado: _mayusculaCompletada),
                  const SizedBox(width: 20),
                  _FaseIndicador(letra: letra.letraMinuscula, activo: _enMinuscula, completado: _minusculaCompletada),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _TextoPracticaCard.subtitulo('Traza la letra  $_letraActual'),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: _PizarraGuiada(key: _pizarraKey, letra: _letraActual, completada: _faseActualCompletada),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(child: _BotonAccionPizarra(texto: '🔄  LIMPIAR', color: Colors.orange, sombra: const Color(0xFFE67700), onTap: _faseActualCompletada ? null : _onLimpiar)),
                  const SizedBox(width: 12),
                  Expanded(child: _BotonAccionPizarra(texto: '✅  VERIFICAR', color: const Color(0xFF51CF66), sombra: const Color(0xFF2F9E44), onTap: _faseActualCompletada ? null : _onVerificar)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


class _TextoPracticaCard extends StatelessWidget {
  final String texto;
  final bool esTitulo;

  const _TextoPracticaCard.titulo(this.texto) : esTitulo = true;
  const _TextoPracticaCard.subtitulo(this.texto) : esTitulo = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: esTitulo ? Alignment.centerLeft : Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: esTitulo ? 18 : 16,
          vertical: esTitulo ? 7 : 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.86),
          borderRadius: BorderRadius.circular(esTitulo ? 20 : 18),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: esTitulo
            ? AppTexto.titulo(
                texto,
                color: const Color(0xFFD90429),
                shadows: SombrasApp.blanca,
              )
            : AppTexto.subtitulo(
                texto,
                textAlign: TextAlign.center,
                color: const Color(0xFF0D3B66),
                shadows: SombrasApp.blanca,
              ),
      ),
    );
  }
}

// --- INDICADOR DE FASE (Sin cambios) ---
class _FaseIndicador extends StatelessWidget {
  final String letra;
  final bool activo;
  final bool completado;
  const _FaseIndicador({required this.letra, required this.activo, required this.completado});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60, height: 60,
      decoration: BoxDecoration(
        color: completado ? const Color(0xFF51CF66) : activo ? const Color(0xFFFFD166) : Colors.white24,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Center(
        child: completado ? const Icon(Icons.star, color: Colors.white, size: 30) : Text(letra, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: activo ? Colors.black87 : Colors.white60)),
      ),
    );
  }
}

// --- PIZARRA GUIADA (MEJORADA) ---
class _PizarraGuiada extends StatefulWidget {
  final String letra;
  final bool completada;
  const _PizarraGuiada({Key? key, required this.letra, required this.completada}) : super(key: key);
  @override
  State<_PizarraGuiada> createState() => _PizarraGuidadaState();
}

class _PizarraGuidadaState extends State<_PizarraGuiada> {
  final List<List<Offset>> _trazos = [];
  List<Offset> _trazoActual = [];

  void limpiar() {
    setState(() {
      _trazos.clear();
      _trazoActual = [];
    });
  }

  // MEJORA: Validación precisa del área de la letra
  double calcularCobertura() {
    if (_trazos.isEmpty && _trazoActual.isEmpty) return 0;

    const double pizarraSize = 290.0;
    
    // 1. Obtenemos el tamaño real de la letra
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.letra,
        style: const TextStyle(fontSize: 210, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: pizarraSize);

    final double offsetX = (pizarraSize - textPainter.width) / 2;
    final double offsetY = (pizarraSize - textPainter.height) / 2;
    final Rect letraRect = Rect.fromLTWH(offsetX, offsetY, textPainter.width, textPainter.height);

    // 2. Definimos 5 Zonas dentro de la letra (las esquinas y el centro)
    final List<Rect> zonas = [
      Rect.fromLTWH(letraRect.left, letraRect.top, letraRect.width/2, letraRect.height/2), // Arriba-Izq
      Rect.fromLTWH(letraRect.left + letraRect.width/2, letraRect.top, letraRect.width/2, letraRect.height/2), // Arriba-Der
      Rect.fromLTWH(letraRect.left, letraRect.top + letraRect.height/2, letraRect.width/2, letraRect.height/2), // Abajo-Izq
      Rect.fromLTWH(letraRect.left + letraRect.width/2, letraRect.top + letraRect.height/2, letraRect.width/2, letraRect.height/2), // Abajo-Der
      letraRect.deflate(letraRect.width/4), // Centro
    ];

    // 3. Verificamos cuántas zonas fueron "tocadas" por al menos 5 puntos
    List<Offset> todosLosPuntos = [..._trazoActual];
    for (var t in _trazos) { todosLosPuntos.addAll(t); }

    int zonasCubiertas = 0;
    for (var zona in zonas) {
      int puntosEnZona = 0;
      for (var punto in todosLosPuntos) {
        if (zona.inflate(10).contains(punto)) puntosEnZona++;
      }
      if (puntosEnZona > 10) zonasCubiertas++; // Exigimos al menos 10 puntos por zona
    }

    // 4. Resultado: Para aprobar necesita cubrir al menos 3 de las 5 zonas
    // Esto obliga al niño a recorrer la forma, no solo a rayar un punto.
    return zonasCubiertas >= 3 ? 1.0 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290, height: 290,
      decoration: BoxDecoration(
        color: widget.completada ? const Color(0xFFE8FFE8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.completada ? const Color(0xFF51CF66) : Colors.black26, width: widget.completada ? 4 : 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: GestureDetector(
          onPanStart: widget.completada ? null : (details) => setState(() => _trazoActual = [details.localPosition]),
          onPanUpdate: widget.completada ? null : (details) => setState(() => _trazoActual = [..._trazoActual, details.localPosition]),
          onPanEnd: widget.completada ? null : (details) {
            setState(() {
              if (_trazoActual.isNotEmpty) _trazos.add(List.from(_trazoActual));
              _trazoActual = [];
            });
          },
          child: CustomPaint(
            painter: _PizarraPainter(trazos: _trazos, trazoActual: _trazoActual, letra: widget.letra, completada: widget.completada),
            child: Container(),
          ),
        ),
      ),
    );
  }
}

// --- PAINTER (Sin cambios) ---
class _PizarraPainter extends CustomPainter {
  final List<List<Offset>> trazos;
  final List<Offset> trazoActual;
  final String letra;
  final bool completada;
  _PizarraPainter({required this.trazos, required this.trazoActual, required this.letra, required this.completada});
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(text: letra, style: TextStyle(color: completada ? Colors.green.withOpacity(0.15) : Colors.grey[300], fontSize: 210, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: size.width);
    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2));
    final paintTrazo = Paint()..color = completada ? Colors.green : const Color(0xFF339AF0)..strokeWidth = 10..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round..style = PaintingStyle.stroke;
    for (final trazo in trazos) { _dibujarTrazo(canvas, trazo, paintTrazo); }
    _dibujarTrazo(canvas, trazoActual, paintTrazo);
  }
  void _dibujarTrazo(Canvas canvas, List<Offset> puntos, Paint paint) {
    if (puntos.length < 2) return;
    final path = Path()..moveTo(puntos[0].dx, puntos[0].dy);
    for (int i = 1; i < puntos.length; i++) { path.lineTo(puntos[i].dx, puntos[i].dy); }
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(_PizarraPainter oldDelegate) => true;
}

// --- BOTÓN ACCIÓN PIZARRA (Sin cambios) ---
class _BotonAccionPizarra extends StatefulWidget {
  final String texto; final Color color; final Color sombra; final VoidCallback? onTap;
  const _BotonAccionPizarra({required this.texto, required this.color, required this.sombra, this.onTap});
  @override State<_BotonAccionPizarra> createState() => _BotonAccionPizarraState();
}
class _BotonAccionPizarraState extends State<_BotonAccionPizarra> {
  bool _presionado = false;
  @override
  Widget build(BuildContext context) {
    final deshabilitado = widget.onTap == null;
    return GestureDetector(
      onTapDown: deshabilitado ? null : (_) => setState(() => _presionado = true),
      onTapUp: deshabilitado ? null : (_) { setState(() => _presionado = false); widget.onTap?.call(); },
      onTapCancel: deshabilitado ? null : () => setState(() => _presionado = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        margin: EdgeInsets.only(top: _presionado ? 5 : 0, bottom: _presionado ? 0 : 5),
        decoration: BoxDecoration(color: deshabilitado ? Colors.grey[400] : widget.sombra, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white, width: 3)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: deshabilitado ? Colors.grey[300] : widget.color, borderRadius: BorderRadius.circular(13)),
          child: Text(widget.texto, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.black38, blurRadius: 4)])),
        ),
      ),
    );
  }
}