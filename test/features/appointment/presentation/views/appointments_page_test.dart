import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/presentation/views/appointments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/app_test_harness.dart';
import '../../../../support/fakes/fake_appointment_repository.dart';

void main() {
  testWidgets(
    'navigates between days and refreshes the list and total worked time',
    (WidgetTester tester) async {
    final fixedNow = DateTime(2026, 3, 20, 9, 30);
    final repository = FakeAppointmentRepository(
      initialAppointments: [
        WorkAppointment(
          id: 'today-start',
          registeredAt: DateTime(2026, 3, 20, 9, 30),
        ),
        WorkAppointment(
          id: 'today-end',
          registeredAt: DateTime(2026, 3, 20, 10, 30),
        ),
        WorkAppointment(
          id: 'yesterday-start',
          registeredAt: DateTime(2026, 3, 19, 8, 0),
        ),
        WorkAppointment(
          id: 'yesterday-end',
          registeredAt: DateTime(2026, 3, 19, 10, 7),
        ),
      ],
    );

    await tester.pumpWidget(
      await buildTestApp(now: () => fixedNow, appointmentRepository: repository),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(_formatDate(tester, DateTime(2026, 3, 20))),
      findsAtLeastNWidgets(2),
    );
    expect(find.text('Total worked time: 01:00'), findsOneWidget);
    expect(find.text('09:30'), findsOneWidget);
    expect(find.text('10:30'), findsOneWidget);
    expect(_nextDayButton(tester).onPressed, isNull);

    await tester.tap(find.byKey(const Key('previous-day-button')));
    await tester.pumpAndSettle();

    expect(
      find.text(_formatDate(tester, DateTime(2026, 3, 19))),
      findsAtLeastNWidgets(2),
    );
    expect(find.text('Total worked time: 02:07'), findsOneWidget);
    expect(find.text('08:00'), findsOneWidget);
    expect(find.text('10:07'), findsOneWidget);
    expect(find.text('09:30'), findsNothing);
    expect(_nextDayButton(tester).onPressed, isNotNull);

    await tester.tap(find.byKey(const Key('next-day-button')));
    await tester.pumpAndSettle();

    expect(
      find.text(_formatDate(tester, DateTime(2026, 3, 20))),
      findsAtLeastNWidgets(2),
    );
    expect(find.text('Total worked time: 01:00'), findsOneWidget);
    expect(find.text('09:30'), findsOneWidget);
    expect(find.text('10:30'), findsOneWidget);
    expect(_nextDayButton(tester).onPressed, isNull);
    },
  );

  testWidgets(
    'shows the empty state when navigating to a day without appointments',
    (WidgetTester tester) async {
    final fixedNow = DateTime(2026, 3, 20, 9, 30);
    final repository = FakeAppointmentRepository(
      initialAppointments: [
        WorkAppointment(
          id: 'today-start',
          registeredAt: DateTime(2026, 3, 20, 9, 30),
        ),
        WorkAppointment(
          id: 'today-end',
          registeredAt: DateTime(2026, 3, 20, 10, 30),
        ),
      ],
    );

    await tester.pumpWidget(
      await buildTestApp(now: () => fixedNow, appointmentRepository: repository),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('previous-day-button')));
    await tester.pumpAndSettle();

    expect(
      find.text(_formatDate(tester, DateTime(2026, 3, 19))),
      findsAtLeastNWidgets(2),
    );
    expect(
      find.text('No appointments registered for this day yet.'),
      findsOneWidget,
    );
    expect(find.text('Total worked time: 00:00'), findsOneWidget);
    expect(_nextDayButton(tester).onPressed, isNotNull);
    },
  );
}

String _formatDate(WidgetTester tester, DateTime day) {
  final context = tester.element(find.byType(AppointmentsPage));
  return MaterialLocalizations.of(context).formatMediumDate(day);
}

IconButton _nextDayButton(WidgetTester tester) {
  return tester.widget<IconButton>(find.byKey(const Key('next-day-button')));
}
