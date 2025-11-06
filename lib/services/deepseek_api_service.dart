import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepSeekService {
  static const String _baseUrl = 'https://api.deepseek.com/v1';
  final String apiKey;

  DeepSeekService({required this.apiKey});

  Future<String> sendMessage(List<Map<String, dynamic>> messages) async {
    // --- THIS IS THE MODIFIED PART ---
    // Create the final list of messages to send to the API.
    // This inserts your system prompt at the beginning of the chat history.
    final apiMessages = [
      {
        'role': 'system',
        'content': '''
              You are a helpful AI assistant. Follow these rules STRICTLY:
              
              CRITICAL FORMATTING RULES:
              - NEVER use markdown formatting of any kind
              - NO asterisks for bold or italic (**text**, *text*)
              - NO hash symbols for headers (# Header, ## Header)
              - NO code blocks with backticks (```code```)
              - NO inline code with backticks (`code`)
              - NO bullet points with asterisks or dashes
              - Use plain text only
              
              WRITING STYLE:
              - Write in clear, natural English
              - Use line breaks for paragraphs when needed
              - You can use simple bullet points with numbers or dashes if needed
              - Keep responses conversational and easy to read
              
              Remember: Plain text only, no special formatting characters!
              
              ADDITIONAL GUIDELINES:
              1. Always respond in a friendly and professional manner
              2. Keep responses concise but informative
              3. If you don't know something, admit it honestly
              4. Always be respectful and avoid harmful content
              ''',
      },
      ...messages, // Use the spread operator to add all messages from the provider
    ];

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': apiMessages, // Send the combined list
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        // Use utf8.decode to handle special characters (like emojis)
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        print("API Error Response: ${response.body}");
        throw Exception(
          'Failed to get response: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e, s) {
      print("--- ERROR IN DEEPSEEK SERVICE ---");
      print(e.toString());
      print(s.toString());
      throw Exception('Error communicating with DeepSeek API: $e');
    }
  }

  // Basic stream implementation
  // I updated the signature to match sendMessage for consistency.
  Stream<String> sendMessageStream(List<Map<String, dynamic>> messages) async* {
    // This is still a placeholder - real streaming is more complex.
    final response = await sendMessage(messages);
    yield response;
  }
}
