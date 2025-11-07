import 'package:flutter/material.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/data/local/database_helper.dart';
import 'package:reyou/data/local/user_preference.dart';
import 'package:reyou/data/models/reminder.dart';
import 'package:reyou/presentation/routes/app_routes.dart';
import 'package:reyou/presentation/widgets/add_edit_popup.dart';
import 'package:reyou/presentation/widgets/name_popup.dart';
import 'package:reyou/presentation/widgets/reminder_card.dart';

final dbHelper = DatabaseHelper.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ReminderModel> reminders = [];
  String? username;
  bool _isLoading = true;

  bool _isDeleteMode = false;
  final List<int> _selectedIds = [];

  @override
  void initState() {
    super.initState();
    _checkUserName();
    _loadUsername();
  }

  void _checkUserName() async {
    bool hasName = await UserPreference.hasUsername();

    if (!hasName && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const NamePopup(),
        );

        await _loadUsername();
        _loadReminders();
      });
    } else {
      await _loadUsername();
      _loadReminders();
    }
  }

  Future<void> _loadUsername() async {
    final name = await UserPreference.getUsername();
    setState(() {
      username = name;
    });
  }

  void _loadReminders() async {
    final data = await dbHelper.getReminders();
    setState(() {
      reminders = data;
      _isLoading = false;
    });
  }

  Future<void> _addReminder() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const AddEditPopup(),
    );

    if (result != null) {
      final newReminder = ReminderModel(
        title: result['title'],
        date: result['date'],
        time: result['time'],
      );

      await dbHelper.insertReminder(newReminder);
      _loadReminders();
    }
  }

  Future<void> _deleteSelectedReminders() async {
    if (_selectedIds.isEmpty) return;

    bool? confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: Text("Yakin mau menghapus ${_selectedIds.length} pengingat?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (int id in _selectedIds) {
        await dbHelper.deleteReminder(id);
      }
      setState(() {
        _isDeleteMode = false;
        _selectedIds.clear();
      });
      _loadReminders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isDeleteMode) {
          setState(() {
            _isDeleteMode = false;
            _selectedIds.clear();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: greyColor,
        appBar: AppBar(
          backgroundColor: greyColor,
          title: Padding(
            padding: const EdgeInsets.only(left: 5),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Pengingat",
                      style: purpleTextStyle.copyWith(fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.manajement);
                    },
                  ),
                  PopupMenuItem(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Management App",
                      style: purpleTextStyle.copyWith(fontSize: 14),
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
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pengingat",
                    style: blackTextStyle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : reminders.isEmpty
                        ? Center(
                            child: Text(
                              "Kamu belum mempunyai pengingat!",
                              style: blackTextStyle.copyWith(fontSize: 14),
                            ),
                          )
                        : ListView.builder(
                            itemCount: reminders.length,
                            itemBuilder: (context, index) {
                              final item = reminders[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: ReminderCard(
                                  id: item.id!,
                                  title: item.title,
                                  date: item.date,
                                  time: item.time,
                                  isActive: item.isActive,
                                  isDeleteMode: _isDeleteMode,
                                  isSelected: _selectedIds.contains(item.id),
                                  onLongPress: () {
                                    setState(() => _isDeleteMode = true);
                                  },
                                  onSelect: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedIds.add(item.id!);
                                      } else {
                                        _selectedIds.remove(item.id);
                                      }
                                    });
                                  },
                                  onUpdate: _loadReminders,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            if (_isDeleteMode)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _deleteSelectedReminders,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withAlpha(100),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.delete, color: Colors.white),
                          const SizedBox(width: 8),
                          Text("Hapus", style: whiteTextStyle),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !_isDeleteMode
            ? Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: GestureDetector(
                  onTap: _addReminder,
                  child: Container(
                    width: 76,
                    height: 71,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [purpleColor, purpleColor],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: purpleColor.withAlpha(100),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add, color: whiteColor, size: 60),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
