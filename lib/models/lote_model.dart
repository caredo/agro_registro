class LoteAgricola {
  final String id;
  final String producto;
  final double cantidadKg;
  final double precioPorKgCop;
  final double tasaUsdAplicada;
  final String fechaRegistro;

  LoteAgricola({
    required this.id,
    required this.producto,
    required this.cantidadKg,
    required this.precioPorKgCop,
    required this.tasaUsdAplicada,
    required this.fechaRegistro,
  });

  // Cálculo útil: valor total del lote en pesos colombianos
  double get totalCop => cantidadKg * precioPorKgCop;

  // Cálculo útil: equivalencia en dólares usando la tasa de la API
  double get totalUsd => tasaUsdAplicada > 0 ? totalCop / tasaUsdAplicada : 0;

  // Convierte el objeto Dart a un Mapa (para guardarlo en el archivo JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto': producto,
      'cantidadKg': cantidadKg,
      'precioPorKgCop': precioPorKgCop,
      'tasaUsdAplicada': tasaUsdAplicada,
      'fechaRegistro': fechaRegistro,
    };
  }

  // Crea un objeto LoteAgricola desde un Mapa leído del archivo JSON
  factory LoteAgricola.fromJson(Map<String, dynamic> json) {
    return LoteAgricola(
      id: json['id'] as String,
      producto: json['producto'] as String,
      cantidadKg: (json['cantidadKg'] as num).toDouble(),
      precioPorKgCop: (json['precioPorKgCop'] as num).toDouble(),
      tasaUsdAplicada: (json['tasaUsdAplicada'] as num).toDouble(),
      fechaRegistro: json['fechaRegistro'] as String,
    );
  }
}
