import 'package:flutter/material.dart';
import '../models/lote_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../widgets/lote_card.dart';
import 'add_lote_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();

  List<LoteAgricola> _lotes = [];
  double _tasaUsdCop = 4000.0; // Valor de respaldo si aún no hay red
  bool _cargandoApi = false;
  String? _errorApi;

  @override
  void initState() {
    super.initState();
    _inicializarDatos();
  }

  Future<void> _inicializarDatos() async {
    final lotesGuardados = await _storageService.cargarLotes();
    setState(() {
      _lotes = lotesGuardados;
    });
    await _consultarTasaActual();
  }

  Future<void> _consultarTasaActual() async {
    setState(() {
      _cargandoApi = true;
      _errorApi = null;
    });

    try {
      final tasa = await _apiService.obtenerTasaUsdCop();
      setState(() {
        _tasaUsdCop = tasa;
        _cargandoApi = false;
      });
    } catch (e) {
      setState(() {
        _errorApi = e.toString().replaceFirst('Exception: ', '');
        _cargandoApi = false;
      });
    }
  }

  double get _totalInventarioCop =>
      _lotes.fold(0, (suma, item) => suma + item.totalCop);

  double get _totalInventarioUsd =>
      _lotes.fold(0, (suma, item) => suma + item.totalUsd);

  Future<void> _irAAgregarLote() async {
    final nuevoLote = await Navigator.push<LoteAgricola>(
      context,
      MaterialPageRoute(
        builder: (context) => AddLoteScreen(tasaActualUsd: _tasaUsdCop),
      ),
    );

    if (nuevoLote != null) {
      setState(() {
        _lotes.insert(0, nuevoLote);
      });
      await _storageService.guardarLotes(_lotes);
    }
  }

  Future<void> _irADetalle(int index) async {
    final eliminar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(lote: _lotes[index]),
      ),
    );

    if (eliminar == true) {
      setState(() {
        _lotes.removeAt(index);
      });
      await _storageService.guardarLotes(_lotes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgroRegistro'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Actualizar tasa USD',
            icon: const Icon(Icons.refresh),
            onPressed: _cargandoApi ? null : _consultarTasaActual,
          ),
        ],
      ),
      body: Column(
        children: [
          // Tarjeta de resumen y estado de la API
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Valor Total Registrado',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${_totalInventarioCop.toStringAsFixed(0)} COP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Equivalente: US\$ ${_totalInventarioUsd.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Divider(color: Colors.white24, height: 20),
                if (_cargandoApi)
                  const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Consultando TRM en vivo...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                else if (_errorApi != null)
                  Row(
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.amber, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$_errorApi (Usando tasa: \$${_tasaUsdCop.toStringAsFixed(0)})',
                          style: const TextStyle(color: Colors.amber, fontSize: 12),
                        ),
                      ),
                      TextButton(
                        onPressed: _consultarTasaActual,
                        child: const Text(
                          'Reintentar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'TRM actual (API): 1 USD = \$${_tasaUsdCop.toStringAsFixed(2)} COP',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
              ],
            ),
          ),

          // Lista de lotes registrados
          Expanded(
            child: _lotes.isEmpty
                ? const Center(
                    child: Text(
                      'No hay lotes registrados.\nPresiona + para agregar tu primer lote.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _lotes.length,
                    itemBuilder: (context, index) {
                      return LoteCard(
                        lote: _lotes[index],
                        onTap: () => _irADetalle(index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        onPressed: _irAAgregarLote,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Lote'),
      ),
    );
  }
}
