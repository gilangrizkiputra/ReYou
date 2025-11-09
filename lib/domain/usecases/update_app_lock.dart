import 'package:reyou/domain/entities/app_lock_entity.dart';
import 'package:reyou/domain/repositories/app_lock_repository.dart';

class UpdateAppLock {
  final AppLockRepository repository;
  UpdateAppLock(this.repository);

  Future<void> call(AppLockEntity app) async {
    await repository.saveOrUpdateApp(app);
  }
}
