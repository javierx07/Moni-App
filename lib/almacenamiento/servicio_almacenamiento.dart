import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/modelo_transaccion.dart';

class ServicioAlmacenamiento {
  static const String _keyTransacciones = 'transacciones';

  // Guardar todas las transacciones
  static Future<void> guardarTransacciones(
    List<Transaccion> transacciones,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> transaccionesString =
        transacciones.map((transaccion) => transaccion.toJson()).toList();
    await prefs.setStringList(_keyTransacciones, transaccionesString);
  }

  // Obtener todas las transacciones
  static Future<List<Transaccion>> obtenerTransacciones() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? transaccionesString = prefs.getStringList(
      _keyTransacciones,
    );

    if (transaccionesString == null) {
      return [];
    }

    return transaccionesString
        .map((transaccionString) => Transaccion.fromJson(transaccionString))
        .toList();
  }

  // Agregar una nueva transacción
  static Future<void> agregarTransaccion(Transaccion nuevaTransaccion) async {
    final transacciones = await obtenerTransacciones();
    transacciones.add(nuevaTransaccion);
    await guardarTransacciones(transacciones);
  }

  // Eliminar una transacción por ID
  static Future<void> eliminarTransaccion(String id) async {
    final transacciones = await obtenerTransacciones();
    transacciones.removeWhere((transaccion) => transaccion.id == id);
    await guardarTransacciones(transacciones);
  }

  // Obtener el balance total (ingresos - gastos)
  static Future<double> obtenerBalance() async {
    final transacciones = await obtenerTransacciones();

    double totalIngresos = 0;
    double totalGastos = 0;

    for (var transaccion in transacciones) {
      if (transaccion.tipo == TipoTransaccion.ingreso) {
        totalIngresos += transaccion.monto;
      } else {
        totalGastos += transaccion.monto;
      }
    }

    return totalIngresos - totalGastos;
  }

  // Obtener el total de ingresos
  static Future<double> obtenerTotalIngresos() async {
    final transacciones = await obtenerTransacciones();

    double totalIngresos = 0;

    for (var transaccion in transacciones) {
      if (transaccion.tipo == TipoTransaccion.ingreso) {
        totalIngresos += transaccion.monto;
      }
    }

    return totalIngresos;
  }

  // Obtener el total de gastos
  static Future<double> obtenerTotalGastos() async {
    final transacciones = await obtenerTransacciones();

    double totalGastos = 0;

    for (var transaccion in transacciones) {
      if (transaccion.tipo == TipoTransaccion.gasto) {
        totalGastos += transaccion.monto;
      }
    }

    return totalGastos;
  }

  // Obtener transacciones agrupadas por categoría
  static Future<Map<String, double>> obtenerTransaccionesPorCategoria(
    TipoTransaccion tipo,
  ) async {
    final transacciones = await obtenerTransacciones();
    final Map<String, double> categorias = {};

    for (var transaccion in transacciones) {
      if (transaccion.tipo == tipo) {
        if (categorias.containsKey(transaccion.categoria)) {
          categorias[transaccion.categoria] =
              categorias[transaccion.categoria]! + transaccion.monto;
        } else {
          categorias[transaccion.categoria] = transaccion.monto;
        }
      }
    }

    return categorias;
  }
}
