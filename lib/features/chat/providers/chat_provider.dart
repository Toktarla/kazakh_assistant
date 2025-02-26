import 'package:flutter/material.dart';
import 'package:proj_management_project/features/chat/repositories/chat_repository.dart';

class ChatProvider with ChangeNotifier {
  final ChatRepository _chatRepository;
  String? currentChatId;

  ChatProvider(this._chatRepository);

  Stream<List<Map<String, dynamic>>>? get messages =>
      currentChatId != null
          ? _chatRepository.fetchMessages(currentChatId!)
          : null;

  Future<void> selectChat(String chatId) async {
    currentChatId = chatId;
    notifyListeners();
  }

  Future<void> startNewChat() async {
    currentChatId = await _chatRepository.createChat();
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    if (currentChatId == null) return;
    _chatRepository.saveMessage(
        chatId: currentChatId ?? "Chat1",
        message: message
    );
  }

  Future<List<Map<String, dynamic>>> fetchChats() async {
    return await _chatRepository.fetchChats();
  }
}