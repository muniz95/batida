import 'package:batida/core/routing/app_routes.dart';
import 'package:batida/features/appointment/presentation/views/appointments_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  const AppRouter();

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? AppRoutes.appointments;

    switch (routeName) {
      case AppRoutes.appointments:
        return MaterialPageRoute<void>(
          builder: (_) => const AppointmentsPage(),
          settings: const RouteSettings(name: AppRoutes.appointments),
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const AppointmentsPage(),
          settings: const RouteSettings(name: AppRoutes.appointments),
        );
    }
  }
}
