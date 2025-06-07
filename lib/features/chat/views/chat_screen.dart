import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proj_management_project/config/app_colors.dart';
import 'package:proj_management_project/features/chat/providers/chat_provider.dart';
import 'package:proj_management_project/features/general-info/models/app_language.dart';
import '../../../utils/helpers/stt_caution_dialog.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import '../../../config/di/injection_container.dart';
import '../../../utils/widgets/blinking_dot.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  final ChatProvider chatViewModel = sl<ChatProvider>();
  bool _isSending = false;
  bool _isGeneratingResponse = false;
  bool _showScrollToBottom = false;
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initializeChatScreen();
  }

  Future<void> _initializeChatScreen() async {
    _speech = stt.SpeechToText();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().selectChat(widget.chatId);
    });

    _scrollController.addListener(() {
      if (_scrollController.offset <
          _scrollController.position.maxScrollExtent - 100) {
        setState(() => _showScrollToBottom = true);
      } else {
        setState(() => _showScrollToBottom = false);
      }
    });

    await chatViewModel.login(FirebaseAuth.instance.currentUser?.uid ?? "");
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _startListening() async {
    final alreadyShown = await Prefs.isSttDialogShown();
    if (!mounted) return;

    if (!alreadyShown) {
      await SttCautionDialog.show(context);
      await Prefs.setSttDialogShown();
    }

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          setState(() => _isListening = false);
          debugPrint("STT Error: $error");
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _lastWords = '';
        });

        bool heardAnything = false;
        if (!mounted) return;

        // Listen
        _speech.listen(
          localeId: context.sttLocaleId,
          onResult: (val) {
            if (val.recognizedWords.trim().isNotEmpty) {
              heardAnything = true;
            }

            setState(() {
              _lastWords = val.recognizedWords;
              _controller.text = _lastWords;
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length),
              );
            });

            if (val.finalResult) {
              setState(() => _isListening = false);
            }
          },
        );

        // Timeout if no speech in 3 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (!heardAnything && _isListening) {
            _speech.stop();
            setState(() => _isListening = false);
          }
        });
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  void dispose() {
    _speech.stop();
    chatViewModel.logout();
    super.dispose();
  }

  void _speak(String text) async {
    final String locale = context.detectLanguage(text);

    if (locale == "kk-KZ") {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      // Show alert that Kazakh is not supported
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Кешіріңіз"),
          backgroundColor: Theme.of(context).cardColor,
          content: const Text("Қазақ тіліне арналған дауыс қолжетімді емес."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Жабу"),
            ),
          ],
        ),
      );
      return;
    }

    await flutterTts.setLanguage(locale); // e.g., ru-RU or en-US
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0); // Volume range is 0.0 to 1.0
    await flutterTts.speak(text);
  }

  Widget _buildBubble(
      {required String message,
      required bool isUser,
      bool isGenerating = false}) {
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: Radius.circular(isUser ? 24 : 0),
      bottomRight: Radius.circular(isUser ? 0 : 24),
    );

    final bubbleContent = Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.all(14),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(
        color: isUser ? Colors.cyan : AppColors.greyColor,
        borderRadius: borderRadius,
      ),
      child: isGenerating
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(width: 100, height: 16, color: Colors.white),
            )
          : MarkdownBody(
              data: message,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: TextStyle(
                    fontSize: 15,
                    color: isUser ? Colors.white : Colors.black87),
                code: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                codeblockPadding: const EdgeInsets.all(8),
                codeblockDecoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                listBullet:
                    TextStyle(color: isUser ? Colors.white : Colors.black87),
                h1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
    );
    final bubble = GestureDetector(
      onLongPress: () => _handleLongPress(message, isUser),
      child: bubbleContent,
    );
    if (isUser) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 4, top: 8),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.beautifulWhiteColor,
              backgroundImage: AssetImage('assets/images/app-logo.png'),
            ),
          ),
          Expanded(child: bubble),
        ],
      );
    }
  }

  Widget _buildAiFastCommandChips(ChatProvider chatViewModel) {
    final List<Map<String, dynamic>> aiCommands = [
      {
        'label': 'Progress'.tr(),
        'command': 'progress',
        'method': chatViewModel.api.getProgress,
        'textKey': 'progress_text'
      },
      {
        'label': 'Recommendations'.tr(),
        'command': 'recommendations',
        'method': chatViewModel.api.getRecommendations,
        'textKey': 'recommendations_text'
      },
      {
        'label': 'Review words'.tr(),
        'command': 'review words',
        'method': chatViewModel.api.getReviewWords,
        'textKey': 'review_text'
      },
      {
        'label': 'Mastered words'.tr(),
        'command': 'mastered words',
        'method': chatViewModel.api.getMasteredWords,
        'textKey': 'mastered_text'
      },
    ];

    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: aiCommands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cmd = aiCommands[index];

          return ActionChip(
            label: Text(
              cmd['label']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColorDark,
            onPressed: () async {
              if (_isSending || _isGeneratingResponse) return;

              try {
                // Call the method (API call)
                final result = await Function.apply(cmd['method'], []);

                // Extract first map if result is list
                final Map<String, dynamic>? data =
                (result is List && result.isNotEmpty) ? result[0] : null;

                if (data != null) {
                  final String? displayText = data[cmd['textKey']]?.toString();

                  if (displayText != null && displayText.isNotEmpty) {
                    if (!context.mounted) return;

                    // Show dialog with the response text
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(context).cardColor,
                        title: Text(cmd['label']!),
                        content: MarkdownBody(
                          data: displayText,
                          styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                            p: TextStyle(
                                fontSize: 15,
                                color: Colors.black87),
                            code: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            codeblockPadding: const EdgeInsets.all(8),
                            codeblockDecoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            listBullet:
                            TextStyle(color: Colors.black87),
                            h1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                      ),
                    ));
                  } else {
                    print("⚠️ No text found for command ${cmd['command']}");
                  }
                } else {
                  print("⚠️ No data received for command ${cmd['command']}");
                }
              } catch (e) {
                print("❌ Error handling command '${cmd['command']}': $e");
              }

              if (mounted) {
                setState(() {
                  _isGeneratingResponse = false;
                });
              }
            },
          );
        },
      ),
    );
  }


  void _handleLongPress(String message, bool isUser) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy').tr(),
            onTap: () {
              Clipboard.setData(ClipboardData(text: message));
              Navigator.pop(context);
            },
          ),
          if (isUser)
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit').tr(),
              onTap: () {
                Navigator.pop(context);
                _controller.text = message;
              },
            ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Select Text').tr(),
            onTap: () {
              Navigator.pop(context);
              _showSelectTextSheet(message);
            },
          ),
          if (true) // !isUser
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Read Aloud').tr(),
              onTap: () {
                Navigator.pop(context);
                _speak(message);
              },
            )
        ],
      ),
    );
  }

  void _showSelectTextSheet(String message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 1,
        maxChildSize: 1,
        minChildSize: 1,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Select Text'.tr(),
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SelectableText(message,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chat',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))
            .tr(),
      ),
      body: Column(
        children: [
          _buildAiFastCommandChips(chatViewModel),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: chatViewModel.messages,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                if (messages.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).iconTheme.color!,
                            BlendMode.srcIn),
                        child: Image.asset(
                          'assets/images/app-logo.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                      Text('Hi, I am KazSpark. How can I help you today?'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ],
                  );
                }

                return Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          messages.length + (_isGeneratingResponse ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isGeneratingResponse && index == messages.length) {
                          // Show typing indicator
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 14),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                      AppColors.beautifulWhiteColor,
                                  backgroundImage:
                                      AssetImage('assets/images/app-logo.png'),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.greyColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: BlinkingDot(),
                                ),
                              ],
                            ),
                          );
                        }

                        final message = messages[index];
                        final isUser = message['sender'] == 'user';
                        return _buildBubble(
                          message: message['message'],
                          isUser: isUser,
                          isGenerating: message['isGenerating'] == true,
                        );
                      },
                    ),
                    if (_showScrollToBottom)
                      Positioned(
                        right: 16,
                        bottom: 8,
                        child: FloatingActionButton.small(
                          onPressed: _scrollToBottom,
                          child: const Icon(Icons.arrow_downward),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (_isListening)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BlinkingDot(),
                      ),
                      const Text(
                        'Listening...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 5, // or any suitable max
                  decoration: InputDecoration(
                    hintText: 'Type your message...'.tr(),
                    filled: true,
                    fillColor: Theme.of(context).primaryColorLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.build, size: 20),
                                SizedBox(width: 4),
                                Text('Tools'),
                              ],
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'learning_words',
                                child: Row(
                                  children: [
                                    Icon(Icons.menu_book, size: 20),
                                    SizedBox(width: 8),
                                    Text('Learning Words'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'new_words',
                                child: Row(
                                  children: [
                                    Icon(Icons.fiber_new, size: 20),
                                    SizedBox(width: 8),
                                    Text('New Words'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'new_idioms',
                                child: Row(
                                  children: [
                                    Icon(Icons.lightbulb_outline, size: 20),
                                    SizedBox(width: 8),
                                    Text('New Idioms'),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == 'learning_words') {
                                chatViewModel.fetchLearningWords();
                              } else if (value == 'new_words') {
                                chatViewModel.fetchNewWords();
                              } else if (value == 'new_idioms') {
                                chatViewModel.fetchNewIdioms();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                      color: _isListening
                          ? Colors.red
                          : Theme.of(context).iconTheme.color,
                      onPressed: _startListening,
                    ),
                    IconButton(
                      icon: _isSending
                          ? CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      )
                          : Icon(Icons.send, color: Theme.of(context).iconTheme.color),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          setState(() {
                            _isSending = true;
                            _isGeneratingResponse = true;
                          });
                          final message = _controller.text;
                          _controller.clear();  // Clear input immediately

                          chatViewModel.sendMessage(
                            message,
                            FirebaseAuth.instance.currentUser?.uid ?? "",
                            targetLanguage: context.getTargetLanguage(context),
                          ).then((_) {
                            setState(() {
                              _isSending = false;
                              _isGeneratingResponse = false;
                              _scrollToBottom();
                            });
                          });
                          _scrollToBottom();
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
