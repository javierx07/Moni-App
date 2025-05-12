import 'package:flutter/material.dart';

void main() => runApp(IngresoPantalla());

class IngresoPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IngresoFormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IngresoFormPage extends StatefulWidget {
  @override
  _IngresoFormPageState createState() => _IngresoFormPageState();
}

class _IngresoFormPageState extends State<IngresoFormPage> {
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController montoController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();

  String? categoriaSeleccionada;

  final List<String> categorias = [
    'Salario',
    'Remesas',
    'Depósitos Bancarios',
    'Ahorros',
    'Prestamos',
    'Otros Ingresos',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(24, 43, 58, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Agregar / Editar Ingreso',
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
              GestureDetector(
                onTap: () async {
                  DateTime? fechaSeleccionada = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: Color.fromRGBO(18, 124, 108, 1),
                            onPrimary: Colors.white,
                            surface: Color.fromRGBO(36, 64, 88, 1),
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: Color.fromRGBO(24, 43, 58, 1),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (fechaSeleccionada != null) {
                    String fechaFormateada =
                        "${fechaSeleccionada.day.toString().padLeft(2, '0')}/${fechaSeleccionada.month.toString().padLeft(2, '0')}/${fechaSeleccionada.year}";
                    setState(() {
                      fechaController.text = fechaFormateada;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: campoTexto(fechaController, "dd/mm/aaaa"),
                ),
              ),
              SizedBox(height: 30),
              boton("INGRESAR", Color.fromRGBO(18, 124, 108, 1), () async {
                final gasto = Gasto(
                  descripcion: descripcionController.text,
                  categoria: categoriaSeleccionada ?? "",
                  monto: double.tryParse(montoController.text) ?? 0.0,
                  fecha: fechaController.text,
                );
                /* await DBHelper.insertarGasto(gasto);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gasto guardado correctamente")),
                );*/
              }),
              SizedBox(height: 10),
              boton("ELIMINAR", Color.fromRGBO(153, 79, 98, 1), () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmacionDialog(),
                );
              }),
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
        hintStyle: TextStyle(color: Colors.grey),
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
        color: Color.fromRGBO(36, 64, 88, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Color.fromRGBO(36, 64, 88, 1),
          hint: Text("Seleccionar", style: TextStyle(color: Colors.white)),
          value: categoriaSeleccionada,
          items:
              categorias
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: TextStyle(color: Colors.white)),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              categoriaSeleccionada = value;
            });
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

class ConfirmacionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(36, 64, 88, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Text(
          '¿Seguro que deseas eliminar?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(145, 145, 145, 1),
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text('CANCELAR'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(153, 79, 98, 1),
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            // Aquí puedes usar un ID si implementas edición/borrado real
            Navigator.of(context).pop();
          },
          child: Text('ELIMINAR'),
        ),
      ],
    );
  }
}

class Gasto {
  final int? id;
  final String descripcion;
  final String categoria;
  final double monto;
  final String fecha;

  Gasto({
    this.id,
    required this.descripcion,
    required this.categoria,
    required this.monto,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'categoria': categoria,
      'monto': monto,
      'fecha': fecha,
    };
  }
}
