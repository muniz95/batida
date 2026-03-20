import 'package:batida/config/di/app_dependencies.dart';
import 'package:batida/config/environment/app_environment.dart';
import 'package:batida/core/presentation/app_theme.dart';
import 'package:batida/core/routing/app_router.dart';
import 'package:batida/core/routing/app_routes.dart';
import 'package:flutter/material.dart';

class BatidaApp extends StatelessWidget {
  const BatidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: getIt<AppEnvironment>().appName,
      theme: AppTheme.build(),
      initialRoute: AppRoutes.appointments,
      onGenerateRoute: getIt<AppRouter>().onGenerateRoute,
    );
  }
}
