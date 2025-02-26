import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/features/chat/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;
  bool _isGeneratingResponse = false; // Track if AI is generating response

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().selectChat(widget.chatId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Chat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ).tr(),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: chatViewModel.messages,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: const CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUserMessage = message['sender'] == 'user';
                    final messageText = message['message'] as String;
                    final isGenerating = message['isGenerating'] == true; // Check if generating

                    return Align(
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                          decoration: BoxDecoration(
                            color: isUserMessage ? Colors.blueAccent : Colors.lightGreen,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: isGenerating
                              ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 150,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                              : MarkdownBody(
                            data: messageText,
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                color: isUserMessage ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                              ),
                              listBullet: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
                              strong: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isUserMessage ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hoverColor: Colors.green,
                      hintText: 'Type your message...'.tr(),
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Theme.of(context).primaryColorLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: _isSending
                      ? const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                  )
                      : const Icon(Icons.send, color: Colors.deepPurpleAccent),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _isSending = true;
                        _isGeneratingResponse = true; // AI is generating response
                      });

                      chatViewModel.sendMessage(_controller.text).then((_) {
                        setState(() {
                          _controller.clear();
                          _isSending = false;
                          _isGeneratingResponse = false; // Response generated
                        });
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}