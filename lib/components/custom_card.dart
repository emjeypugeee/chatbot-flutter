import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String cardText;
  final Icon icon;
  final String moneyText;

  const CustomCard({
    super.key,
    required this.cardText,
    required this.icon,
    required this.moneyText,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 135,
      width: screenWidth * 0.3,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            Text(cardText, style: TextStyle(fontSize: 12, color: Colors.white)),
            SizedBox(height: 30),
            Text(
              moneyText,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
