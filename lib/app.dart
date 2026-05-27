import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/registro_screen.dart';
import 'features/home/screens/menu_screen.dart';
import 'features/abecedario/screens/abecedario_screen.dart';
import 'features/abecedario/screens/letra_detalle_screen.dart';
import 'features/abecedario/screens/letra_practica_screen.dart';
import 'features/colores/screens/colores_screen.dart';
import 'features/colores/screens/color_detalle_screen.dart';
import 'features/colores/screens/color_practica_screen.dart';
import 'features/pizarra/screens/pizarra_libre_screen.dart';
import 'features/pizarra/screens/pizarra_guiada_screen.dart';
import 'features/formas/screens/formas_screen.dart';
import 'features/formas/screens/forma_detalle_screen.dart';
import 'features/formas/screens/forma_practica_screen.dart';
import 'features/numeros/screens/numeros_screen.dart';
import 'features/numeros/screens/numero_detalle_screen.dart';
import 'features/numeros/screens/numero_practica_screen.dart';
import 'features/animales/screens/animales_screen.dart';
import 'features/animales/screens/animal_detalle_screen.dart';
import 'features/animales/screens/animal_practica_screen.dart';

class EduKidApp extends StatelessWidget {
  const EduKidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduKid',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(), // Cambiado a registro_screen.dart
        '/home': (context) => const MenuScreen(),
        '/letras': (context) => const AbecedarioScreen(),
        '/letra_detalle': (context) => const LetraDetalleScreen(),
        '/letra_practica': (context) => const LetraPracticaScreen(),
        '/colores': (context) => const ColoresScreen(),
        '/color_detalle': (context) => const ColorDetalleScreen(),
        '/color_practica': (context) => const ColorPracticaScreen(),
        '/pizarra_libre': (context) => const PizarraLibreScreen(),
        '/pizarra_guiada': (context) => const PizarraGuiadaScreen(),
        '/formas':        (_) => const FormasScreen(),
        '/forma_detalle': (_) => const FormaDetalleScreen(),
        '/forma_practica': (_) => const FormaPracticaScreen(),
        '/numeros': (context) => const NumerosScreen(),
        '/numero_detalle': (context) => const NumeroDetalleScreen(),
        '/numero_practica': (context) => NumeroPracticaScreen(),
        '/animales': (context) => const AnimalesScreen(),
        '/animal_detalle': (context) => const AnimalDetalleScreen(),
        '/animal_practica': (context) => const AnimalPracticaScreen(),
      },
    );
  }
}
