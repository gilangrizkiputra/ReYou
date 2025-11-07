class ReminderModel {
  final int? id;
  final String title;
  final String date;
  final String time;
  final bool isActive;

  ReminderModel({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      time: map['time'],
      isActive: map['isActive'] == 1,
    );
  }
}
