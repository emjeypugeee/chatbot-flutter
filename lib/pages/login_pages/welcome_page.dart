import 'package:chatbot/components/custom_button.dart';
import 'package:chatbot/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.push('/intro'),
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return IconButton(
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                  icon: Icon(
                    themeProvider.isLightMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  String imagePath = themeProvider.isLightMode
                      ? 'lib/assets/images/logo_light.png'
                      : 'lib/assets/images/logo_dark.png';

                  return SizedBox(
                    width: screenWidth * 0.6,
                    height: 200,
                    child: Image.asset(imagePath),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to BrainBox',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 50),
            CustomButton(
              text: 'Log in',
              corner: 20,
              onTap: () => context.push('/login'),
              buttonColor: Color(0xFF232627),
              textColor: Colors.white,
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Sign up',
              corner: 20,
              onTap: () => context.push('/register'),
              buttonColor: Colors.grey,
              textColor: Colors.black,
            ),
            SizedBox(height: 50),
            Text(
              'Connect With Accounts',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 50,
              children: [
                CustomButton(
                  text: '    G O O G L E    ',
                  corner: 10,
                  onTap: () {},
                  buttonColor: Colors.red.shade100,
                  textColor: Colors.red,
                ),
                CustomButton(
                  text: '  F A C E B O O K  ',
                  corner: 10,
                  onTap: () {},
                  buttonColor: Colors.blue.shade200,
                  textColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
