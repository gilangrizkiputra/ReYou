import 'package:flutter/material.dart';
import 'package:reyou/core/utils/notification_helper.dart';

class ManajementAppScreen extends StatelessWidget {
  const ManajementAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NotificationHelper.showNotification(
            id: 1,
            title: "Test Reminder",
            body: "Notifikasi ini berhasil muncul 🎉",
          );
        },
        child: Icon(Icons.notifications),
      ),
      body: Column(children: [Text('Hello ini Manajemen App Screen')]),
    );
  }
}
