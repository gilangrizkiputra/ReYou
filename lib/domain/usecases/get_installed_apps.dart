import 'package:reyou/domain/entities/app_lock_entity.dart';
import 'package:reyou/domain/repositories/app_lock_repository.dart';

class GetInstalledApps {
  final AppLockRepository repository;
  GetInstalledApps(this.repository);

  Future<List<AppLockEntity>> call() async {
    return await repository.getInstalledApps();
  }
}
