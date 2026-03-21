import 'package:flutter/material.dart';

class DayNavigationBar extends StatelessWidget {
  const DayNavigationBar({
    super.key,
    required this.selectedDay,
    required this.canGoToNextDay,
    required this.onPreviousDay,
    required this.onNextDay,
  });

  final DateTime selectedDay;
  final bool canGoToNextDay;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;

  @override
  Widget build(BuildContext context) {
    final formattedDay = MaterialLocalizations.of(
      context,
    ).formatMediumDate(selectedDay);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            key: const Key('previous-day-button'),
            onPressed: onPreviousDay,
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous day',
          ),
          Expanded(
            child: Text(
              formattedDay,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            key: const Key('next-day-button'),
            onPressed: canGoToNextDay ? onNextDay : null,
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next day',
          ),
        ],
      ),
    );
  }
}
