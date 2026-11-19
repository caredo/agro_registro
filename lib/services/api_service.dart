import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // API pública gratuita que no requiere API Key
  static const String _url = 'https://er-api.com';

  // Retorna el valor de 1 USD en pesos colombianos (COP)
  Future<double> obtenerTasaUsdCop() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        final rates = data['rates'] as Map<String, dynamic>;
        final num tasaCop = rates['COP'] as num;
        return tasaCop.toDouble();
      } else {
        throw Exception('Error del servidor (Código ${response.statusCode})');
      }
    } on SocketException {
      throw Exception('Sin conexión a internet. Verifica tu red.');
    } on TimeoutException {
      throw Exception('La consulta tardó demasiado. Intenta nuevamente.');
    } catch (e) {
      throw Exception('No se pudo obtener la tasa de cambio.');
    }
  }
}
