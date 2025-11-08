import '../entities/reminder_entity.dart';
import '../repositories/reminder_repository.dart';

class GetReminders {
  final ReminderRepository repository;

  GetReminders(this.repository);

  Future<List<ReminderEntity>> call() {
    return repository.getReminders();
  }
}
