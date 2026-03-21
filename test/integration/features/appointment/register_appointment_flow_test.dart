import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../../support/app_test_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('registers multiple appointments through the main flow', (
    WidgetTester tester,
  ) async {
    final fixedNow = DateTime(2026, 3, 20, 9, 30);

    await tester.pumpWidget(await buildTestApp(now: () => fixedNow));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add appointment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save appointment'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add appointment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save appointment'));
    await tester.pumpAndSettle();

    expect(find.text('No appointments registered for this day yet.'), findsNothing);
    expect(find.text('09:30'), findsNWidgets(2));
  });
}
