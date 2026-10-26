import 'package:flutter_test/flutter_test.dart';

import 'package:rick_morty/main.dart';

void main() {
  testWidgets('La app muestra el título del catálogo',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MiApp());

    expect(find.text('Rick & Morty'), findsOneWidget);
  });
}