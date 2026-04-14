import 'package:animalpedia/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Animalpedia inicia y muestra el título principal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AnimalpediaApp());
    await tester.pumpAndSettle();

    expect(find.text('Animalpedia'), findsOneWidget);
    expect(find.text('Mamíferos destacados'), findsOneWidget);
  });
}
