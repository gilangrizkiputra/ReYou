import 'package:flutter/material.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/data/local/user_preference.dart';
import 'package:reyou/presentation/widgets/custom_text_field.dart';

class NamePopup extends StatefulWidget {
  const NamePopup({super.key});

  @override
  State<NamePopup> createState() => _NamePopupState();
}

class _NamePopupState extends State<NamePopup> {
  final TextEditingController _controller = TextEditingController();

  void _saveName() async {
    if (_controller.text.isNotEmpty) {
      await UserPreference.saveUsername(_controller.text);

      if (!mounted) return;
      Navigator.pop(context, _controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: whiteColor,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daftarkan nama kamu agar aku bisa mengingatkan kamu terus!",
              style: blackTextStyle.copyWith(fontSize: 16, fontWeight: regular),
            ),
            SizedBox(height: 20),
            Text(
              "Nama",
              style: blackTextStyle.copyWith(fontSize: 16, fontWeight: regular),
            ),
            SizedBox(height: 8),
            CustomTextField(controller: _controller, hintText: "Masukkan nama"),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: purpleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _saveName,
                child: Text(
                  "Simpan",
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: regular,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
