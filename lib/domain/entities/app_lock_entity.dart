class AppLockEntity {
  final String packageName;
  final String appName;
  final String? iconBase64;
  final String? unlockDate;
  final String? unlockTime;
  final bool isLocked;

  AppLockEntity({
    required this.packageName,
    required this.appName,
    this.iconBase64,
    this.unlockDate,
    this.unlockTime,
    this.isLocked = false,
  });
}
