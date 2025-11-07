import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;
  final double padding;
  final double borderRadius;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 24,
    this.padding = 10,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}
