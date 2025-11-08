import '../entities/reminder_entity.dart';

abstract class ReminderRepository {
  Future<int> insertReminder(ReminderEntity reminder);
  Future<List<ReminderEntity>> getReminders();
  Future<int> updateReminder(ReminderEntity reminder);
  Future<int> updateReminderStatus(int id, int isActive);
  Future<int> deleteReminder(int id);
}
