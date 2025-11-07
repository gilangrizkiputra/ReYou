import 'package:flutter/material.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/data/local/database_helper.dart';
import 'package:reyou/presentation/widgets/add_edit_popup.dart';

class ReminderCard extends StatefulWidget {
  final int id;
  final String title;
  final String date;
  final String time;
  final bool isActive;

  const ReminderCard({
    super.key,
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.isActive,
  });

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final edited = await showDialog(
          context: context,
          builder: (context) => AddEditPopup(
            isEdit: true,
            title: widget.title,
            date: widget.date,
            time: widget.time,
          ),
        );
        if (edited != null) {
          setState(() {});
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
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isActive ? greenColor : redColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 20),
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
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          size: 15,
                          color: blackColor,
                        ),
                        SizedBox(width: 2),
                        Text(
                          widget.date,
                          style: blackTextStyle.copyWith(
                            fontSize: 11,
                            fontWeight: regular,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.access_time_rounded,
                          size: 15,
                          color: blackColor,
                        ),
                        SizedBox(width: 2),
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
              onChanged: (value) async {
                setState(() => isActive = value);
                await DatabaseHelper.instance.updateReminderStatus(
                  widget.id,
                  value ? 1 : 0,
                );
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
