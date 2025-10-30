import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatbot/components/custom_button.dart';
import 'package:chatbot/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int currentIndex = 1;

  final titles = [
    'Unlock the Power of Future AI',
    'Chat With your Favorite AI',
    'Boost your Mind with AI',
  ];

  var images = [
    Image.asset('lib/assets/images/slider2.png'),
    Image.asset('lib/assets/images/slider1.png'),
    Image.asset('lib/assets/images/slider3.png'),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return IconButton(
                  onPressed: () => themeProvider.toggleTheme(),
                  icon: Icon(
                    themeProvider.isLightMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                initialPage: 1,
                height: 400.0,
                viewportFraction: 0.8,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              items: images.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: i,
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...images.asMap().entries.map(
                  (item) => Container(
                    height: 12,
                    width: screenWidth * 0.02,
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentIndex == item.key
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            AnimatedSwitcher(
              duration: Duration(microseconds: 300),
              key: ValueKey<int>(currentIndex),

              child: Text(
                titles[currentIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Chat with the smartest AI Future Experience power of AI with us',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Get Started',
              corner: 10,
              onTap: () => context.push('/welcome'),
              buttonColor: Theme.of(context).colorScheme.primary,
              textColor: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}
