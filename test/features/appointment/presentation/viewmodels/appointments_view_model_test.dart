import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/domain/usecases/get_appointments_for_day.dart';
import 'package:batida/features/appointment/domain/usecases/register_work_appointment.dart';
import 'package:batida/features/appointment/presentation/viewmodels/appointments_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes/fake_appointment_repository.dart';

void main() {
  test('loads appointments for the current day on initialize', () async {
    final repository = FakeAppointmentRepository(
      initialAppointments: [
        WorkAppointment(
          id: 'today',
          registeredAt: DateTime(2026, 3, 20, 9, 30),
        ),
        WorkAppointment(
          id: 'yesterday',
          registeredAt: DateTime(2026, 3, 19, 18, 0),
        ),
      ],
    );
    final viewModel = AppointmentsViewModel(
      registerWorkAppointment: RegisterWorkAppointment(repository),
      getAppointmentsForDay: GetAppointmentsForDay(repository),
      now: () => DateTime(2026, 3, 20, 10, 0),
    );

    await viewModel.initialize();

    expect(viewModel.appointmentsCount, 1);
    expect(viewModel.todaysAppointments.single.id, 'today');
  });

  test(
    'registerAppointment persists and refreshes the current day list',
    () async {
      final repository = FakeAppointmentRepository();
      final viewModel = AppointmentsViewModel(
        registerWorkAppointment: RegisterWorkAppointment(repository),
        getAppointmentsForDay: GetAppointmentsForDay(repository),
        now: () => DateTime(2026, 3, 20, 10, 0),
      );

      await viewModel.initialize();
      await viewModel.registerAppointment(hour: 14, minute: 45);

      expect(viewModel.appointmentsCount, 1);
      expect(viewModel.todaysAppointments.single.registeredAt.hour, 14);
      expect(viewModel.todaysAppointments.single.registeredAt.minute, 45);
    },
  );
}
