import 'package:chatbot/components/custom_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overview',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 30,
              ),
            ),
            Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
              size: 50,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(0),
        child: Column(
          children: [
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomCard(
                    cardText: 'Total Salary:',
                    icon: Icon(Icons.wallet, color: Colors.white, size: 30),
                    moneyText: '₱ 30,000',
                  ),
                  SizedBox(width: 10),
                  CustomCard(
                    cardText: 'Total Expenses',
                    icon: Icon(Icons.wallet, size: 30, color: Colors.white),
                    moneyText: '₱ 15000',
                  ),
                  SizedBox(width: 10),
                  CustomCard(
                    cardText: 'Monthly Expenses',
                    icon: Icon(Icons.money, size: 30, color: Colors.white),
                    moneyText: '₱ 5000',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: screenWidth * 1,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
