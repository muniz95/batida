import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/domain/usecases/register_work_appointment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes/fake_appointment_repository.dart';

void main() {
  test('stores the appointment in the repository', () async {
    final repository = FakeAppointmentRepository();
    final useCase = RegisterWorkAppointment(repository);
    final appointment = WorkAppointment(
      id: 'appointment-1',
      registeredAt: DateTime(2026, 3, 20, 9, 30),
    );

    await useCase(appointment);

    expect(repository.storedAppointments, [appointment]);
  });
}
