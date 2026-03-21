import 'package:batida/config/di/app_dependencies.dart';
import 'package:batida/features/appointment/presentation/viewmodels/appointments_view_model.dart';
import 'package:batida/features/appointment/presentation/views/appointments_list.dart';
import 'package:batida/features/appointment/presentation/widgets/day_navigation_bar.dart';
import 'package:batida/features/appointment/presentation/widgets/register_appointment_sheet.dart';
import 'package:batida/features/appointment/utils/appointment_helpers.dart';
import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late final AppointmentsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<AppointmentsViewModel>();
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _openAddAppointmentModal() async {
    final selectedTime = await showModalBottomSheet<TimeOfDay>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          RegisterAppointmentSheet(
            initialDateTime: _viewModel.initialAppointmentDateTime,
          ),
    );

    if (selectedTime == null) {
      return;
    }

    await _viewModel.registerAppointment(
      hour: selectedTime.hour,
      minute: selectedTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final selectedDay = _viewModel.selectedDay;
        final appointments = _viewModel.appointments;

        return Scaffold(
          appBar: AppBar(title: const Text('Work appointments')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        MaterialLocalizations.of(
                          context,
                        ).formatMediumDate(selectedDay),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Total worked time: ${AppointmentHelpers.calculateWorkedTimeText(appointments)}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Entries', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                DayNavigationBar(
                  selectedDay: selectedDay,
                  canGoToNextDay: _viewModel.canGoToNextDay,
                  onPreviousDay: () {
                    _viewModel.goToPreviousDay();
                  },
                  onNextDay: () {
                    _viewModel.goToNextDay();
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: AppointmentsList(appointments: appointments),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openAddAppointmentModal,
            icon: const Icon(Icons.add_alarm),
            label: const Text('Add appointment'),
          ),
        );
      },
    );
  }
}
