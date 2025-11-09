class AppLockModel {
  final String packageName;
  final String appName;
  final String? iconBase64;
  final String? unlockDate;
  final String? unlockTime;
  final bool isLocked;

  AppLockModel({
    required this.packageName,
    required this.appName,
    this.iconBase64,
    this.unlockDate,
    this.unlockTime,
    this.isLocked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'appName': appName,
      'iconBase64': iconBase64,
      'unlockDate': unlockDate,
      'unlockTime': unlockTime,
      'isLocked': isLocked ? 1 : 0,
    };
  }

  factory AppLockModel.fromMap(Map<String, dynamic> map) {
    return AppLockModel(
      packageName: map['packageName'],
      appName: map['appName'],
      iconBase64: map['iconBase64'],
      unlockDate: map['unlockDate'],
      unlockTime: map['unlockTime'],
      isLocked: map['isLocked'] == 1,
    );
  }
}
