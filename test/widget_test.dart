import 'package:flutter_test/flutter_test.dart';
import 'package:agro_registro/main.dart';

void main() {
  testWidgets('Carga pantalla principal de AgroRegistro', (WidgetTester tester) async {
    await tester.pumpWidget(const AgroRegistroApp());
    expect(find.text('AgroRegistro'), findsOneWidget);
  });
}
