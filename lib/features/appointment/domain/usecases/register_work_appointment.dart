import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/domain/repositories/appointment_repository.dart';

class RegisterWorkAppointment {
  const RegisterWorkAppointment(this._appointmentRepository);

  final AppointmentRepository _appointmentRepository;

  Future<void> call(WorkAppointment appointment) {
    return _appointmentRepository.saveAppointment(appointment);
  }
}
