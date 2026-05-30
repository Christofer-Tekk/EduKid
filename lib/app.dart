// lib/app.dart

import 'package:flutter/material.dart';

import 'features/auth/screens/auth_gate_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/registro_screen.dart';
import 'features/home/screens/menu_screen.dart';

import 'features/abecedario/screens/abecedario_screen.dart';
import 'features/abecedario/screens/letra_detalle_screen.dart';
import 'features/abecedario/screens/letra_practica_screen.dart';

import 'features/numeros/screens/numeros_screen.dart';
import 'features/numeros/screens/numero_detalle_screen.dart';
import 'features/numeros/screens/numero_practica_screen.dart';

import 'features/colores/screens/colores_screen.dart';
import 'features/colores/screens/color_detalle_screen.dart';
import 'features/colores/screens/color_practica_screen.dart';

import 'features/formas/screens/formas_screen.dart';
import 'features/formas/screens/forma_detalle_screen.dart';
import 'features/formas/screens/forma_practica_screen.dart';

import 'features/animales/screens/animales_screen.dart';
import 'features/animales/screens/animal_detalle_screen.dart';
import 'features/animales/screens/animal_practica_screen.dart';

import 'features/pizarra/screens/pizarra_menu_screen.dart';
import 'features/pizarra/screens/pizarra_libre_screen.dart';
import 'features/pizarra/screens/pizarra_colorear_lista_screen.dart';
import 'features/pizarra/screens/pizarra_colorear_screen.dart';

import 'features/practica/screens/practica_menu_screen.dart';
import 'features/practica/screens/practica_abecedario_screen.dart';
import 'features/practica/screens/practica_numeros_screen.dart';
import 'features/practica/screens/practica_colores_screen.dart';
import 'features/practica/screens/practica_formas_screen.dart';
import 'features/practica/screens/practica_animales_screen.dart';

class EduKidApp extends StatelessWidget {
  const EduKidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduKid',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthGateScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MenuScreen(),

        '/letras': (context) => const AbecedarioScreen(),
        '/letra_detalle': (context) => const LetraDetalleScreen(),
        '/letra_practica': (context) => const LetraPracticaScreen(),

        '/numeros': (context) => const NumerosScreen(),
        '/numero_detalle': (context) => const NumeroDetalleScreen(),
        '/numero_practica': (context) => const NumeroPracticaScreen(),

        '/colores': (context) => const ColoresScreen(),
        '/color_detalle': (context) => const ColorDetalleScreen(),
        '/color_practica': (context) => const ColorPracticaScreen(),

        '/formas': (context) => const FormasScreen(),
        '/forma_detalle': (context) => const FormaDetalleScreen(),
        '/forma_practica': (context) => const FormaPracticaScreen(),

        '/animales': (context) => const AnimalesScreen(),
        '/animal_detalle': (context) => const AnimalDetalleScreen(),
        '/animal_practica': (context) => const AnimalPracticaScreen(),

        '/pizarra': (context) => const PizarraMenuScreen(),
        '/pizarra_libre': (context) => const PizarraLibreScreen(),
        '/pizarra_colorear_lista': (context) => const PizarraColorearListaScreen(),
        '/pizarra_colorear': (context) => const PizarraColorearScreen(),

        '/practica': (context) => const PracticaMenuScreen(),
        '/practica_abecedario': (context) => const PracticaAbecedarioScreen(),
        '/practica_numeros': (context) => const PracticaNumerosScreen(),
        '/practica_colores': (context) => const PracticaColoresScreen(),
        '/practica_formas': (context) => const PracticaFormasScreen(),
        '/practica_animales': (context) => const PracticaAnimalesScreen(),
      },
    );
  }
}
