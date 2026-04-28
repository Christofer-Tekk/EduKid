import 'package:flutter/material.dart';
// Aquí importamos tu pizarra para poder abrirla
import '../abecedario/screens/letra_practica_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100], 
      body: Center(
        child: SingleChildScrollView( // Esto evita errores si la pantalla es muy pequeña
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Espacio temporal para el Logo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                color: Colors.grey[300],
                child: const Text(
                  'assets/images/logo.png',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'serif'),
                ),
              ),
              const SizedBox(height: 40),
              
              // 1. Abecedario
              _crearBotonMenu(
                context, 
                titulo: 'Abecedario', 
                color: Colors.teal, // Un color similar al del mockup
                icono: Icons.sort_by_alpha,
                alPresionar: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Módulo Abecedario en construcción')),
                  );
                }
              ),

              // 2. Números
               _crearBotonMenu(
                context, 
                titulo: 'Números', 
                color: Colors.orange[400]!,
                icono: Icons.numbers,
                alPresionar: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Módulo Números en construcción')),
                  );
                }
              ),

              // 3. Colores
               _crearBotonMenu(
                context, 
                titulo: 'Colores', 
                color: Colors.redAccent[200]!,
                icono: Icons.palette,
                alPresionar: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Módulo Colores en construcción')),
                  );
                }
              ),

              // 4. Figuras Geométricas
               _crearBotonMenu(
                context, 
                titulo: 'Figuras Geométricas', 
                color: Colors.pinkAccent[200]!,
                icono: Icons.category,
                alPresionar: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Módulo Figuras en construcción')),
                  );
                }
              ),

              // 5. Pizarra (¡El tuyo!)
              _crearBotonMenu(
                context, 
                titulo: 'Pizarra', 
                color: Colors.deepPurple[100]!, // Color clarito como en el mockup
                icono: Icons.draw,
                colorTexto: Colors.black, // El texto del mockup es negro aquí
                alPresionar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LetraPracticaScreen(letra: 'A'), 
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ajusté esta función para que reciba el color del texto si queremos cambiarlo
  Widget _crearBotonMenu(BuildContext context, {required String titulo, required Color color, required IconData icono, required VoidCallback alPresionar, Color colorTexto = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: 280, // Ancho fijo para que todos los botones se vean del mismo tamaño
        child: ElevatedButton.icon(
          icon: Icon(icono, size: 30, color: colorTexto),
          label: Text(titulo, style: TextStyle(fontSize: 22, color: colorTexto, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: alPresionar,
        ),
      ),
    );
  }
}