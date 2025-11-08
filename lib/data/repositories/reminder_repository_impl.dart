import 'package:reyou/data/local/database_helper.dart';
import 'package:reyou/data/models/reminder.dart';
import 'package:reyou/domain/entities/reminder_entity.dart';
import 'package:reyou/domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<int> insertReminder(ReminderEntity reminder) async {
    final model = ReminderModel(
      title: reminder.title,
      date: reminder.date,
      time: reminder.time,
      isActive: reminder.isActive,
    );
    return await dbHelper.insertReminder(model);
  }

  @override
  Future<List<ReminderEntity>> getReminders() async {
    return await dbHelper.getReminders();
  }

  @override
  Future<int> updateReminder(ReminderEntity reminder) async {
    final model = ReminderModel(
      id: reminder.id,
      title: reminder.title,
      date: reminder.date,
      time: reminder.time,
      isActive: reminder.isActive,
    );
    return await dbHelper.updateReminder(model);
  }

  @override
  Future<int> updateReminderStatus(int id, int isActive) async {
    return await dbHelper.updateReminderStatus(id, isActive);
  }

  @override
  Future<int> deleteReminder(int id) async {
    return await dbHelper.deleteReminder(id);
  }
}
