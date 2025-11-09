import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/data/repositories/app_lock_repository_impl.dart';
import 'package:reyou/domain/entities/app_lock_entity.dart';
import 'package:reyou/domain/usecases/get_installed_apps.dart';
import 'package:reyou/presentation/screens/app_manajement_detail_screen.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AppManagementScreen extends StatefulWidget {
  const AppManagementScreen({super.key});

  @override
  State<AppManagementScreen> createState() => _AppManagementScreenState();
}

class _AppManagementScreenState extends State<AppManagementScreen> {
  final repo = AppLockRepositoryImpl();
  late final GetInstalledApps _getInstalledApps;
  bool isLoading = true;
  List<AppLockEntity> apps = [];

  @override
  void initState() {
    super.initState();
    _getInstalledApps = GetInstalledApps(repo);
    _loadApps();
  }

  void _loadApps() async {
    setState(() => isLoading = true);
    final data = await _getInstalledApps.call();
    setState(() {
      apps = data;
      isLoading = false;
    });
  }

  static const platform = MethodChannel('app_lock_channel');

  Future<void> sendLockedAppsToNative(List<AppLockEntity> apps) async {
    final List<Map<String, String>> payload = apps.map((app) {
      return {
        "packageName": app.packageName,
        "unlockDate": app.unlockDate ?? '',
        "unlockTime": app.unlockTime ?? '',
        "isLocked": app.isLocked.toString(),
      };
    }).toList();

    try {
      await platform.invokeMethod('updateLockedApps', payload);
      await platform.invokeMethod('stopService'); // force reset
      await platform.invokeMethod('startService');
    } catch (e) {
      debugPrint("FAILED: send locked apps: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      appBar: AppBar(
        backgroundColor: greyColor,
        title: Text("Manajemen Aplikasi", style: purpleTextStyle),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                return GestureDetector(
                  onTap: () async {
                    final updatedApp = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppDetailScreen(app: app),
                      ),
                    );

                    if (updatedApp != null && updatedApp is AppLockEntity) {
                      setState(() {
                        final index = apps.indexWhere(
                          (a) => a.packageName == updatedApp.packageName,
                        );
                        if (index != -1) {
                          apps[index] = updatedApp;
                        }
                      });
                      final lockedApps = apps.where((a) => a.isLocked).toList();
                      await sendLockedAppsToNative(lockedApps);
                      await platform.invokeMethod('startService');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image:
                                  (app.iconBase64 != null &&
                                      app.iconBase64!.isNotEmpty)
                                  ? MemoryImage(base64Decode(app.iconBase64!))
                                  : const AssetImage(
                                          'assets/images/default_app.png',
                                        )
                                        as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            app.appName,
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Image.asset(
                              app.isLocked
                                  ? 'assets/icons/icon_time_unlock_manajemen.png'
                                  : 'assets/icons/icon_unlock_manajemen.png',
                              width: 18,
                              height: 18,
                              color: blackColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              app.isLocked
                                  ? "${app.unlockTime ?? '-'}"
                                  : "Unlock",
                              style: blackTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
