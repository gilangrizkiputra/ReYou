import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'package:reyou/data/local/database_helper.dart';
import 'package:reyou/domain/entities/app_lock_entity.dart';
import 'package:reyou/domain/repositories/app_lock_repository.dart';
import 'package:reyou/data/models/app_lock_model.dart';

class AppLockRepositoryImpl implements AppLockRepository {
  final db = DatabaseHelper.instance;

  @override
  Future<List<AppLockEntity>> getInstalledApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps();
    final localData = await db.getAllAppLocks();

    return apps.map((app) {
      final match = localData.firstWhere(
        (d) => d.packageName == app.packageName,
        orElse: () => AppLockModel(
          packageName: app.packageName,
          appName: app.name,
          iconBase64: null,
          isLocked: false,
        ),
      );

      return AppLockEntity(
        packageName: app.packageName,
        appName: app.name,
        iconBase64: match.iconBase64,
        unlockDate: match.unlockDate,
        unlockTime: match.unlockTime,
        isLocked: match.isLocked,
      );
    }).toList();
  }

  @override
  Future<void> saveOrUpdateApp(AppLockEntity app) async {
    final model = AppLockModel(
      packageName: app.packageName,
      appName: app.appName,
      iconBase64: app.iconBase64,
      unlockDate: app.unlockDate,
      unlockTime: app.unlockTime,
      isLocked: app.isLocked,
    );
    await db.insertOrUpdateApp(model);
  }

  @override
  Future<void> updateLockStatus(String packageName, bool isLocked) async {
    await db.updateLockStatus(packageName, isLocked);
  }
}
