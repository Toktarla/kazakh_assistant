import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/features/chat/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat History',
        ).tr(),
        elevation: 5,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
            color: Colors.white,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: chatViewModel.fetchChats().asStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No chats yet'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.deepOrangeAccent,
                        ),
                      ).animate().fadeIn(duration: 800.ms).slideY(),
                    );
                  }
                  final chats = snapshot.data!;
                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(5, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20),
                          title: Text(
                            chat['title'],
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "Tap to continue",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ).tr(),
                          onTap: () {
                            Navigator.pushNamed(context, '/Chat', arguments: {
                              "chatId": chat['title'],
                            });
                          },
                        ),
                      ).animate().scale(
                        duration: 400.ms,
                        curve: Curves.easeInOut,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // New Chat Button with more styling and animation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  await chatViewModel.startNewChat();
                  Navigator.pushNamed(context, '/Chat', arguments: {
                    "chatId": chatViewModel.currentChatId,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shadowColor: Colors.deepOrangeAccent.withOpacity(0.6),
                  elevation: 15,
                ),
                child: Text(
                  'New Chat',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ).tr(),
              ).animate().fadeIn(duration: 500.ms).scale(),
            ),
          ),
        ],
      ),
    );
  }
}
