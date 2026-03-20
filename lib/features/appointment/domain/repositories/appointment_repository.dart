import 'package:batida/features/appointment/domain/entities/work_appointment.dart';

abstract interface class AppointmentRepository {
  Future<List<WorkAppointment>> getAppointmentsForDay(DateTime day);

  Future<void> saveAppointment(WorkAppointment appointment);
}
