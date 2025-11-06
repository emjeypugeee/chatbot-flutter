import 'package:chatbot/model/chat_messages.dart';
import 'package:chatbot/services/deepseek_api_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider with ChangeNotifier {
  final String? userId;
  final String apiKey; // This comes from your main.dart
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;
  String? _currentConversationId;

  // This is the DeepSeek API endpoint
  final DeepSeekService _deepSeekService;

  ChatProvider({required this.userId, required this.apiKey})
    : _deepSeekService = DeepSeekService(apiKey: apiKey);

  // --- Getters ---
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // --- THIS IS THE UPDATED METHOD ---

  Future<void> sendMessage(String text) async {
    // ... (all your initial checks for userId and apiKey are perfect) ...

    // 1. Add user message locally and save to Firestore
    final userMessage = Message(
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    await _saveMessageToFirestore(userMessage);

    // --- THIS IS THE MODIFIED PART ---
    // 2. Build the message list *before* calling the service
    final apiMessages = _messages
        .map(
          (msg) => {
            'role': msg.isUser ? 'user' : 'assistant',
            'content': msg.content,
          },
        )
        .toList();

    try {
      // 3. Pass the *entire list* to the service
      print("Sending to API: ${apiMessages.length} messages"); // <-- ADD THIS
      final botText = await _deepSeekService.sendMessage(apiMessages);

      final botMessage = Message(
        content: botText.trim(),
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(botMessage);
      await _saveMessageToFirestore(botMessage);
    } catch (e, s) {
      // <-- ADD 's' for Stack Trace
      _error = "An error occurred: ${e.toString()}";

      // --- ADD THESE LINES ---
      print("--- ERROR IN CHAT PROVIDER ---");
      print(e.toString());
      print(s.toString());
      // -------------------------
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _getOrCreateConversationId(String firstMessage) async {
    if (_currentConversationId != null) {
      return _currentConversationId!;
    }
    final conversationRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc();

    await conversationRef.set({
      'title': firstMessage.length > 40
          ? '${firstMessage.substring(0, 40)}...'
          : firstMessage,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _currentConversationId = conversationRef.id;
    return _currentConversationId!;
  }

  Future<void> _saveMessageToFirestore(Message message) async {
    if (userId == null) return;
    final conversationId = await _getOrCreateConversationId(message.content);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(message.toMap());
  }

  void clearMessages() {
    _messages.clear();
    _currentConversationId = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Stream<QuerySnapshot> getConversationsStream() {
    if (userId == null) {
      return Stream.empty();
    }
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> loadConversation(String conversationId) async {
    if (userId == null) return;

    _messages.clear();
    _isLoading = true;
    _currentConversationId = conversationId;
    notifyListeners();

    try {
      final messagesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp')
          .get();

      final loadedMessages = messagesSnapshot.docs
          .map((doc) => Message.fromMap(doc.data()))
          .toList();

      _messages.addAll(loadedMessages);
    } catch (e) {
      _error = "Error loading chat: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    if (userId == null) return;

    final convoRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId);

    try {
      final messagesSnapshot = await convoRef.collection('messages').get();
      for (final doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      await convoRef.delete();
    } catch (e) {
      _error = "Error deleting conversation: $e";
      notifyListeners();
    }
  }

  Future<void> renameConversation(
    String conversationId,
    String newTitle,
  ) async {
    if (userId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('conversations')
          .doc(conversationId)
          .update({'title': newTitle});
    } catch (e) {
      _error = "Error renaming conversation: $e";
      notifyListeners();
    }
  }
}
