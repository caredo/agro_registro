import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/lote_model.dart';

class StorageService {
  static const String _fileName = 'lotes_agricolas.json';

  // Obtiene la ruta segura del archivo en el almacenamiento local del dispositivo
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // Guarda toda la lista de lotes convirtiéndola a texto JSON
  Future<void> guardarLotes(List<LoteAgricola> lotes) async {
    final file = await _getLocalFile();
    final List<Map<String, dynamic>> jsonList =
        lotes.map((lote) => lote.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  // Lee el archivo JSON del dispositivo y reconstruye la lista de objetos
  Future<List<LoteAgricola>> cargarLotes() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) {
        return []; // Si es la primera vez que abre la app, devuelve lista vacía
      }
      final String contenido = await file.readAsString();
      if (contenido.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(contenido) as List<dynamic>;
      return jsonList
          .map((item) => LoteAgricola.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Si el archivo estuviera dañado, evitamos que la app se cierre
      return [];
    }
  }
}
