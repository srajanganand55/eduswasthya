import 'package:flutter_test/flutter_test.dart';

import 'package:eduswasthya/main.dart';

void main() {
  testWidgets('app smoke test renders root widget', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EduSwasthyaApp());

    expect(find.text('EduSwasthya'), findsOneWidget);
    expect(find.text('Learn Health. Live Better.'), findsOneWidget);
  });
}
