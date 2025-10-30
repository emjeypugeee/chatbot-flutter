import 'package:flutter/material.dart';

class PromptButton extends StatelessWidget {
  final String promptText;
  final void Function()? onTap;

  const PromptButton({
    super.key,
    required this.promptText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Container(
      height: screenHeight * 0.05,
      width: screenWidth * 0.4,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: screenWidth * 0.0045,
        ),
      ),
      child: TextButton(onPressed: onTap, child: Text(promptText)),
    );
  }
}
