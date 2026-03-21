import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/domain/usecases/get_appointments_for_day.dart';
import 'package:batida/features/appointment/domain/usecases/register_work_appointment.dart';
import 'package:batida/features/appointment/presentation/viewmodels/appointments_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes/fake_appointment_repository.dart';

void main() {
  test(
    'initializes with today as the selected day and loads its appointments',
    () async {
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
    final viewModel = _buildViewModel(
      repository: repository,
      now: () => DateTime(2026, 3, 20, 10, 0),
    );

    await viewModel.initialize();

    expect(viewModel.selectedDay, DateTime(2026, 3, 20));
    expect(viewModel.canGoToNextDay, isFalse);
    expect(viewModel.appointmentsCount, 1);
    expect(viewModel.appointments.single.id, 'today');
    },
  );

  test('goToPreviousDay reloads appointments for the previous date', () async {
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
    final viewModel = _buildViewModel(
      repository: repository,
      now: () => DateTime(2026, 3, 20, 10, 0),
    );

    await viewModel.initialize();
    await viewModel.goToPreviousDay();

    expect(viewModel.selectedDay, DateTime(2026, 3, 19));
    expect(viewModel.canGoToNextDay, isTrue);
    expect(viewModel.appointmentsCount, 1);
    expect(viewModel.appointments.single.id, 'yesterday');
  });

  test('goToNextDay reloads appointments until today', () async {
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
    final viewModel = _buildViewModel(
      repository: repository,
      now: () => DateTime(2026, 3, 20, 10, 0),
    );

    await viewModel.initialize();
    await viewModel.goToPreviousDay();
    await viewModel.goToNextDay();

    expect(viewModel.selectedDay, DateTime(2026, 3, 20));
    expect(viewModel.canGoToNextDay, isFalse);
    expect(viewModel.appointmentsCount, 1);
    expect(viewModel.appointments.single.id, 'today');
  });

  test(
    'goToNextDay does nothing when the selected day is already today',
    () async {
    final repository = FakeAppointmentRepository(
      initialAppointments: [
        WorkAppointment(
          id: 'today',
          registeredAt: DateTime(2026, 3, 20, 9, 30),
        ),
      ],
    );
    final viewModel = _buildViewModel(
      repository: repository,
      now: () => DateTime(2026, 3, 20, 10, 0),
    );

    await viewModel.initialize();
    await viewModel.goToNextDay();

    expect(viewModel.selectedDay, DateTime(2026, 3, 20));
    expect(viewModel.canGoToNextDay, isFalse);
    expect(viewModel.appointmentsCount, 1);
    expect(viewModel.appointments.single.id, 'today');
    },
  );

  test(
    'registerAppointment saves and reloads records for the selected day',
    () async {
    final repository = FakeAppointmentRepository();
    final viewModel = _buildViewModel(
      repository: repository,
      now: () => DateTime(2026, 3, 20, 10, 0),
    );

    await viewModel.initialize();
    await viewModel.goToPreviousDay();
    await viewModel.registerAppointment(hour: 14, minute: 45);

    expect(viewModel.selectedDay, DateTime(2026, 3, 19));
    expect(viewModel.appointmentsCount, 1);
    expect(
      viewModel.appointments.single.registeredAt,
      DateTime(2026, 3, 19, 14, 45),
    );
    },
  );
}

AppointmentsViewModel _buildViewModel({
  required FakeAppointmentRepository repository,
  required DateTime Function() now,
}) {
  return AppointmentsViewModel(
    registerWorkAppointment: RegisterWorkAppointment(repository),
    getAppointmentsForDay: GetAppointmentsForDay(repository),
    now: now,
  );
}
