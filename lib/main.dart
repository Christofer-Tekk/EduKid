import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Este archivo debe estar en lib/
import 'app.dart'; 

void main() async {
  // 1. Asegura que Flutter esté listo
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inicializa Firebase antes de lanzar la App
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const EduKidApp());
}