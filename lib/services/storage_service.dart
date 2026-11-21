import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lote_model.dart';

class StorageService {
  static const String _storageKey = 'lotes_agricolas_data';

  // Guarda toda la lista de lotes en almacenamiento local persistente
  Future<void> guardarLotes(List<LoteAgricola> lotes) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        lotes.map((lote) => lote.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);
    await prefs.setString(_storageKey, jsonString);
  }

  // Lee los datos guardados y reconstruye la lista de objetos
  Future<List<LoteAgricola>> cargarLotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? contenido = prefs.getString(_storageKey);
    if (contenido == null || contenido.trim().isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(contenido) as List<dynamic>;
    return jsonList
        .map((item) => LoteAgricola.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
