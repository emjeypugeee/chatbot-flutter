import 'package:chatbot/components/drawer_history.dart';
import 'package:chatbot/components/prompt_button.dart';
import 'package:chatbot/provider/auth_provider.dart';
import 'package:chatbot/provider/chat_provider.dart'; // Add this import
import 'package:chatbot/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _textController = TextEditingController();
  String? _nickname;
  bool _isProfileLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNickname();
  }

  Future<void> _fetchNickname() async {
    await Future.delayed(Duration(milliseconds: 50));
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final data = await authProvider.getUserData();

    setState(() {
      _nickname = data?['name'] as String?;
      _isProfileLoading = false;
    });
  }

  // Updated sendMessage function using ChatProvider
  void _sendMessage() {
    if (_textController.text.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(_textController.text);
    _textController.clear();
  }

  // For streaming (if you prefer)

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;

    final String greetingName = _nickname != null && _nickname!.isNotEmpty
        ? _nickname!
        : 'User not found';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
            // Add clear chat button
            Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return IconButton(
                  onPressed: chatProvider.messages.isNotEmpty
                      ? () {
                          chatProvider.clearMessages();
                        }
                      : null,
                  icon: IconButton(
                    icon: Icon(Icons.delete_outline),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: chatProvider.messages.isNotEmpty
                        ? () {
                            chatProvider.clearMessages();
                          }
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      drawer: const DrawerHistory(),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          final hasUserMessages = chatProvider.messages.any(
            (msg) => msg.isUser,
          );

          return Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    // Chat Message List using provider messages
                    ListView.builder(
                      reverse: false,
                      padding: const EdgeInsets.only(top: 8.0),
                      itemCount: chatProvider.messages.length,
                      itemBuilder: (context, index) {
                        final message = chatProvider.messages[index];
                        final isUser = message.isUser;

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
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: isUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: isUser
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _formatTime(message.timestamp),
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: isUser
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.surface.withOpacity(0.7)
                                        : Theme.of(context).colorScheme.primary
                                              .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // FLOATING TEXT - Only show when no user messages
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
                                  if (_isProfileLoading)
                                    CircularProgressIndicator()
                                  else
                                    Text(
                                      "Welcome, $greetingName! \nWhat can I help you with?\n👇",
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
                                    children: [
                                      PromptButton(
                                        promptText: '📑 Summarize a text',
                                        onTap: () {
                                          _textController.text =
                                              "Summarize the following text:";
                                          _textController.selection =
                                              TextSelection.collapsed(
                                                offset:
                                                    _textController.text.length,
                                              );
                                        },
                                      ),
                                      SizedBox(width: 10),
                                      PromptButton(
                                        promptText: '🎁 Surprise me!',
                                        onTap: () {
                                          _textController.text =
                                              "Surprise me with something interesting!";
                                          _textController.selection =
                                              TextSelection.collapsed(
                                                offset:
                                                    _textController.text.length,
                                              );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PromptButton(
                                        promptText: '💡 Generate ideas',
                                        onTap: () {
                                          _textController.text =
                                              "Generate some creative ideas for:";
                                          _textController.selection =
                                              TextSelection.collapsed(
                                                offset:
                                                    _textController.text.length,
                                              );
                                        },
                                      ),
                                      SizedBox(width: 10),
                                      PromptButton(
                                        promptText: '✏ Help me write',
                                        onTap: () {
                                          _textController.text =
                                              "Help me write:";
                                          _textController.selection =
                                              TextSelection.collapsed(
                                                offset:
                                                    _textController.text.length,
                                              );
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

                    // Error message
                    if (chatProvider.error != null)
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.white),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  chatProvider.error!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  chatProvider.clearError();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Loading indicator when sending message
                    if (chatProvider.isLoading)
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "ChatBot is thinking...",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Text Input Area
              _buildTextComposer(chatProvider.isLoading),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextComposer(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Colors.grey[900]!, width: 1.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  controller: _textController,
                  onSubmitted: (_) => _sendMessage(),
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    hintText: isLoading
                        ? "Waiting for response..."
                        : "Send a message...",
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                  ),
                ),
              ),
            ),

            // Send Button with loading state
            Container(
              decoration: BoxDecoration(
                color: isLoading
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                onPressed: isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format time
  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
