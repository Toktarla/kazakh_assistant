import 'package:proj_management_project/services/remote/firestore_service.dart';
import 'package:proj_management_project/services/remote/generative_model_service.dart';

class ChatRepository {
  final FirestoreService _firestoreService;
  final GenerativeChatService _generativeChatService;

  ChatRepository(this._firestoreService, this._generativeChatService);

  Future<String> createChat() async {
    return await _firestoreService.createChat();
  }

  Future<void> saveMessage({
    required String chatId,
    required String message,
  }) async {
    // Save user message
    await _firestoreService.saveMessage(
      chatId: chatId,
      message: message,
      sender: "user",
    );

    String aiResponse = await getAiResponse(message);

    // Save AI response
    await _firestoreService.saveMessage(
      chatId: chatId,
      message: aiResponse,
      sender: 'ai',
    );
  }

  Stream<List<Map<String, dynamic>>> fetchMessages(String chatId) {
    return _firestoreService.fetchMessages(chatId);
  }

  Future<List<Map<String, dynamic>>> fetchChats() async {
    return await _firestoreService.fetchChats();
  }

  Future<String> getAiResponse(String message) async {
    return await _generativeChatService.sendMessage(message);
  }
}

