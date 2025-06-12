import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:proj_management_project/features/chat/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_colors.dart';
import '../../../services/local/internet_checker.dart';
import '../../../utils/helpers/delete_confirmation_dialog.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatProvider>(context);

    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat History',
          ).tr(),
          elevation: 0,
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (FirebaseAuth.instance.currentUser?.isAnonymous ?? false) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.orange),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'You are using the app anonymously. Sign in with email to save your chat history.',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.orange[800]),
                                ).tr(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No chats yet'.tr(),
                          style: Theme.of(context).textTheme.titleLarge
                        ).animate().fadeIn(duration: 800.ms).slideY(),
                      );
                    }
                    final chats = snapshot.data!;
                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        final chatTitle = chat['title'];
                        final chatCreatedAt = chat['createdAt'];
                        final chatId = chat['chatId'];

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).cardColor,
                                  Theme.of(context).scaffoldBackgroundColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
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
                              chatTitle,
                              style: Theme.of(context).textTheme.titleLarge
                            ),
                            subtitle: Text(
                                DateFormat.yMMMd(context.locale.languageCode)
                                    .add_Hm()
                                    .format((chatCreatedAt).toDate() ?? DateTime.now()),
                                style: Theme.of(context).textTheme.titleSmall),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(LineIcons.trash, color: Theme.of(context).iconTheme.color),
                                    onPressed: () async {
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (context) => DeleteConfirmationDialog(
                                          onDelete: () async {
                                            final userId = FirebaseAuth.instance.currentUser?.uid;
                                            await chatViewModel.deleteChat(chatId, userId ?? "");
                                          },
                                        ),
                                      );
                                    },
                                    tooltip: 'Delete Chat',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, size: 20, color: Theme.of(context).iconTheme.color),
                                    onPressed: () async {
                                      final controller = TextEditingController(text: chatTitle);
                              
                                      final newTitle = await showDialog<String>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Rename Chat').tr(),
                                            content: TextField(
                                              controller: controller,
                                              decoration: InputDecoration(
                                                hintText: 'New title'.tr(),
                                              ),
                                            ),
                                            backgroundColor: Theme.of(context).cardColor,
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancel').tr(),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, controller.text.trim());
                                                },
                                                child: const Text('Rename').tr(),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                              
                                      if (newTitle != null && newTitle.isNotEmpty && newTitle != chatTitle) {
                                        await chatViewModel.renameChat(chatId, newTitle);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/Chat', arguments: {
                                "chatId": chatId,
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
          ],
        ),
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                bool hasInternet = await InternetChecker().checkInternet();

                if (hasInternet) {
                  await chatViewModel.startNewChat();
                  if (chatViewModel.currentChatId != null) {
                    Navigator.pushNamed(context, '/Chat', arguments: {
                      "chatId": chatViewModel.currentChatId,
                    });
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to start a new chat. Please try again.'.tr()),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                } else {
                  // 3. If not connected, show a Snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No internet connection. Please check your network and try again.'.tr()),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating, // Often looks better
                      margin: const EdgeInsets.all(10), // Adds margin
                      duration: const Duration(seconds: 3), // How long it stays
                    ),
                  );
                }

                await chatViewModel.startNewChat();
                Navigator.pushNamed(context, '/Chat', arguments: {
                  "chatId": chatViewModel.currentChatId,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shadowColor:
                    Theme.of(context).primaryColor.withValues(alpha: 0.6),
                elevation: 0,
              ),
              child: const Text(
                'New Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ).tr(),
            ).animate().fadeIn(duration: 500.ms).scale(),
          ),
        ],
      ),
    );
  }
}
