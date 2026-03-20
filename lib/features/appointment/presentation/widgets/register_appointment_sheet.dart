import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterAppointmentSheet extends StatefulWidget {
  const RegisterAppointmentSheet({super.key, required this.initialDateTime});

  final DateTime initialDateTime;

  @override
  State<RegisterAppointmentSheet> createState() =>
      _RegisterAppointmentSheetState();
}

class _RegisterAppointmentSheetState extends State<RegisterAppointmentSheet> {
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Register appointment',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose the time you want to register for today.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                initialDateTime: widget.initialDateTime,
                onDateTimeChanged: (value) {
                  setState(() {
                    _selectedDateTime = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pop(TimeOfDay.fromDateTime(_selectedDateTime));
                },
                child: const Text('Save appointment'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
