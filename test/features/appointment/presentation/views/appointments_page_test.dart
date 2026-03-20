import 'package:flutter_test/flutter_test.dart';

import '../../../../support/app_test_harness.dart';

void main() {
  testWidgets('adds an appointment using the current time by default', (
    WidgetTester tester,
  ) async {
    final fixedNow = DateTime(2026, 3, 20, 9, 30);

    await tester.pumpWidget(await buildTestApp(now: () => fixedNow));
    await tester.pumpAndSettle();

    expect(find.text('No appointments registered for today yet.'), findsOne);
    expect(find.text('0 appointments registered'), findsOne);

    await tester.tap(find.text('Add appointment'));
    await tester.pumpAndSettle();

    expect(find.text('Register appointment'), findsOne);

    await tester.tap(find.text('Save appointment'));
    await tester.pumpAndSettle();

    expect(
      find.text('No appointments registered for today yet.'),
      findsNothing,
    );
    expect(find.text('1 appointment registered'), findsOne);
    expect(find.text('09:30'), findsOne);
  });
}
