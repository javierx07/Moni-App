import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constantes.dart';
import 'pantallas/pantalla_principal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación solo en vertical
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurar el color de la barra de estado
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MoniApp());
}

class MoniApp extends StatelessWidget {
  const MoniApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moni App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: ColoresMoni.fondoPrincipal,
        primaryColor: ColoresMoni.verdeAcentuado,
        colorScheme: ColorScheme.dark(
          primary: ColoresMoni.verdeAcentuado,
          surface: ColoresMoni.fondoSecundario,
          onSurface: ColoresMoni.blanco,
        ),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: EstilosMoni.tituloGrande,
          displayMedium: EstilosMoni.tituloMedio,
          titleMedium: EstilosMoni.subtitulo,
          bodyMedium: EstilosMoni.textoNormal,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColoresMoni.verdeAcentuado,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColoresMoni.azulMedio,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
        ),
      ),
      home: const PantallaPrincipal(),
    );
  }
}
