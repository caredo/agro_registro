import 'package:flutter/material.dart';
import '../models/lote_model.dart';

class DetailScreen extends StatelessWidget {
  final LoteAgricola lote;

  const DetailScreen({super.key, required this.lote});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Lote'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.eco, size: 32, color: Colors.green.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            lote.producto,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    _filaDetalle('Fecha de registro:', lote.fechaRegistro),
                    _filaDetalle('Cantidad:', '${lote.cantidadKg.toStringAsFixed(1)} kg'),
                    _filaDetalle('Precio por kg:', '\$${lote.precioPorKgCop.toStringAsFixed(0)} COP'),
                    _filaDetalle('TRM aplicada (1 USD):', '\$${lote.tasaUsdAplicada.toStringAsFixed(2)} COP'),
                    const Divider(height: 28),
                    _filaDetalle(
                      'Total en Pesos:',
                      '\$${lote.totalCop.toStringAsFixed(0)} COP',
                      destacado: true,
                    ),
                    _filaDetalle(
                      'Equivalente en Dólares:',
                      'US\$ ${lote.totalUsd.toStringAsFixed(2)}',
                      destacado: true,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar Lote'),
              onPressed: () {
                // Regresa 'true' indicando a HomeScreen que debe eliminar este lote
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _filaDetalle(String etiqueta, String valor, {bool destacado = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta, style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
          Text(
            valor,
            style: TextStyle(
              fontSize: destacado ? 17 : 15,
              fontWeight: destacado ? FontWeight.bold : FontWeight.w500,
              color: destacado ? Colors.green.shade800 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
