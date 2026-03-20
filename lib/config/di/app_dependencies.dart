import 'package:batida/config/environment/app_environment.dart';
import 'package:batida/core/common/now_provider.dart';
import 'package:batida/core/routing/app_router.dart';
import 'package:batida/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:batida/features/appointment/domain/usecases/get_appointments_for_day.dart';
import 'package:batida/features/appointment/domain/usecases/register_work_appointment.dart';
import 'package:batida/features/appointment/infrastructure/repositories/shared_preferences_appointment_repository.dart';
import 'package:batida/features/appointment/presentation/viewmodels/appointments_view_model.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies({
  required AppEnvironment environment,
  NowProvider now = _defaultNow,
  AppointmentRepository? appointmentRepository,
}) async {
  await getIt.reset();

  getIt.registerSingleton<AppEnvironment>(environment);
  getIt.registerLazySingleton<NowProvider>(() => now);
  getIt.registerLazySingleton<AppointmentRepository>(
    () => appointmentRepository ?? SharedPreferencesAppointmentRepository(),
  );
  getIt.registerLazySingleton<RegisterWorkAppointment>(
    () => RegisterWorkAppointment(getIt<AppointmentRepository>()),
  );
  getIt.registerLazySingleton<GetAppointmentsForDay>(
    () => GetAppointmentsForDay(getIt<AppointmentRepository>()),
  );
  getIt.registerFactory<AppointmentsViewModel>(
    () => AppointmentsViewModel(
      registerWorkAppointment: getIt<RegisterWorkAppointment>(),
      getAppointmentsForDay: getIt<GetAppointmentsForDay>(),
      now: getIt<NowProvider>(),
    ),
  );
  getIt.registerLazySingleton<AppRouter>(() => const AppRouter());
}

Future<void> resetDependencies() {
  return getIt.reset();
}

DateTime _defaultNow() => DateTime.now();
