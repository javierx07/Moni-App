import 'package:flutter/material.dart';

// Colores para la aplicación
class ColoresMoni {
  static const Color fondoPrincipal = Color(0xFF182B3A);
  static const Color fondoSecundario = Color(0xFF1E3A52);
  static const Color verdeAcentuado = Color(0xFF127C6C);
  static const Color blanco = Color(0xFFFFFFFF);
  static const Color grisClaro = Color(0xFF919191);
  static const Color rosa = Color(0xFF994F62);
  static const Color azulOscuro = Color(0xFF182B3A);
  static const Color azulMedio = Color(0xFF244058);
  
  // Colores mostrados en el diseño
  static const Color blancoPuro = Color(0xFFFFFFFF);     // FFFFFF
  static const Color verdePrincipal = Color(0xFF127C6C); // 127C6C
  static const Color gris = Color(0xFF919191);           // 919191
  static const Color rosaClaro = Color(0xFF994F62);      // 994F62
  static const Color azulProfundo = Color(0xFF182B3A);   // 182B3A
  static const Color azulMedioDos = Color(0xFF244058);   // 244058
}

// Estilos de texto para la aplicación
class EstilosMoni {
  static const TextStyle tituloGrande = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: ColoresMoni.blanco,
  );
  
  static const TextStyle tituloMedio = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: ColoresMoni.blanco,
  );
  
  static const TextStyle subtitulo = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // Medium
    color: ColoresMoni.blanco,
  );
  
  static const TextStyle textoNormal = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    fontWeight: FontWeight.normal, // Regular
    color: ColoresMoni.blanco,
  );
  
  static const TextStyle textoDestacado = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // Medium
    color: ColoresMoni.verdePrincipal,
  );
  
  static const TextStyle montoGrande = TextStyle(
    fontFamily: 'Inter',
    fontSize: 36.0,
    fontWeight: FontWeight.bold,
    color: ColoresMoni.blanco,
  );
  
  static const TextStyle montoPositivo = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // Medium
    color: ColoresMoni.verdePrincipal,
  );
  
  static const TextStyle montoNegativo = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // Medium
    color: ColoresMoni.rosa,
  );
  
  static const TextStyle etiquetaFormulario = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.0,
    fontWeight: FontWeight.w500, // Medium
    color: ColoresMoni.blanco,
  );
}

// Categorías para la aplicación
class CategoriasMoni {
  static const List<String> gastos = [
    'Alimentación',
    'Transporte',
    'Alquiler',
    'Facturas',
    'Teléfono',
    'Salud',
    'Higiene',
    'Educación',
    'Mascotas',
    'Ropa',
    'Ahorros',
    'Préstamos',
    'Otras Compras',
    'Otros Gastos',
  ];
  
  static const List<String> ingresos = [
    'Salario',
    'Remesas',
    'Ahorros',
    'Préstamos',
    'Otros Ingresos',
    'Transferencias Bancarias',
  ];
}

// Decoración para los inputs
class DecoradoresMoni {
  static InputDecoration inputDecoracion({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: ColoresMoni.blanco.withOpacity(0.5)),
      filled: true,
      fillColor: ColoresMoni.azulMedio,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
    );
  }
}
