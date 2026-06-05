# EduKid

EduKid es una aplicación educativa infantil desarrollada en **Flutter**. Su objetivo es apoyar el aprendizaje básico de niños mediante actividades visuales, auditivas e interactivas relacionadas con letras, números, colores, formas y animales.

El proyecto incluye autenticación con Firebase, inicio de sesión con Google, progreso local separado por usuario, prácticas educativas, pizarra libre y pizarra para colorear.

## Tecnologías utilizadas

- Flutter 3.41.5
- Dart 3.11.3
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- Google Sign-In
- Shared Preferences
- Audioplayers
- YouTube Player Flutter
- Flutter SVG
- Font Awesome Flutter

## Funcionalidades principales

- Registro e inicio de sesión con correo y contraseña.
- Inicio de sesión con Google.
- Persistencia de sesión mediante Firebase Authentication.
- Menú principal con módulos educativos.
- Módulo de abecedario con detalle, audio y práctica de trazado.
- Módulo de números con detalle, audio y práctica de trazado.
- Módulo de colores con detalle, audio y práctica de selección.
- Módulo de formas con detalle, audio y práctica de selección.
- Módulo de animales con detalle, audio y práctica de selección.
- Progreso local separado por usuario.
- Sección de práctica rápida para reforzar letras, números, colores, formas y animales.
- Pizarra libre para dibujar.
- Pizarra para colorear dibujos.
- Botón de retorno directo al menú principal desde distintas pantallas.

## Estructura principal del proyecto

```txt
edukid/
│
├── android/                         # Configuración nativa para Android
│   └── app/
│       ├── google-services.json     # Configuración de Firebase para Android
│       └── src/main/res/            # Recursos nativos e icono de la aplicación
│
├── ios/                             # Configuración nativa para iOS
│
├── assets/                          # Recursos multimedia
│   ├── images/
│   │   ├── abecedario/              # Imágenes de letras
│   │   ├── numeros/                 # Imágenes de números
│   │   ├── animales/                # Imágenes de animales
│   │   ├── colores/                 # Imágenes de colores
│   │   ├── formas/                  # Imágenes de figuras geométricas
│   │   ├── colorear/                # Dibujos para colorear
│   │   └── fondo/                   # Fondos de la aplicación
│   │
│   └── audio/
│       ├── abecedario/              # Audios de letras
│       ├── numeros/                 # Audios de números
│       ├── animales/                # Audios de animales
│       ├── colores/                 # Audios de colores
│       └── formas/                  # Audios de formas
│
├── lib/                             # Código fuente principal
│   ├── main.dart                    # Inicialización de Flutter y Firebase
│   ├── app.dart                     # Rutas y navegación principal
│   ├── firebase_options.dart        # Configuración generada para Firebase
│   │
│   ├── core/                        # Constantes, tema y widgets reutilizables
│   ├── data/                        # Datos locales, modelos y servicios
│   └── features/                    # Módulos funcionales de la aplicación
│       ├── auth/
│       ├── home/
│       ├── abecedario/
│       ├── numeros/
│       ├── colores/
│       ├── formas/
│       ├── animales/
│       ├── practica/
│       └── pizarra/
│
├── pubspec.yaml                     # Dependencias, assets y configuración Flutter
├── pubspec.lock                     # Versiones exactas de dependencias
├── README.md                        # Información general del proyecto
└── analysis_options.yaml            # Reglas de análisis del código Dart
```

## Configuración del entorno

Versión usada durante el desarrollo:

```txt
Flutter 3.41.5
Canal: stable
Dart 3.11.3
DevTools 2.54.2
```

El SDK de Dart requerido está configurado en `pubspec.yaml`:

```yaml
environment:
  sdk: '>=3.11.3 <4.0.0'
```

## Instalación del proyecto

Clonar el repositorio:

```bash
git clone https://github.com/Christofer-Tekk/EduKid.git
cd EduKid
git checkout develop
```

Instalar dependencias:

```bash
flutter pub get
```

Ejecutar en un dispositivo Android conectado:

```bash
flutter run
```

## Generación de APK

Para revisión académica se recomienda generar una APK debug, debido a que Firebase y Google Sign-In dependen de la huella SHA-1 del certificado con el que se firma la aplicación.

Comandos recomendados:

```bash
flutter clean
flutter pub get
flutter build apk --debug
```

La APK se genera en:

```txt
build/app/outputs/flutter-apk/app-debug.apk
```

Opcionalmente, se puede copiar el archivo generado a la raíz del proyecto:

```powershell
Copy-Item "build\\app\\outputs\\flutter-apk\\app-debug.apk" ".\\EduKid-debug.apk"
```

## Configuración de Firebase

El proyecto utiliza Firebase para autenticación y almacenamiento de datos básicos del usuario. Los archivos principales de configuración son:

- `lib/firebase_options.dart`
- `android/app/google-services.json`

Firebase Authentication permite el inicio de sesión con correo/contraseña y Google. Cloud Firestore almacena información básica del usuario. El progreso educativo se guarda localmente por usuario mediante `shared_preferences`.

## Observaciones

- La aplicación fue desarrollada y probada principalmente en Android.
- La APK debug entregada está pensada para revisión académica e instalación directa.
- Para compilar la app desde otra computadora y usar Google Sign-In, puede ser necesario agregar el SHA-1 del certificado debug correspondiente en Firebase.
- Las carpetas generadas automáticamente como `build/`, `.dart_tool/` y `.gradle/` no forman parte de la estructura principal que debe documentarse.
