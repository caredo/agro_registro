import 'package:flutter/material.dart';
import '../models/lote_model.dart';

class AddLoteScreen extends StatefulWidget {
  final double tasaActualUsd;

  const AddLoteScreen({super.key, required this.tasaActualUsd});

  @override
  State<AddLoteScreen> createState() => _AddLoteScreenState();
}

class _AddLoteScreenState extends State<AddLoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productoController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _precioController = TextEditingController();

  @override
  void dispose() {
    _productoController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _guardarFormulario() {
    if (_formKey.currentState!.validate()) {
      final ahora = DateTime.now();
      final fechaFormateada =
          '${ahora.day.toString().padLeft(2, '0')}/${ahora.month.toString().padLeft(2, '0')}/${ahora.year}';

      final nuevoLote = LoteAgricola(
        id: ahora.millisecondsSinceEpoch.toString(),
        producto: _productoController.text.trim(),
        cantidadKg: double.parse(_cantidadController.text.trim()),
        precioPorKgCop: double.parse(_precioController.text.trim()),
        tasaUsdAplicada: widget.tasaActualUsd,
        fechaRegistro: fechaFormateada,
      );

      // Retorna el nuevo objeto LoteAgricola a HomeScreen
      Navigator.pop(context, nuevoLote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nuevo Lote'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  'Tasa aplicada: 1 USD = \$${widget.tasaActualUsd.toStringAsFixed(2)} COP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _productoController,
                decoration: const InputDecoration(
                  labelText: 'Producto agrícola (ej. Café pergamino, Aguacate)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.grass),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el nombre del producto';
                  }
                  if (value.trim().length < 3) {
                    return 'Debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Cantidad en Kilogramos (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.scale),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa la cantidad en kg';
                  }
                  final numero = double.tryParse(value.trim());
                  if (numero == null || numero <= 0) {
                    return 'Ingresa un número válido mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio por kg (COP)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el precio por kilogramo';
                  }
                  final numero = double.tryParse(value.trim());
                  if (numero == null || numero <= 0) {
                    return 'Ingresa un precio válido mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                icon: const Icon(Icons.save),
                label: const Text(
                  'Guardar Lote',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _guardarFormulario,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
