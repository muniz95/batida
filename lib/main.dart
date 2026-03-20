import 'package:batida/config/di/app_dependencies.dart';
import 'package:batida/config/environment/app_environment.dart';
import 'package:batida/core/presentation/batida_app.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(
    environment: const AppEnvironment(appName: 'Batida'),
  );

  runApp(const BatidaApp());
}
