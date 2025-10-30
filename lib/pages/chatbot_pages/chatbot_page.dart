import 'package:chatbot/components/drawer_history.dart';
import 'package:chatbot/components/prompt_button.dart';
import 'package:chatbot/provider/auth_provider.dart';
import 'package:chatbot/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Changed to StatefulWidget to manage chat messages and text input state
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  // Controller for managing the text input field
  final TextEditingController _textController = TextEditingController();

  // State to hold the fetched user nickname and loading status
  String? _nickname;
  bool _isProfileLoading = true;

  // List to hold chat messages (placeholder data)
  final List<String> _messages = [
    "Hello! How can I assist you today?",
    "I'm looking for information on Flutter widgets.",
    "Flutter has many powerful widgets! For chat interfaces, you often use Scaffold, ListView, and TextField.",
  ];

  @override
  void initState() {
    super.initState();
    _fetchNickname();
  }

  // New method to fetch the nickname from Firestore
  Future<void> _fetchNickname() async {
    // We use a slight delay to allow AuthProvider state to settle after login/register
    await Future.delayed(Duration(milliseconds: 50));
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Call the method to get user data
    final data = await authProvider.getUserData();

    setState(() {
      // Set the nickname from the 'name' field in the Firestore document
      _nickname = data?['name'] as String?;
      _isProfileLoading = false;
    });
  }

  // Dummy function to handle sending a message
  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      // For a real app, you would send this to the chatbot logic/API
      // and update the messages list with the response.
      setState(() {
        // Add new user message to the end of the list
        _messages.add("You: ${_textController.text}");
      });
      _textController.clear();
      // Scroll to the bottom when a new message is added
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    final bool hasUserMessages = _messages.any((msg) => msg.startsWith("You:"));

    // Determine the greeting
    final String greetingName = _nickname != null && _nickname!.isNotEmpty
        ? _nickname! // Use the fetched nickname
        : 'User not found'; // Fallback name

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
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
      drawer: const DrawerHistory(),
      body: Column(
        children: <Widget>[
          // 1. Expanded area for chat messages (fills available space)
          Expanded(
            child: Stack(
              children: [
                // Chat Message List
                ListView.builder(
                  // 1. CHAT ORDER CHANGE: Set reverse to false for latest messages at the bottom
                  reverse: false,
                  padding: const EdgeInsets.only(top: 8.0),
                  itemCount: _messages.length,
                  // Use the standard index to display messages from oldest (index 0) to newest (last index)
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message.startsWith("You:");

                    // Simple chat bubble
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          message.replaceFirst(
                            isUser ? "You: " : "",
                            "",
                          ), // Remove prefix for cleaner display
                          style: TextStyle(
                            fontSize: isUser ? 15.0 : 16.0,
                            color: isUser
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // FLOATING TEXT
                if (!hasUserMessages)
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Conditional display based on loading state
                              if (_isProfileLoading)
                                CircularProgressIndicator()
                              else
                                Text(
                                  "Welcome, $greetingName! \nWhat can I help you with?\n👇", // <<< UPDATED GREETING
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              SizedBox(height: screenHeight * 0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  PromptButton(
                                    promptText: '📑 Summarize a text',
                                    onTap: () {
                                      _textController.text =
                                          "Summarize the following text:";
                                    },
                                  ),
                                  PromptButton(
                                    promptText: '🎁 Surprise me!',
                                    onTap: () {
                                      _textController.text =
                                          "Surprise me with something:";
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  PromptButton(
                                    promptText: '💡 Generate ideas',
                                    onTap: () {
                                      _textController.text =
                                          "Generate some ideas for:";
                                    },
                                  ),
                                  PromptButton(
                                    promptText: '✏ Help me write',
                                    onTap: () {
                                      _textController.text = "Help me write:";
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 3. The Fixed Text Input Area (Chat Bar)
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      // Add a clean border line above the input area
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Colors.grey[900]!, width: 1.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: SafeArea(
        // SafeArea ensures the input is above system bars (like home indicators)
        child: Row(
          children: <Widget>[
            // Flexible TextField
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  controller: _textController,
                  onSubmitted: (_) =>
                      _sendMessage(), // Send message when Enter is pressed
                  decoration: InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey[500],
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                  ),
                ),
              ),
            ),

            // Send Button
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[500],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
