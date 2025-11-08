import 'package:reyou/core/utils/notification_helper.dart';
import 'package:intl/intl.dart';

class ScheduleNotification {
  Future<void> call({
    required int id,
    required String title,
    required String date,
    required String time,
  }) async {
    try {
      final formattedDate = DateFormat('dd/MM/yyyy HH.mm').parse('$date $time');

      await NotificationHelper.scheduleNotification(
        id: id,
        title: title,
        body: 'Waktunya untuk $title!',
        scheduledTime: formattedDate,
      );
    } catch (e) {
      print('Gagal menjadwalkan notifikasi: $e');
    }
  }
}
