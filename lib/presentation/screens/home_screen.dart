import 'package:flutter/material.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/data/local/user_preference.dart';
import 'package:reyou/presentation/routes/app_routes.dart';
import 'package:reyou/presentation/widgets/add_edit_popup.dart';
import 'package:reyou/presentation/widgets/name_popup.dart';
import 'package:reyou/presentation/widgets/reminder_card.dart';

final List<Map<String, String>> reminderList = [
  {"title": "Belajar Flutter", "date": "24/10/2025", "time": "17.50"},
  {"title": "Olahraga Pagi", "date": "25/10/2025", "time": "06.00"},
  {"title": "Meeting Tim", "date": "26/10/2025", "time": "09.30"},
  {"title": "Belajar Flutter", "date": "24/10/2025", "time": "17.50"},
  {"title": "Olahraga Pagi", "date": "2GGrip5/10/2025", "time": "06.00"},
  {"title": "Meeting Tim", "date": "26/10/2025", "time": "09.30"},
  {"title": "Belajar Flutter", "date": "24/10/2025", "time": "17.50"},
  {"title": "Olahraga Pagi", "date": "25/10/2025", "time": "06.00"},
  {"title": "Meeting Tim", "date": "26/10/2025", "time": "09.30"},
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserName();
    _loadUsername();
  }

  String? username;

  Future<void> _loadUsername() async {
    final name = await UserPreference.getUsername();
    setState(() {
      username = name;
    });
  }

  void _checkUserName() async {
    bool hasName = await UserPreference.hasUsername();
    if (!hasName && mounted) {
      Future.delayed(Duration.zero, () async {
        final result = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const NamePopup(),
        );

        if (result != null) {
          await _loadUsername();
        }
      });
    } else {
      await _loadUsername();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greyColor,
        title: Padding(
          padding: EdgeInsetsGeometry.only(left: 5),
          child: Text(
            username != null ? 'Halo, $username' : '',
            style: purpleTextStyle.copyWith(fontSize: 19, fontWeight: bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: PopupMenuButton(
              color: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              offset: const Offset(0, 40),
              itemBuilder: (cxt) => [
                PopupMenuItem(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Pengingat",
                    style: purpleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: regular,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.manajement);
                  },
                ),
                PopupMenuItem(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Management App",
                    style: purpleTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: regular,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.manajement);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pengingat",
              style: blackTextStyle.copyWith(fontSize: 16, fontWeight: regular),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: reminderList.length,
                itemBuilder: (BuildContext context, index) {
                  final item = reminderList[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ReminderCard(
                      title: item["title"] ?? "-",
                      date: item["date"] ?? "-",
                      time: item["time"] ?? "-",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: GestureDetector(
          onTap: () async {
            final newReminder = await showDialog(
              context: context,
              builder: (context) => const AddEditPopup(),
            );

            if (newReminder != null) {
              setState(() {
                reminderList.add(newReminder);
              });
            }
          },
          child: Container(
            width: 76,
            height: 71,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [purpleColor, purpleColor]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: purpleColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(Icons.add, color: whiteColor, size: 60),
          ),
        ),
      ),
    );
  }
}
