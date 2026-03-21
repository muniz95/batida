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
  }) : this._(
         registerWorkAppointment: registerWorkAppointment,
         getAppointmentsForDay: getAppointmentsForDay,
         now: now,
         today: _normalizeDay(now()),
       );

  AppointmentsViewModel._({
    required RegisterWorkAppointment registerWorkAppointment,
    required GetAppointmentsForDay getAppointmentsForDay,
    required NowProvider now,
    required DateTime today,
  }) : _registerWorkAppointment = registerWorkAppointment,
       _getAppointmentsForDay = getAppointmentsForDay,
       _now = now,
       _today = today,
       _selectedDay = today;

  final RegisterWorkAppointment _registerWorkAppointment;
  final GetAppointmentsForDay _getAppointmentsForDay;
  final NowProvider _now;
  final DateTime _today;

  List<WorkAppointment> _appointments = const [];
  DateTime _selectedDay;

  UnmodifiableListView<WorkAppointment> get appointments =>
      UnmodifiableListView(_appointments);
  DateTime get selectedDay => _selectedDay;
  DateTime get initialAppointmentDateTime =>
      _combineDayAndTime(_selectedDay, _now());
  bool get canGoToNextDay => _selectedDay.isBefore(_today);
  int get appointmentsCount => _appointments.length;

  Future<void> initialize() async {
    await _reloadAppointments();
  }

  Future<void> registerAppointment({
    required int hour,
    required int minute,
  }) async {
    final appointment = WorkAppointment.createForDay(
      day: _selectedDay,
      hour: hour,
      minute: minute,
    );

    await _registerWorkAppointment(appointment);
    await _reloadAppointments();
  }

  Future<void> goToPreviousDay() async {
    _selectedDay = _selectedDay.subtract(const Duration(days: 1));
    await _reloadAppointments();
  }

  Future<void> goToNextDay() async {
    if (!canGoToNextDay) {
      return;
    }

    _selectedDay = _selectedDay.add(const Duration(days: 1));
    await _reloadAppointments();
  }

  Future<void> _reloadAppointments() async {
    _appointments = await _getAppointmentsForDay(_selectedDay);
    notifyListeners();
  }

  static DateTime _normalizeDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime _combineDayAndTime(DateTime day, DateTime timeSource) {
    return DateTime(
      day.year,
      day.month,
      day.day,
      timeSource.hour,
      timeSource.minute,
    );
  }
}
