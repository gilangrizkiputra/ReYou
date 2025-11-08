class ReminderEntity {
  final int? id;
  final String title;
  final String date;
  final String time;
  final int isActive;

  const ReminderEntity({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.isActive,
  });
}
