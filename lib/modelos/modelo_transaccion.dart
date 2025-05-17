import 'dart:convert';

enum TipoTransaccion { gasto, ingreso }

class Transaccion {
  final String id;
  final String descripcion;
  final String categoria;
  final double monto;
  final DateTime fecha;
  final TipoTransaccion tipo;

  Transaccion({
    required this.id,
    required this.descripcion,
    required this.categoria,
    required this.monto,
    required this.fecha,
    required this.tipo,
  });

  // Convertir un objeto Transaccion a un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'categoria': categoria,
      'monto': monto,
      'fecha': fecha.millisecondsSinceEpoch,
      'tipo': tipo.toString(),
    };
  }

  // Crear un objeto Transaccion desde un Map
  factory Transaccion.fromMap(Map<String, dynamic> map) {
    return Transaccion(
      id: map['id'],
      descripcion: map['descripcion'],
      categoria: map['categoria'],
      monto: map['monto'],
      fecha: DateTime.fromMillisecondsSinceEpoch(map['fecha']),
      tipo: map['tipo'] == 'TipoTransaccion.gasto'
          ? TipoTransaccion.gasto
          : TipoTransaccion.ingreso,
    );
  }

  // Convertir a JSON
  String toJson() => json.encode(toMap());

  // Crear desde JSON
  factory Transaccion.fromJson(String source) =>
      Transaccion.fromMap(json.decode(source));
}
