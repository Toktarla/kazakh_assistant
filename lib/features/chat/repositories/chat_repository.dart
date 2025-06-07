import 'package:proj_management_project/services/remote/firestore_service.dart';
import '../../../services/remote/kazakh_learning_api.dart';

class ChatRepository {
  final FirestoreService _firestoreService;
  final KazakhLearningApi _api;

  ChatRepository(this._firestoreService, this._api);

  Future<String> createChat() async {
    return await _firestoreService.createChat();
  }

  Future<void> saveMessage({
    required String chatId,
    required String userId,
    required String message,
    required String targetLanguage,
  }) async {
    // Save user message
    await _firestoreService.saveMessage(
      chatId: chatId,
      message: message,
      sender: "user",
    );

    String? aiResponse = await getAiResponse(
        message, targetLanguage
    );

    if (aiResponse != null && aiResponse.trim().isEmpty) {
      // AI didn't respond, delete chat so it doesn't show up in history
      await _firestoreService.deleteChat(chatId, userId);
      return; // stop further processing
    }

    // Save AI response
    await _firestoreService.saveMessage(
      chatId: chatId,
      message: aiResponse ?? "",
      sender: 'ai',
    );
  }


  Stream<List<Map<String, dynamic>>> fetchMessages(String chatId) {
    return _firestoreService.fetchMessages(chatId);
  }

  Future<List<Map<String, dynamic>>> fetchChats() async {
    return await _firestoreService.fetchChats();
  }

  Future<String?> getAiResponse(String message, String targetLanguage) async {
    final response =  await _api.sendMessage(message: message, targetLanguage: targetLanguage);
    // Assuming response is a List<Map<String, dynamic>>
    if (response is List && response.isNotEmpty) {
      final item = response.first;
      if (item is Map<String, dynamic>) {
        return item['response'] as String?;
      }
    }

    return "⚠️ Жауап алынбады.";
  }

  Future<void> renameChat(String chatId, String newTitle) async {
    await _firestoreService.renameChat(chatId, newTitle);
  }

  Future<void> deleteChat(String chatId, String userId) {
    return _firestoreService.deleteChat(chatId, userId);
  }
}

