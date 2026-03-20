class WorkAppointment {
  const WorkAppointment({required this.id, required this.registeredAt});

  factory WorkAppointment.createForDay({
    required DateTime day,
    required int hour,
    required int minute,
  }) {
    final registeredAt = DateTime(day.year, day.month, day.day, hour, minute);

    return WorkAppointment(
      id: registeredAt.microsecondsSinceEpoch.toString(),
      registeredAt: registeredAt,
    );
  }

  final String id;
  final DateTime registeredAt;
}
