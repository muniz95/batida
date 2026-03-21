import 'package:batida/features/appointment/domain/entities/work_appointment.dart';

abstract class WorkedTimeFormatter {
  const WorkedTimeFormatter();

  String format(int workedTimeInMinutes);
}

class HoursAndMinutesWorkedTimeFormatter implements WorkedTimeFormatter {
  const HoursAndMinutesWorkedTimeFormatter();

  @override
  String format(int workedTimeInMinutes) {
    final duration = Duration(minutes: workedTimeInMinutes);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes =
        (duration.inMinutes % Duration.minutesPerHour).toString().padLeft(2, '0');

    return '$hours:$minutes';
  }
}

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

  static String calculateWorkedTimeText(
    List<WorkAppointment> appointments, {
    WorkedTimeFormatter formatter = const HoursAndMinutesWorkedTimeFormatter(),
  }) {
    final workedTimeInMinutes = calculateWorkedTime(appointments);

    return formatter.format(workedTimeInMinutes);
  }
}
