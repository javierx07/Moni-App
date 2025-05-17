import 'package:flutter/material.dart';
import '../constantes.dart';
import '../modelos/modelo_transaccion.dart';
import '../almacenamiento/servicio_almacenamiento.dart';
import 'pantalla_gastos.dart';
import 'pantalla_ingresos.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({Key? key}) : super(key: key);

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  double _balance = 0.0;
  double _totalIngresos = 0.0;
  double _totalGastos = 0.0;
  Map<String, List<Transaccion>> _transaccionesPorCategoria = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final balance = await ServicioAlmacenamiento.obtenerBalance();
    final ingresos = await ServicioAlmacenamiento.obtenerTotalIngresos();
    final gastos = await ServicioAlmacenamiento.obtenerTotalGastos();
    final transacciones = await ServicioAlmacenamiento.obtenerTransacciones();

    // Agrupar transacciones por categoría
    final Map<String, List<Transaccion>> transaccionesPorCategoria = {};

    for (var transaccion in transacciones) {
      if (!transaccionesPorCategoria.containsKey(transaccion.categoria)) {
        transaccionesPorCategoria[transaccion.categoria] = [];
      }
      transaccionesPorCategoria[transaccion.categoria]!.add(transaccion);
    }

    setState(() {
      _balance = balance;
      _totalIngresos = ingresos;
      _totalGastos = gastos;
      _transaccionesPorCategoria = transaccionesPorCategoria;
    });
  }

  Future<void> _eliminarTransaccion(String id) async {
    await ServicioAlmacenamiento.eliminarTransaccion(id);
    _cargarDatos();
  }

  Future<bool> _mostrarDialogoConfirmacion() async {
    bool eliminar = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColoresMoni.fondoSecundario,
          title: Text(
            '¿Seguro que deseas eliminar?',
            style: EstilosMoni.subtitulo,
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresMoni.grisClaro,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('CANCELAR', style: EstilosMoni.textoNormal),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresMoni.rosa,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      eliminar = true;
                      Navigator.of(context).pop();
                    },
                    child: Text('ELIMINAR', style: EstilosMoni.textoNormal),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    return eliminar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresMoni.fondoPrincipal,
      body: SafeArea(
        child: Column(
          children: [
            // Balance
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ColoresMoni.fondoSecundario,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Text('Balance', style: EstilosMoni.subtitulo),
                  const SizedBox(height: 8),
                  Text(
                    '\$${_balance.toStringAsFixed(2)}',
                    style: EstilosMoni.montoGrande,
                  ),
                ],
              ),
            ),

            // Resumen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RESUMEN', style: EstilosMoni.textoNormal),
                  const SizedBox(height: 8),
                  // Ingresos
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: ColoresMoni.fondoSecundario,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ingresos', style: EstilosMoni.textoNormal),
                        Text(
                          '\$${_totalIngresos.toStringAsFixed(2)}',
                          style: EstilosMoni.montoPositivo,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Gastos
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: ColoresMoni.fondoSecundario,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Gastos', style: EstilosMoni.textoNormal),
                        Text(
                          '\$${_totalGastos.toStringAsFixed(2)}',
                          style: EstilosMoni.montoNegativo,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Categorías
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CATEGORÍAS', style: EstilosMoni.textoNormal),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Lista de transacciones
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _transaccionesPorCategoria.keys.length,
                itemBuilder: (context, index) {
                  final categoria = _transaccionesPorCategoria.keys.elementAt(
                    index,
                  );
                  final transacciones = _transaccionesPorCategoria[categoria]!;

                  // Calcula el total para esta categoría
                  double totalCategoria = 0;
                  for (var transaccion in transacciones) {
                    totalCategoria += transaccion.monto;
                  }

                  // Si todas las transacciones son del mismo tipo, muestra una categoría
                  if (transacciones.isNotEmpty &&
                      transacciones.every(
                        (t) => t.tipo == transacciones.first.tipo,
                      )) {
                    final primerTransaccion = transacciones.first;
                    final esIngreso =
                        primerTransaccion.tipo == TipoTransaccion.ingreso;

                    // Ordenar las transacciones por fecha, más reciente primero
                    transacciones.sort((a, b) => b.fecha.compareTo(a.fecha));

                    return Card(
                      color: ColoresMoni.fondoSecundario,
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(categoria, style: EstilosMoni.textoNormal),
                            Text(
                              '\$${totalCategoria.toStringAsFixed(2)}',
                              style:
                                  esIngreso
                                      ? EstilosMoni.montoPositivo
                                      : EstilosMoni.montoNegativo,
                            ),
                          ],
                        ),
                        children:
                            transacciones.map((transaccion) {
                              return ListTile(
                                title: Text(
                                  transaccion.descripcion,
                                  style: EstilosMoni.textoNormal,
                                ),
                                subtitle: Text(
                                  '${_formatFecha(transaccion.fecha)}',
                                  style: TextStyle(
                                    color: ColoresMoni.grisClaro,
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '\$${transaccion.monto.toStringAsFixed(2)}',
                                      style:
                                          esIngreso
                                              ? EstilosMoni.montoPositivo
                                              : EstilosMoni.montoNegativo,
                                    ),
                                    IconButton(
                                      icon: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: ColoresMoni.rosa,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          'Borrar',
                                          style: TextStyle(
                                            color: ColoresMoni.blanco,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        bool confirmar =
                                            await _mostrarDialogoConfirmacion();
                                        if (confirmar) {
                                          await _eliminarTransaccion(
                                            transaccion.id,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    );
                  }

                  // Si hay mezcla de tipos, no mostrar esta categoría
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Logo y botones de navegación
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              color: ColoresMoni.fondoPrincipal,
              child: Column(
                children: [
                  Image.asset('assets/images/logo_moni.png', height: 40),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PantallaGastos(),
                              ),
                            );
                            _cargarDatos();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              color: ColoresMoni.rosa,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text(
                              'GASTOS',
                              textAlign: TextAlign.center,
                              style: EstilosMoni.textoNormal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PantallaIngresos(),
                              ),
                            );
                            _cargarDatos();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              color: ColoresMoni.verdeAcentuado,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text(
                              'INGRESOS',
                              textAlign: TextAlign.center,
                              style: EstilosMoni.textoNormal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }
}
