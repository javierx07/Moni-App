import 'package:flutter/material.dart';

void main() => runApp(AgregarGasto());

class AgregarGasto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GastoFormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GastoFormPage extends StatelessWidget {
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  String? categoriaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(24, 43, 58, 100), // fondo oscuro
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Agregar / Editar Gasto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              campoEtiqueta("DESCRIPCION:"),
              campoTexto(descripcionController, "Ingresar Descripcion"),
              campoEtiqueta("CATEGORIA:"),
              categoriaDropdown(),
              campoEtiqueta("MONTO:"),
              campoTexto(montoController, "\$0.00", tipo: TextInputType.number),
              campoEtiqueta("FECHA:"),
              campoTexto(fechaController, "dd/mm/aaaa"),
              SizedBox(height: 30),
              boton("INGRESAR", Color.fromRGBO(18, 124, 108, 100), () {}),
              SizedBox(height: 10),
              boton("ELIMINAR", Color.fromRGBO(153, 79, 98, 100), () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget campoEtiqueta(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        texto,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget campoTexto(
    TextEditingController controller,
    String hint, {
    TextInputType tipo = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: tipo,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Color.fromRGBO(145, 145, 145, 100)),
        filled: true,
        fillColor: Color.fromRGBO(28, 58, 82, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget categoriaDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1C3A52),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Color.fromRGBO(36, 64, 88, 100),
          hint: Text("Seleccionar", style: TextStyle(color: Colors.white)),
          value: categoriaSeleccionada,
          items:
              ['Comida', 'Transporte', 'Ocio']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: TextStyle(color: Colors.white)),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            // Lógica al seleccionar
          },
        ),
      ),
    );
  }

  Widget boton(String texto, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(texto, style: TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
