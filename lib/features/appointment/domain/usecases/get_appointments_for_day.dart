import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/domain/repositories/appointment_repository.dart';

class GetAppointmentsForDay {
  const GetAppointmentsForDay(this._appointmentRepository);

  final AppointmentRepository _appointmentRepository;

  Future<List<WorkAppointment>> call(DateTime day) {
    return _appointmentRepository.getAppointmentsForDay(day);
  }
}
