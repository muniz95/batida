import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/domain/usecases/get_appointments_for_day.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes/fake_appointment_repository.dart';

void main() {
  test(
    'returns only appointments from the requested day sorted by time',
    () async {
      final repository = FakeAppointmentRepository(
        initialAppointments: [
          WorkAppointment(
            id: 'morning',
            registeredAt: DateTime(2026, 3, 20, 9, 0),
          ),
          WorkAppointment(
            id: 'afternoon',
            registeredAt: DateTime(2026, 3, 20, 18, 0),
          ),
          WorkAppointment(
            id: 'other-day',
            registeredAt: DateTime(2026, 3, 19, 10, 0),
          ),
        ],
      );
      final useCase = GetAppointmentsForDay(repository);

      final appointments = await useCase(DateTime(2026, 3, 20));

      expect(appointments, hasLength(2));
      expect(appointments.first.id, 'afternoon');
      expect(appointments.last.id, 'morning');
    },
  );
}
