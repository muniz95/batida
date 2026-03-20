import 'package:batida/config/di/app_dependencies.dart';
import 'package:batida/config/environment/app_environment.dart';
import 'package:batida/core/presentation/batida_app.dart';
import 'package:flutter/widgets.dart';

void main() {
  final dependencies = AppDependencies.bootstrap(
    environment: const AppEnvironment(appName: 'Batida'),
  );

  runApp(BatidaApp(dependencies: dependencies));
}
