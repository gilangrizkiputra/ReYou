import '../entities/reminder_entity.dart';
import '../repositories/reminder_repository.dart';

class UpdateReminder {
  final ReminderRepository repository;

  UpdateReminder(this.repository);

  Future<int> call(ReminderEntity reminder) {
    return repository.updateReminder(reminder);
  }
}
