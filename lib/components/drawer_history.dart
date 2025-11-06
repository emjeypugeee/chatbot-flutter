// components/drawer_history.dart
import 'package:chatbot/provider/auth_provider.dart';
import 'package:chatbot/provider/chat_provider.dart'; // Import ChatProvider
import 'package:chatbot/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DrawerHistory extends StatefulWidget {
  const DrawerHistory({super.key});

  @override
  State<DrawerHistory> createState() => _DrawerHistoryState();
}

class _DrawerHistoryState extends State<DrawerHistory> {
  final TextEditingController _renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // --- Helper method to show the rename dialog ---
  Future<void> _showRenameDialog(
    ChatProvider chatProvider,
    String conversationId,
    String currentTitle,
  ) {
    _renameController.text = currentTitle; // Pre-fill the text field

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Rename Conversation',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: TextField(
            controller: _renameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter new title',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_renameController.text.isNotEmpty) {
                  chatProvider.renameConversation(
                    conversationId,
                    _renameController.text,
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _renameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Get the ChatProvider instance
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);

    final String greetingName =
        authProvider.nickname != null && authProvider.nickname!.isNotEmpty
        ? authProvider.nickname!
        : 'User';

    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        // Use Column for more control over scrolling parts
        child: Column(
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
            if (authProvider.isLoading)
              Center(child: CircularProgressIndicator())
            else
              ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  greetingName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  context.pop();
                },
              ),

            // "New Chat" button - Renamed from "Chat with AI"
            ListTile(
              leading: Icon(
                Icons.add, // Changed icon
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'New Chat',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              onTap: () {
                chatProvider.clearMessages(); // This creates a new chat
                context.pop();
              },
            ),
            SizedBox(height: screenHeight * 0.02), // Reduced spacing
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recents',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // --- THIS IS THE DYNAMIC LIST ---
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Get the stream from the provider
                stream: chatProvider.getConversationsStream(),
                builder: (context, snapshot) {
                  // Handle loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Handle error state
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading history.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  }

                  // Handle no data
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No conversations yet.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  }

                  // Display the list of conversations
                  final conversations = snapshot.data!.docs;

                  return ListView.builder(
                    padding: EdgeInsets.zero, // Remove padding
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final convo = conversations[index];
                      final data = convo.data() as Map<String, dynamic>;
                      final title = data['title'] as String? ?? 'Untitled Chat';

                      // This is your ListTile template, now with real data
                      return ListTile(
                        trailing: PopupMenuButton<String>(
                          color: Theme.of(context).colorScheme.primary,
                          icon: Icon(
                            Icons.more_horiz,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onSelected: (String result) {
                            switch (result) {
                              case 'rename':
                                _showRenameDialog(
                                  chatProvider,
                                  convo.id,
                                  title,
                                );
                                break;
                              case 'delete':
                                chatProvider.deleteConversation(convo.id);
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'rename',
                                  child: Text(
                                    'Rename Conversation',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                    ),
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Text(
                                    'Clear History',
                                    style: TextStyle(
                                      color:
                                          Colors.red, // Make delete stand out
                                    ),
                                  ),
                                ),
                              ],
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // Load this conversation
                          chatProvider.loadConversation(convo.id);
                          context.pop(); // Close the drawer
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // --- Logout Button (Example of how to pin to bottom) ---
            const Divider(color: Colors.grey),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
