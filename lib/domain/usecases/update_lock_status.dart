import 'package:reyou/domain/repositories/app_lock_repository.dart';

class UpdateLockStatus {
  final AppLockRepository repository;
  UpdateLockStatus(this.repository);

  Future<void> call(String packageName, bool isLocked) async {
    await repository.updateLockStatus(packageName, isLocked);
  }
}
