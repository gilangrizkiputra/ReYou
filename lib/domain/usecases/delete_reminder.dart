import '../repositories/reminder_repository.dart';

class DeleteReminder {
  final ReminderRepository repository;

  DeleteReminder(this.repository);

  Future<int> call(int id) {
    return repository.deleteReminder(id);
  }
}
