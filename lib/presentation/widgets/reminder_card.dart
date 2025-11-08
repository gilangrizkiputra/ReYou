import 'package:flutter/material.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/data/models/reminder.dart';
import 'package:reyou/data/repositories/reminder_repository_impl.dart';
import 'package:reyou/domain/usecases/update_reminder.dart';
import 'package:reyou/domain/usecases/update_status.dart';
import 'package:reyou/presentation/widgets/add_edit_popup.dart';

class ReminderCard extends StatefulWidget {
  final int id;
  final String title;
  final String date;
  final String time;
  final bool isActive;
  final bool isDeleteMode;
  final bool isSelected;

  final VoidCallback? onUpdate;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onSelect;

  const ReminderCard({
    super.key,
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.isActive,
    required this.isDeleteMode,
    required this.isSelected,
    this.onUpdate,
    this.onLongPress,
    this.onSelect,
  });

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  late bool isActive;

  final _repository = ReminderRepositoryImpl();
  late final UpdateReminderStatus _updateReminderStatus;
  late final UpdateReminder _updateReminder;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
    _updateReminderStatus = UpdateReminderStatus(_repository);
    _updateReminder = UpdateReminder(_repository);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTap: () async {
        if (widget.isDeleteMode) {
          widget.onSelect?.call(!widget.isSelected);
        } else {
          final editedData = await showDialog(
            context: context,
            builder: (context) => AddEditPopup(
              isEdit: true,
              title: widget.title,
              date: widget.date,
              time: widget.time,
            ),
          );
          if (editedData != null) {
            await _updateReminder(
              ReminderModel(
                id: widget.id,
                title: editedData['title'],
                date: editedData['date'],
                time: editedData['time'],
                isActive: isActive ? 1 : 0,
              ),
            );
            widget.onUpdate?.call();
            if (mounted) setState(() {});
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.isDeleteMode
                    ? GestureDetector(
                        onTap: () => widget.onSelect?.call(!widget.isSelected),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.isSelected
                                  ? purpleColor
                                  : greyColor,
                              width: 2,
                            ),
                            color: widget.isSelected
                                ? purpleColor
                                : Colors.white,
                          ),
                          child: widget.isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      )
                    : Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isActive ? greenColor : redColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: purpleTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          size: 15,
                          color: blackColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          widget.date,
                          style: blackTextStyle.copyWith(
                            fontSize: 11,
                            fontWeight: regular,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.access_time_rounded,
                          size: 15,
                          color: blackColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          widget.time,
                          style: blackTextStyle.copyWith(
                            fontSize: 11,
                            fontWeight: regular,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Switch(
              value: isActive,
              onChanged: widget.isDeleteMode
                  ? null
                  : (value) async {
                      setState(() => isActive = value);
                      await _updateReminderStatus(widget.id, value ? 1 : 0);
                    },
              activeColor: whiteColor,
              activeTrackColor: purpleColor,
              inactiveThumbColor: whiteColor,
              inactiveTrackColor: greyColor,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }
}
