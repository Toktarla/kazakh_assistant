import 'package:flutter/material.dart';
import 'package:proj_management_project/features/chat/repositories/chat_repository.dart';

import '../../../services/remote/kazakh_learning_api.dart';

class ChatProvider with ChangeNotifier {
  final ChatRepository _chatRepository;
  final KazakhLearningApi api;
  String? currentChatId;

  ChatProvider(this._chatRepository, this.api);

  Stream<List<Map<String, dynamic>>>? get messages =>
      currentChatId != null ? _chatRepository.fetchMessages(currentChatId!) : null;

  Future<void> selectChat(String chatId) async {
    currentChatId = chatId;
    notifyListeners();
  }

  Future<void> startNewChat() async {
    currentChatId = await _chatRepository.createChat();
    notifyListeners();
  }

  Future fetchProgress() => api.getProgress();
  Future fetchLearningWords() => api.getLearningWords();
  Future fetchNewIdioms() => api.getNewIdioms();
  Future fetchNewWords() => api.getNewWords();
  Future fetchRecommendations() => api.getRecommendations();
  Future fetchReviewWords() => api.getReviewWords();
  Future fetchMasteredWords() => api.getMasteredWords();


  Future<void> sendMessageAnonymously(String message, String userId, {String targetLanguage = 'English'}) async {
    if (currentChatId == null || message.trim().isEmpty) return;

    final response = await api.sendMessage(
      message: message,
      targetLanguage: targetLanguage,
    );
  }

  Future<void> sendMessage(String message, String userId, {String targetLanguage = 'English'}) async {
    if (currentChatId == null || message.trim().isEmpty) return;

    // Save user message
    await _chatRepository.saveMessage(
      chatId: currentChatId!,
      userId: userId,
      message: message,
      targetLanguage: targetLanguage,
    );

    notifyListeners();
  }

  Future<bool> login(String userId) async {
    final success = await api.login(userId);
    notifyListeners();
    return success;
  }

  void logout() {
    api.logout();
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchChats() async {
    return await _chatRepository.fetchChats();
  }

  Future<String?> fetchFirstUserMessage(String chatId) async {
    final messages = await _chatRepository.fetchMessages(chatId).first;
    return messages.firstWhere(
          (msg) => msg['sender'] == 'user',
      orElse: () => {},
    )['message'];
  }

  Future<void> renameChat(String chatId, String newTitle) async {
    await _chatRepository.renameChat(chatId, newTitle);
    notifyListeners();
  }

  Future<void> deleteChat(String chatId, String userId) async {
    try {
      await _chatRepository.deleteChat(chatId, userId);
      notifyListeners();
    } catch (e) {
      print('Error deleting chat: $e');
    }
  }
}
