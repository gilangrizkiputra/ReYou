import '../repositories/reminder_repository.dart';

class UpdateReminderStatus {
  final ReminderRepository repository;

  UpdateReminderStatus(this.repository);

  Future<int> call(int id, int isActive) {
    return repository.updateReminderStatus(id, isActive);
  }
}
