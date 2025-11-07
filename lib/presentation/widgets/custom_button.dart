import 'package:flutter/material.dart';
import 'package:reyou/core/constants/theme.dart';

class CustomButon extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const CustomButon({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        text,
        style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
      ),
    );
  }
}
