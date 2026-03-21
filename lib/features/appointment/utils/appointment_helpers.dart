import 'package:batida/features/appointment/domain/entities/work_appointment.dart';

class AppointmentHelpers {
  static int calculateWorkedTime(List<WorkAppointment> appointments) {
    var totalWorkedTimeInMinutes = 0;

    for (var index = 0; index + 1 < appointments.length; index += 2) {
      final startingTime = appointments[index];
      final endingTime = appointments[index + 1];

      totalWorkedTimeInMinutes += endingTime.registeredAt
          .difference(startingTime.registeredAt)
          .inMinutes;
    }

    return totalWorkedTimeInMinutes;
  }
}
