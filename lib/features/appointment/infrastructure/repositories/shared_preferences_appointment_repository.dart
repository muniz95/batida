import 'dart:convert';

import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:batida/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesAppointmentRepository implements AppointmentRepository {
  SharedPreferencesAppointmentRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _storageKey = 'appointment.registers';

  final SharedPreferencesAsync _preferences;

  @override
  Future<List<WorkAppointment>> getAppointmentsForDay(DateTime day) async {
    final storedAppointments =
        await _preferences.getStringList(_storageKey) ?? const <String>[];

    final appointments =
        storedAppointments
            .map(_deserializeAppointment)
            .whereType<WorkAppointment>()
            .where((appointment) => _isSameDay(appointment.registeredAt, day))
            .toList()
          ..sort(
            (left, right) => left.registeredAt.compareTo(right.registeredAt),
          );

    return appointments;
  }

  @override
  Future<void> saveAppointment(WorkAppointment appointment) async {
    final storedAppointments =
        await _preferences.getStringList(_storageKey) ?? const <String>[];

    await _preferences.setStringList(_storageKey, <String>[
      ...storedAppointments,
      _serializeAppointment(appointment),
    ]);
  }

  String _serializeAppointment(WorkAppointment appointment) {
    return jsonEncode({
      'id': appointment.id,
      'registeredAt': appointment.registeredAt.toIso8601String(),
    });
  }

  WorkAppointment? _deserializeAppointment(String rawAppointment) {
    try {
      final decodedAppointment = jsonDecode(rawAppointment);
      if (decodedAppointment is! Map) {
        return null;
      }

      final id = decodedAppointment['id'];
      final registeredAtValue = decodedAppointment['registeredAt'];
      if (id is! String || registeredAtValue is! String) {
        return null;
      }

      final registeredAt = DateTime.tryParse(registeredAtValue);
      if (registeredAt == null) {
        return null;
      }

      return WorkAppointment(id: id, registeredAt: registeredAt);
    } catch (_) {
      return null;
    }
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}
