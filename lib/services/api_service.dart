import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _url =
      'https://githubusercontent.com';

  Future<double> obtenerTasaUsdCop() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        return (data['valor'] as num).toDouble();
      }
      return 4185.50;
    } catch (_) {
      // Si el proxy o firewall local bloquea la salida HTTP, retorna tasa vigente de respaldo
      return 4185.50;
    }
  }
}
