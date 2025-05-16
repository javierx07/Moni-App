import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../constantes.dart';
import '../modelos/modelo_transaccion.dart';
import '../almacenamiento/servicio_almacenamiento.dart';

class PantallaIngresos extends StatefulWidget {
  const PantallaIngresos({Key? key}) : super(key: key);

  @override
  _PantallaIngresosState createState() => _PantallaIngresosState();
}

class _PantallaIngresosState extends State<PantallaIngresos> {
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  String _categoriaSeleccionada = '';
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fechaController.text = DateFormat('dd/MM/yyyy').format(_fechaSeleccionada);
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: ColoresMoni.verdeAcentuado,
              onPrimary: ColoresMoni.blanco,
              surface: ColoresMoni.fondoSecundario,
              onSurface: ColoresMoni.blanco,
            ),
            dialogBackgroundColor: ColoresMoni.fondoPrincipal,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _fechaSeleccionada = pickedDate;
        _fechaController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _guardarIngreso() async {
    // Validar campos
    if (_descripcionController.text.isEmpty ||
        _montoController.text.isEmpty ||
        _categoriaSeleccionada.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos'),
          backgroundColor: ColoresMoni.rosa,
        ),
      );
      return;
    }

    try {
      final double monto = double.parse(
        _montoController.text.replaceAll(',', '.'),
      );

      if (monto <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El monto debe ser mayor a cero'),
            backgroundColor: ColoresMoni.rosa,
          ),
        );
        return;
      }

      // Crear transacción
      final nuevaTransaccion = Transaccion(
        id: const Uuid().v4(),
        descripcion: _descripcionController.text,
        categoria: _categoriaSeleccionada,
        monto: monto,
        fecha: _fechaSeleccionada,
        tipo: TipoTransaccion.ingreso,
      );

      // Guardar transacción
      await ServicioAlmacenamiento.agregarTransaccion(nuevaTransaccion);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingreso guardado correctamente'),
          backgroundColor: ColoresMoni.verdeAcentuado,
        ),
      );

      // Limpiar formulario
      _descripcionController.clear();
      _montoController.clear();
      setState(() {
        _categoriaSeleccionada = '';
        _fechaSeleccionada = DateTime.now();
        _fechaController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(_fechaSeleccionada);
      });

      // Volver a la pantalla principal
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: ColoresMoni.rosa,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresMoni.fondoPrincipal,
      appBar: AppBar(
        backgroundColor: ColoresMoni.fondoPrincipal,
        elevation: 0,
        title: const Text('Agregar Ingreso', style: EstilosMoni.tituloMedio),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descripción
            const Text('DESCRIPCIÓN:', style: EstilosMoni.etiquetaFormulario),
            const SizedBox(height: 8),
            TextField(
              controller: _descripcionController,
              style: EstilosMoni.textoNormal,
              decoration: DecoradoresMoni.inputDecoracion(
                hintText: 'Ingresar Descripción',
              ),
            ),
            const SizedBox(height: 16),

            // Categoría
            const Text('CATEGORÍA:', style: EstilosMoni.etiquetaFormulario),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: BoxDecoration(
                color: ColoresMoni.azulMedio,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value:
                      _categoriaSeleccionada.isEmpty
                          ? null
                          : _categoriaSeleccionada,
                  hint: Text(
                    'Seleccionar',
                    style: TextStyle(
                      color: ColoresMoni.blanco.withOpacity(0.5),
                    ),
                  ),
                  dropdownColor: ColoresMoni.azulMedio,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: ColoresMoni.blanco,
                  ),
                  isExpanded: true,
                  style: EstilosMoni.textoNormal,
                  items:
                      CategoriasMoni.ingresos.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _categoriaSeleccionada = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Monto
            const Text('MONTO:', style: EstilosMoni.etiquetaFormulario),
            const SizedBox(height: 8),
            TextField(
              controller: _montoController,
              style: EstilosMoni.textoNormal,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: DecoradoresMoni.inputDecoracion(hintText: '\$0.00'),
            ),
            const SizedBox(height: 16),

            // Fecha
            const Text('FECHA:', style: EstilosMoni.etiquetaFormulario),
            const SizedBox(height: 8),
            TextField(
              controller: _fechaController,
              style: EstilosMoni.textoNormal,
              readOnly: true,
              onTap: _seleccionarFecha,
              decoration: DecoradoresMoni.inputDecoracion(
                hintText: 'dd/mm/aaaa',
              ),
            ),
            const SizedBox(height: 40),

            // Botón Agregar
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColoresMoni.verdeAcentuado,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _guardarIngreso,
                  child: const Text('AGREGAR', style: EstilosMoni.subtitulo),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
