import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/utils/appointment_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWorkedTimeFormatter implements WorkedTimeFormatter {
  const FakeWorkedTimeFormatter();

  @override
  String format(int workedTimeInMinutes) => 'minutes=$workedTimeInMinutes';
}

void main() {
  test('calculates the total worked time in minutes between two records', () {
    final startingTime = WorkAppointment.createForDay(day: DateTime.now(), hour: 1, minute: 0);
    final endingTime = WorkAppointment.createForDay(day: DateTime.now(), hour: 2, minute: 0);

    final workedTime = AppointmentHelpers.calculateWorkedTime([startingTime, endingTime]);

    expect(workedTime, 60);
  });

  test('sums the worked time of each consecutive pair of records', () {
    final appointments = [
      WorkAppointment.createForDay(day: DateTime.now(), hour: 8, minute: 0),
      WorkAppointment.createForDay(day: DateTime.now(), hour: 12, minute: 0),
      WorkAppointment.createForDay(day: DateTime.now(), hour: 13, minute: 0),
      WorkAppointment.createForDay(day: DateTime.now(), hour: 18, minute: 30),
    ];

    final workedTime = AppointmentHelpers.calculateWorkedTime(appointments);

    expect(workedTime, 570);
  });

  test('ignores the last record when the list has an odd number of items', () {
    final appointments = [
      WorkAppointment.createForDay(day: DateTime.now(), hour: 8, minute: 0),
      WorkAppointment.createForDay(day: DateTime.now(), hour: 12, minute: 0),
      WorkAppointment.createForDay(day: DateTime.now(), hour: 13, minute: 0),
    ];

    final workedTime = AppointmentHelpers.calculateWorkedTime(appointments);

    expect(workedTime, 240);
  });

  test('formats the total worked time as hours and minutes', () {
    final appointments = [
      WorkAppointment.createForDay(day: DateTime.now(), hour: 8, minute: 0),
      WorkAppointment.createForDay(day: DateTime.now(), hour: 10, minute: 7),
    ];

    final workedTime = AppointmentHelpers.calculateWorkedTimeText(appointments);

    expect(workedTime, '02:07');
  });

  test('allows extending the worked time text formatting', () {
    final appointments = [
      WorkAppointment.createForDay(day: DateTime.now(), hour: 8, minute: 0),
      WorkAppointment.createForDay(day: DateTime.now(), hour: 10, minute: 7),
    ];

    final workedTime = AppointmentHelpers.calculateWorkedTimeText(
      appointments,
      formatter: const FakeWorkedTimeFormatter(),
    );

    expect(workedTime, 'minutes=127');
  });
}
