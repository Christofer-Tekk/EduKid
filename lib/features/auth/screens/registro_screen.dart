import 'package:flutter/material.dart';
import 'package:edukid/data/services/auth_service.dart';
import '../../../core/widgets/background_wrapper.dart'; // Asegúrate de que la ruta sea correcta

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey            = GlobalKey<FormState>();
  
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading       = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() { _isLoading = true; _errorMessage = null; });

  try {
    await _authService.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      // CAMBIA 'nombre' POR 'displayName' AQUÍ:
      displayName: _nameController.text.trim(), 
    );
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  } catch (e) {
    setState(() => _errorMessage = "Error al registrar: ${e.toString()}");
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BackgroundWrapper(
      // IMPORTANTE: El child debe ser un LayoutBuilder o ocupar todo el espacio
      child: SafeArea(
        child: SizedBox.expand( // Forzamos a que el contenido ocupe toda la pantalla
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Permite scroll suave
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                // Ajustamos el espacio superior
                SizedBox(height: size.height * 0.22),
                
                const Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 5)]
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(
                        controller: _nameController,
                        label: 'Nombre del Niño/a',
                        validator: (v) => v!.isEmpty ? 'Dinos tu nombre' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _emailController,
                        label: 'Correo de Papi/Mami',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => !v!.contains('@') ? 'Correo no válido' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _passwordController,
                        label: 'Contraseña',
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.brown.shade400,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) => v!.length < 6 ? 'Mínimo 6 letras' : null,
                      ),
                      
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _errorMessage!, 
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                          ),
                        ),
                      
                      const SizedBox(height: 30),
                      
                      // Botón
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 8,
                        ),
                        onPressed: _isLoading ? null : _register,
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              '¡REGISTRARME!', 
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                            ),
                      ),
                      
                      const SizedBox(height: 10),

                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text(
                          '¿Ya tienes cuenta? Inicia Sesión',
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Colors.black45, blurRadius: 2)]
                          ),
                        ),
                      ),
                      // Espacio extra al final para que el scroll funcione bien
                      const SizedBox(height: 50),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      validator: validator,
    );
  }
}