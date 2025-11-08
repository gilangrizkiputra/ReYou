import '../entities/reminder_entity.dart';
import '../repositories/reminder_repository.dart';

class AddReminder {
  final ReminderRepository repository;

  AddReminder(this.repository);

  Future<int> call(ReminderEntity reminder) {
    return repository.insertReminder(reminder);
  }
}
