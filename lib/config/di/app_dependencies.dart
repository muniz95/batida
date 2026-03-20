import 'package:batida/config/environment/app_environment.dart';
import 'package:batida/core/common/now_provider.dart';
import 'package:batida/core/routing/app_router.dart';
import 'package:batida/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:batida/features/appointment/domain/usecases/get_appointments_for_day.dart';
import 'package:batida/features/appointment/domain/usecases/register_work_appointment.dart';
import 'package:batida/features/appointment/infrastructure/repositories/shared_preferences_appointment_repository.dart';

class AppDependencies {
  AppDependencies._({
    required this.environment,
    required this.now,
    required AppointmentRepository appointmentRepository,
  }) : _appointmentRepository = appointmentRepository;

  factory AppDependencies.bootstrap({
    required AppEnvironment environment,
    NowProvider now = _defaultNow,
    AppointmentRepository? appointmentRepository,
  }) {
    return AppDependencies._(
      environment: environment,
      now: now,
      appointmentRepository:
          appointmentRepository ?? SharedPreferencesAppointmentRepository(),
    );
  }

  final AppEnvironment environment;
  final NowProvider now;
  final AppointmentRepository _appointmentRepository;

  late final RegisterWorkAppointment registerWorkAppointment =
      RegisterWorkAppointment(_appointmentRepository);
  late final GetAppointmentsForDay getAppointmentsForDay =
      GetAppointmentsForDay(_appointmentRepository);
  late final AppRouter router = AppRouter(dependencies: this);

  static DateTime _defaultNow() => DateTime.now();
}
