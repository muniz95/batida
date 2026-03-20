import 'package:batida/config/di/app_dependencies.dart';
import 'package:batida/features/appointment/presentation/viewmodels/appointments_view_model.dart';
import 'package:batida/features/appointment/presentation/views/appointments_list.dart';
import 'package:batida/features/appointment/presentation/widgets/register_appointment_sheet.dart';
import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late final AppointmentsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AppointmentsViewModel(
      registerWorkAppointment: widget.dependencies.registerWorkAppointment,
      getAppointmentsForDay: widget.dependencies.getAppointmentsForDay,
      now: widget.dependencies.now,
    );
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
          RegisterAppointmentSheet(initialDateTime: _viewModel.currentDay),
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
        final currentDay = _viewModel.currentDay;

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
                        'Today',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        MaterialLocalizations.of(
                          context,
                        ).formatMediumDate(currentDay),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${_viewModel.appointmentsCount} appointment${_viewModel.appointmentsCount == 1 ? '' : 's'} registered',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Entries', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Expanded(
                  child: AppointmentsList(
                    appointments: _viewModel.todaysAppointments,
                  ),
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
