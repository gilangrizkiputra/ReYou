import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/domain/entities/app_lock_entity.dart';
import 'package:reyou/data/repositories/app_lock_repository_impl.dart';
import 'package:reyou/domain/usecases/update_app_lock.dart';

class AppDetailScreen extends StatefulWidget {
  final AppLockEntity app;
  const AppDetailScreen({super.key, required this.app});

  @override
  State<AppDetailScreen> createState() => _AppDetailScreenState();
}

class _AppDetailScreenState extends State<AppDetailScreen> {
  late bool isLocked;
  String? selectedDate;
  String? selectedTime;
  late final UpdateAppLock _updateAppLock;

  @override
  void initState() {
    super.initState();
    isLocked = widget.app.isLocked;
    selectedDate = widget.app.unlockDate;
    selectedTime = widget.app.unlockTime;
    _updateAppLock = UpdateAppLock(AppLockRepositoryImpl());
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yy').format(picked);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime =
            "${picked.hour.toString().padLeft(2, '0')}.${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _saveAppLock() async {
    if (isLocked && (selectedDate == null || selectedTime == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih tanggal dan waktu unlock terlebih dahulu sebelum mengunci aplikasi!',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final updated = AppLockEntity(
      packageName: widget.app.packageName,
      appName: widget.app.appName,
      iconBase64: widget.app.iconBase64,
      unlockDate: selectedDate,
      unlockTime: selectedTime,
      isLocked: isLocked,
    );

    await _updateAppLock.call(updated);
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      appBar: AppBar(
        backgroundColor: greyColor,
        title: Text("Manajemen Aplikasi", style: purpleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        (widget.app.iconBase64 != null &&
                            widget.app.iconBase64!.isNotEmpty)
                        ? MemoryImage(base64Decode(widget.app.iconBase64!))
                        : const AssetImage('assets/images/default_app.png')
                              as ImageProvider,
                    radius: 25,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.app.appName,
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                  Switch(
                    value: isLocked,
                    onChanged: (v) => setState(() => isLocked = v),
                    activeColor: whiteColor,
                    activeTrackColor: purpleColor,
                    inactiveThumbColor: whiteColor,
                    inactiveTrackColor: greyColor,
                    trackOutlineColor: WidgetStateProperty.all(
                      Colors.transparent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Tanggal: ${selectedDate ?? '-'}",
                      style: blackTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    color: purpleColor,
                    onPressed: isLocked ? _pickDate : null,
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Waktu unlock: ${selectedTime ?? '-'}",
                      style: blackTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    color: purpleColor,
                    onPressed: isLocked ? _pickTime : null,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purpleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: _saveAppLock,
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
