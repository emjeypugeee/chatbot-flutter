import 'package:chatbot/provider/auth_provider.dart';
import 'package:chatbot/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DrawerHistory extends StatefulWidget {
  const DrawerHistory({super.key});

  @override
  State<DrawerHistory> createState() => _DrawerHistoryState();
}

class _DrawerHistoryState extends State<DrawerHistory> {
  String? _nickname;
  bool _isProfileLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNickname();
  }

  Future<void> _fetchNickname() async {
    // We use a slight delay to allow AuthProvider state to settle after login/register
    await Future.delayed(Duration(milliseconds: 500));
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Call the method to get user data
    final data = await authProvider.getUserData();

    setState(() {
      // Set the nickname from the 'name' field in the Firestore document
      _nickname = data?['name'] as String?;
      _isProfileLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final String greetingName = _nickname != null && _nickname!.isNotEmpty
        ? _nickname! // Use the fetched nickname
        : 'Loading...'; // Fallback name
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Center(
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
            ),
            if (_isProfileLoading)
              Center(child: CircularProgressIndicator())
            else
              ListTile(
                leading: Icon(
                  Icons.chat_bubble_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Chat with AI',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  // Handle starting a chat with AI
                  context.pop();
                },
              ),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                greetingName,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              onTap: () {
                // Handle viewing chat history
                context.pop();
              },
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recents',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.history,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'Chat History',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              onTap: () {
                // Handle viewing chat history
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
