import 'dart:collection';

import 'package:batida/core/common/now_provider.dart';
import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/domain/usecases/get_appointments_for_day.dart';
import 'package:batida/features/appointment/domain/usecases/register_work_appointment.dart';
import 'package:flutter/foundation.dart';

class AppointmentsViewModel extends ChangeNotifier {
  AppointmentsViewModel({
    required RegisterWorkAppointment registerWorkAppointment,
    required GetAppointmentsForDay getAppointmentsForDay,
    required NowProvider now,
  }) : _registerWorkAppointment = registerWorkAppointment,
       _getAppointmentsForDay = getAppointmentsForDay,
       _now = now;

  final RegisterWorkAppointment _registerWorkAppointment;
  final GetAppointmentsForDay _getAppointmentsForDay;
  final NowProvider _now;

  List<WorkAppointment> _appointments = const [];

  UnmodifiableListView<WorkAppointment> get todaysAppointments =>
      UnmodifiableListView(_appointments);
  DateTime get currentDay => _now();
  int get appointmentsCount => _appointments.length;

  Future<void> initialize() async {
    await _reloadAppointments();
  }

  Future<void> registerAppointment({
    required int hour,
    required int minute,
  }) async {
    final appointment = WorkAppointment.createForDay(
      day: _now(),
      hour: hour,
      minute: minute,
    );

    await _registerWorkAppointment(appointment);
    await _reloadAppointments();
  }

  Future<void> _reloadAppointments() async {
    _appointments = await _getAppointmentsForDay(_now());
    notifyListeners();
  }
}
