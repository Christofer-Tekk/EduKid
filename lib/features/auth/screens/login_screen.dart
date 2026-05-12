import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/colores_app.dart';
import '../../../core/service/google_sign_in_service.dart';
import '../../../core/widgets/app_texto.dart';
import '../../../core/widgets/background_wrapper.dart';
import '../../../data/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final AuthService _authService = AuthService();
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _submitted = false;
  bool _emailTouched = false;
  bool _passwordTouched = false;

  String? _emailError;
  String? _passwordError;
  String? _topMessage;
  Timer? _messageTimer;

  static const Color _naranjaClaro = Color(0xFFFF8C00);
  static const Color _naranjaFuerte = Color(0xFFFF6000);
  static const Color _rojoError = Color(0xFFE53935);
  static const Color _textoError = Color(0xFFC62828);
  static const Color _fondoError = Color(0xFFFFEBEE);

  @override
  void dispose() {
    _messageTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    final email = value.trim();
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    return regex.hasMatch(email);
  }

  String? _getEmailError() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      if (_submitted || _emailTouched) {
        return 'Primero escribe tu correo.';
      }
      return null;
    }

    if (!_isValidEmail(email)) {
      return 'Escribe un correo válido.';
    }

    return null;
  }

  String? _getPasswordError() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_isValidEmail(email)) {
      final shouldWarnPassword = password.isNotEmpty || (_passwordTouched && !_submitted);

      if (shouldWarnPassword) {
        if (email.isEmpty) {
          return 'Primero escribe tu correo.';
        }
        return 'Primero escribe un correo válido.';
      }

      return null;
    }

    if (password.isEmpty) {
      if (_submitted || _passwordTouched) {
        return 'Ahora escribe tu contraseña.';
      }
      return null;
    }

    return null;
  }

  bool _updateInlineErrors({
    bool submit = false,
    bool touchEmail = false,
    bool touchPassword = false,
  }) {
    String? nextEmailError;
    String? nextPasswordError;

    setState(() {
      if (submit) {
        _submitted = true;
        _emailTouched = true;
      }
      if (touchEmail) {
        _emailTouched = true;
      }
      if (touchPassword) {
        _passwordTouched = true;
      }

      nextEmailError = _getEmailError();
      nextPasswordError = _getPasswordError();

      _emailError = nextEmailError;
      _passwordError = nextPasswordError;
    });

    return nextEmailError == null && nextPasswordError == null;
  }

  void _showTopMessage(String message) {
    _messageTimer?.cancel();

    setState(() => _topMessage = message);

    _messageTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() => _topMessage = null);
    });
  }

  void _clearTopMessage() {
    _messageTimer?.cancel();
    if (_topMessage == null) return;
    setState(() => _topMessage = null);
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final isValid = _updateInlineErrors(submit: true);
    if (!isValid) return;

    _messageTimer?.cancel();
    setState(() {
      _isLoading = true;
      _topMessage = null;
    });

    try {
      await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showTopMessage(_mapError(e.code));
    } catch (_) {
      if (!mounted) return;
      _showTopMessage('No se pudo iniciar sesión. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    _messageTimer?.cancel();
    setState(() {
      _isGoogleLoading = true;
      _topMessage = null;
    });

    try {
      final userCredential = await _googleSignInService.signInWithGoogle();

      if (userCredential != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (_) {
      if (!mounted) return;
      _showTopMessage('Error al continuar con Google. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showTopMessage('Primero escribe tu correo para recuperar tu cuenta.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showTopMessage('Escribe un correo válido para recuperar tu cuenta.');
      return;
    }

    _clearTopMessage();

    try {
      await _authService.sendPasswordReset(email);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correo de recuperación enviado. Revisa tu bandeja.'),
          backgroundColor: Color(0xFF43A047),
          duration: Duration(seconds: 3),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showTopMessage(_mapError(e.code));
    } catch (_) {
      if (!mounted) return;
      _showTopMessage('No se pudo enviar el correo de recuperación.');
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con ese correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'too-many-requests':
        return 'Demasiados intentos. Espera un momento.';
      case 'network-request-failed':
        return 'Revisa tu conexión a internet.';
      default:
        return 'Error al iniciar sesión. Intenta de nuevo.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final busy = _isLoading || _isGoogleLoading;

    return BackgroundWrapper(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.18),

                  _buildAnimatedTopMessage(),

                  const SizedBox(height: 10),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInputField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          hintText: 'Correo electrónico',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !busy,
                          errorText: _emailError,
                          onTap: () {
                            _clearTopMessage();
                            _updateInlineErrors(touchEmail: true);
                          },
                          onChanged: (_) {
                            _clearTopMessage();
                            _updateInlineErrors(touchEmail: true);
                          },
                        ),

                        const SizedBox(height: 14),

                        _buildInputField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          hintText: 'Contraseña',
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          enabled: !busy,
                          errorText: _passwordError,
                          onTap: () {
                            _clearTopMessage();
                            _updateInlineErrors(touchPassword: true);
                          },
                          onChanged: (_) {
                            _clearTopMessage();
                            _updateInlineErrors(touchPassword: true);
                          },
                          onFieldSubmitted: (_) {
                            if (!busy) _login();
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey.shade500,
                              size: 22,
                            ),
                            onPressed: busy
                                ? null
                                : () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildPrimaryButton(
                          text: 'Iniciar Sesión',
                          isLoading: _isLoading,
                          onTap: busy ? null : _login,
                        ),

                        const SizedBox(height: 12),

                        _buildDivider(),

                        const SizedBox(height: 12),

                        _buildGoogleButton(busy: busy),

                        const SizedBox(height: 16),

                        _buildMiniAction(
                          title: '¿Olvidaste tu contraseña?',
                          buttonText: 'Recuperar acceso',
                          color: ColoresApp.naranjaVibrante,
                          onTap: busy ? null : _forgotPassword,
                        ),

                        const SizedBox(height: 12),

                        _buildMiniAction(
                          title: '¿No tienes cuenta?',
                          buttonText: 'Crear cuenta gratis',
                          color: ColoresApp.completado,
                          onTap: busy
                              ? null
                              : () => Navigator.pushReplacementNamed(context, '/register'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffixIcon,
    String? errorText,
    void Function()? onTap,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white.withOpacity(0.96),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: hasError ? _rojoError : Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? _rojoError : Colors.grey.shade300,
                width: hasError ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? _rojoError : _naranjaFuerte,
                width: hasError ? 2.2 : 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        _buildInlineError(errorText),
      ],
    );
  }

  Widget _buildInlineError(String? message) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          ),
        );
      },
      child: message == null || message.isEmpty
          ? const SizedBox(key: ValueKey('sin_error_inline'), height: 0)
          : Container(
              key: ValueKey(message),
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _fondoError.withOpacity(0.96),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _rojoError, width: 1.3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _textoError,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
            ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required bool isLoading,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onTap == null ? 0.65 : 1,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_naranjaClaro, _naranjaFuerte],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _naranjaFuerte.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.75),
            thickness: 1,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'O',
            style: TextStyle(
              color: ColoresApp.cafe,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.75),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton({required bool busy}) {
    return GestureDetector(
      onTap: busy ? null : _signInWithGoogle,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: busy ? 0.65 : 1,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.97),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: _isGoogleLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: _naranjaFuerte,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/fondo/Google_Favicon.svg',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continuar con Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniAction({
    required String title,
    required String buttonText,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTexto.cuerpo(
          title,
          textAlign: TextAlign.center,
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w900,
          shadows: SombrasApp.negraSubtitulo,
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onTap,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: onTap == null ? 0.6 : 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white, width: 1.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedTopMessage() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          ),
        );
      },
      child: _topMessage == null
          ? const SizedBox(key: ValueKey('sin_mensaje'), height: 0)
          : _buildTopErrorBox(
              _topMessage!,
              key: ValueKey(_topMessage),
            ),
    );
  }

  Widget _buildTopErrorBox(String message, {Key? key}) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _fondoError.withOpacity(0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _rojoError, width: 1.4),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _textoError,
          fontSize: 13.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
