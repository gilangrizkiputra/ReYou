import 'package:reyou/domain/entities/reminder_entity.dart';

class ReminderModel extends ReminderEntity {
  const ReminderModel({
    super.id,
    required super.title,
    required super.date,
    required super.time,
    required super.isActive,
  });

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      time: map['time'],
      isActive: map['isActive'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'isActive': isActive,
    };
  }
}
