import 'package:flutter/material.dart';
import '../models/lote_model.dart';

class LoteCard extends StatelessWidget {
  final LoteAgricola lote;
  final VoidCallback onTap;

  const LoteCard({
    super.key,
    required this.lote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(Icons.agriculture, color: Colors.green.shade800),
        ),
        title: Text(
          lote.producto,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          '${lote.cantidadKg.toStringAsFixed(1)} kg  •  ${lote.fechaRegistro}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${lote.totalCop.toStringAsFixed(0)} COP',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 14,
              ),
            ),
            Text(
              'US\$ ${lote.totalUsd.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
