import 'package:batida/config/di/app_dependencies.dart';
import 'package:batida/config/environment/app_environment.dart';
import 'package:batida/core/common/now_provider.dart';
import 'package:batida/core/presentation/batida_app.dart';
import 'package:batida/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:batida/features/appointment/infrastructure/repositories/in_memory_appointment_repository.dart';

Future<BatidaApp> buildTestApp({
  required NowProvider now,
  AppointmentRepository? appointmentRepository,
}) async {
  await configureDependencies(
    environment: const AppEnvironment(appName: 'Batida'),
    now: now,
    appointmentRepository:
        appointmentRepository ?? InMemoryAppointmentRepository(),
  );

  return const BatidaApp();
}
