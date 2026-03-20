import 'dart:collection';

import 'package:batida/features/appointment/domain/entities/work_appointment.dart';
import 'package:flutter/material.dart';

class AppointmentsList extends StatelessWidget {
  const AppointmentsList({super.key, required this.appointments});

  final UnmodifiableListView<WorkAppointment> appointments;

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            'No appointments registered for today yet.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: appointments.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final appointment = appointments[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.access_time),
            ),
            title: Text(_formatTime(context, appointment.registeredAt)),
            subtitle: Text(
              'Registered for ${MaterialLocalizations.of(context).formatMediumDate(appointment.registeredAt)}',
            ),
          ),
        );
      },
    );
  }

  String _formatTime(BuildContext context, DateTime date) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(date),
      alwaysUse24HourFormat: true,
    );
  }
}
