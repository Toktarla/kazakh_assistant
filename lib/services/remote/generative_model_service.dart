import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../config/variables.dart';

class GenerativeChatService with ChangeNotifier {
  late final GenerativeModel model;
  late final ChatSession chat;

  GenerativeChatService() {
    final apiKey = geminiApiKey!;
    print(geminiApiKey);
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    chat = model.startChat();
  }

  Future<String> sendMessage(String message) async {
    var content = Content.text(message);
    var response = await chat.sendMessage(content);
    return response.text!;
  }
}
