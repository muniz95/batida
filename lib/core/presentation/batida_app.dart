import 'package:batida/config/di/app_dependencies.dart';
import 'package:batida/core/presentation/app_theme.dart';
import 'package:batida/core/routing/app_routes.dart';
import 'package:flutter/material.dart';

class BatidaApp extends StatelessWidget {
  const BatidaApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: dependencies.environment.appName,
      theme: AppTheme.build(),
      initialRoute: AppRoutes.appointments,
      onGenerateRoute: dependencies.router.onGenerateRoute,
    );
  }
}
