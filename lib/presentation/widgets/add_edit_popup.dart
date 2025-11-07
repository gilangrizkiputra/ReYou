import 'package:flutter/material.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/data/local/user_preference.dart';
import 'package:reyou/presentation/widgets/custom_button.dart';
import 'package:reyou/presentation/widgets/custom_icon_button.dart';
import 'package:reyou/presentation/widgets/custom_text_field.dart';

class AddEditPopup extends StatefulWidget {
  final String? title;
  final String? date;
  final String? time;
  final bool isEdit;

  const AddEditPopup({
    super.key,
    this.title,
    this.date,
    this.time,
    this.isEdit = false,
  });

  @override
  State<AddEditPopup> createState() => _AddEditPopupState();
}

class _AddEditPopupState extends State<AddEditPopup> {
  late TextEditingController _titleController;
  String selectedDate = '';
  String selectedTime = '';
  String? username;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title ?? '');
    selectedDate = widget.date ?? 'Pilih tanggal';
    selectedTime = widget.time ?? 'Pilih waktu';
    _loadUsername();
  }

  void _loadUsername() async {
    username = await UserPreference.getUsername();
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
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

  void _saveReminder() {
    if (_titleController.text.isEmpty ||
        selectedDate == 'Pilih tanggal' ||
        selectedTime == 'Pilih waktu') {
      return;
    }

    Navigator.pop(context, {
      "title": _titleController.text,
      "date": selectedDate,
      "time": selectedTime,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isEdit
                  ? "Kamu mau edit apa nih $username?"
                  : "Halo $username, mau buat pengingat apa nih?",
              style: blackTextStyle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Text("Kegiatan", style: blackTextStyle),
            const SizedBox(height: 5),
            CustomTextField(
              controller: _titleController,
              hintText: "Masukkan nama",
            ),
            const SizedBox(height: 20),
            Text("Tanggal", style: blackTextStyle),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(text: selectedDate),
                    hintText: "Pilih tanggal",
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 10),
                CustomIconButton(
                  icon: Icons.date_range,
                  color: purpleColor,
                  onTap: _selectDate,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Waktu", style: blackTextStyle),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: TextEditingController(text: selectedTime),
                    hintText: "Pilih waktu",
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 10),
                CustomIconButton(
                  icon: Icons.access_time,
                  color: purpleColor,
                  onTap: _selectTime,
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: CustomButon(
                    text: "Batal",
                    color: redColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButon(
                    text: "Simpan",
                    color: purpleColor,
                    onPressed: _saveReminder,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
