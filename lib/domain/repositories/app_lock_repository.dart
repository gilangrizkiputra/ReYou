import 'package:reyou/domain/entities/app_lock_entity.dart';

abstract class AppLockRepository {
  Future<List<AppLockEntity>> getInstalledApps();
  Future<void> saveOrUpdateApp(AppLockEntity app);
  Future<void> updateLockStatus(String packageName, bool isLocked);
}
