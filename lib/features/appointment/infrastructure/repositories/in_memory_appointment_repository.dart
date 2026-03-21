import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/domain/repositories/appointment_repository.dart';

class InMemoryAppointmentRepository implements AppointmentRepository {
  final List<WorkAppointment> _appointments = [];

  @override
  Future<List<WorkAppointment>> getAppointmentsForDay(DateTime day) async {
    final appointments =
        _appointments
            .where((appointment) => _isSameDay(appointment.registeredAt, day))
            .toList()
          ..sort(
            (left, right) => left.registeredAt.compareTo(right.registeredAt),
          );

    return appointments;
  }

  @override
  Future<void> saveAppointment(WorkAppointment appointment) async {
    _appointments.add(appointment);
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}
