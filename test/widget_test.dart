import 'package:flutter_test/flutter_test.dart';

import 'package:aybook/main.dart';

void main() {
  testWidgets('AyBook app renders splash title', (WidgetTester tester) async {
    await tester.pumpWidget(const AyBookApp());

    expect(find.text('AyBook'), findsOneWidget);
  });
}
