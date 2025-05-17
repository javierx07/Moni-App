import 'package:flutter/material.dart';
import '../constantes.dart';

class TarjetaCategoria extends StatelessWidget {
  final String categoria;
  final String descripcion;
  final double monto;
  final String fecha;
  final bool esIngreso;
  final VoidCallback onBorrar;

  const TarjetaCategoria({
    Key? key,
    required this.categoria,
    required this.descripcion,
    required this.monto,
    required this.fecha,
    required this.esIngreso,
    required this.onBorrar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: ColoresMoni.fondoSecundario,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoria,
                    style: EstilosMoni.subtitulo,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: EstilosMoni.textoNormal,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fecha,
                    style: TextStyle(
                      color: ColoresMoni.grisClaro,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${monto.toStringAsFixed(2)}',
                  style: esIngreso ? EstilosMoni.montoPositivo : EstilosMoni.montoNegativo,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onBorrar,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColoresMoni.rosa,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Borrar',
                      style: TextStyle(
                        color: ColoresMoni.blanco,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
