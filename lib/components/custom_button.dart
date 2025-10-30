import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double corner;
  final void Function()? onTap;
  final Color buttonColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.corner,
    required this.onTap,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(corner),
        ),
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
