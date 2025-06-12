import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import '../../../services/local/internet_checker.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final _translator = GoogleTranslator();
  final _inputTextController = TextEditingController();
  final _outputTextController = TextEditingController();
  Timer? _debounce;
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  String _inputLanguage = 'auto';
  String _outputLanguage = 'kk';
  bool _isListening = false;

  // Add a boolean to track if the TTS engine is ready and languages are supported
  bool _ttsReady = false;

  @override
  void initState() {
    super.initState();
    _inputTextController.addListener(_onInputChanged);
    _initTts(); // Initialize TTS here
  }

  Future<void> _initTts() async {
    // Optional: You can check for available languages here
    // List<dynamic> languages = await _flutterTts.getLanguages;
    // print('Available TTS languages: $languages');
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setLanguage(_outputLanguage); // Set initial language
    _ttsReady = true; // Mark TTS as ready
    setState(() {}); // Rebuild to enable TTS button if needed
  }

  void _onInputChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _translate();
    });
  }

  @override
  void dispose() {
    _inputTextController.removeListener(_onInputChanged); // Corrected to _onInputChanged
    _inputTextController.dispose();
    _outputTextController.dispose();
    _flutterTts.stop();
    _debounce?.cancel();
    _speechToText.stop(); // Ensure speech recognition is stopped
    super.dispose();
  }

  Future<void> _translate() async {
    // Only attempt translation if internet is available
    if (!InternetChecker().hasInternet) {
      _outputTextController.text = 'No Internet Connection'.tr();
      return;
    }

    final textToTranslate = _inputTextController.text.trim();
    if (textToTranslate.isEmpty) {
      _outputTextController.text = '';
      return;
    }

    try {
      final translation = _inputLanguage == 'auto'
          ? await _translator.translate(textToTranslate, to: _outputLanguage)
          : await _translator.translate(textToTranslate, from: _inputLanguage, to: _outputLanguage);

      _outputTextController.text = translation.text;
    } catch (e) {
      print('Translation Error: $e');
    }
  }

  void _swapLanguages() {
    setState(() {
      final temp = _inputLanguage;
      _inputLanguage = _outputLanguage;
      // If input was 'auto', set a default for output language after swap (e.g., 'en')
      // Otherwise, the `kk` default might overwrite a user's chosen language.
      _outputLanguage = (temp == 'auto' || temp == 'kk') ? 'en' : temp; // Better default after swap
      _inputTextController.text = _outputTextController.text; // Swap text too
      _outputTextController.text = ''; // Clear output for new translation
    });
    _translate(); // Retranslate with swapped languages
  }

  Future<void> _speakText(String text, String langCode) async {
    if (!_ttsReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('TTS not ready.'.tr())),
      );
      return;
    }
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No text to speak.'.tr())),
      );
      return;
    }
    // Check if the language is supported by TTS
    final supportedLanguages = await _flutterTts.getLanguages;
    if (supportedLanguages != null && !supportedLanguages.contains(langCode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('TTS not supported for $_outputLanguage.'.tr()),
          backgroundColor: Colors.orange,
        ),
      );
      print('TTS language $_outputLanguage not supported. Available: $supportedLanguages');
      return;
    }

    await _flutterTts.setLanguage(langCode);
    await _flutterTts.setPitch(1.0); // Reset pitch to default
    await _flutterTts.setSpeechRate(0.5); // Adjust speech rate if needed
    await _flutterTts.speak(text);
  }

  Future<void> _listen() async {
    // Only attempt listening if internet is available
    if (!InternetChecker().hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Speech recognition requires internet.'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print('Speech recognition status: $status'),
        onError: (error) => print('Speech recognition error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        await _speechToText.listen(
          localeId: _getLocaleId(_inputLanguage),
          onResult: (result) {
            _inputTextController.text = result.recognizedWords;
            if (result.finalResult) {
              setState(() => _isListening = false);
              _translate(); // Trigger translation after final result
            }
          },
          listenFor: const Duration(seconds: 30), // Max listening duration
          pauseFor: const Duration(seconds: 3), // Pause before ending
          partialResults: true, // Get partial results
        );
      } else {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Speech recognition not available.'.tr()),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      await _speechToText.stop();
      setState(() => _isListening = false);
    }
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard'.tr())), // More descriptive text
    );
  }

  String _getLocaleId(String lang) {
    // Ensure these match your `speech_to_text` supported locales
    switch (lang) {
      case 'kk':
        return 'kk_KZ'; // Example for Kazakh, verify with speech_to_text docs
      case 'ru':
        return 'ru_RU';
      case 'en':
        return 'en_US';
      default:
        return 'en_US'; // default fallback for auto-detect or unsupported
    }
  }

  Widget _buildTextSection({
    required String label,
    required TextEditingController controller,
    required bool isOutput,
    required VoidCallback onTTS,
    required VoidCallback onCopy,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            // Conditionally enable/disable mic/TTS button based on internet or _isListening state
            IconButton(
              icon: Icon(
                  isOutput
                      ? Icons.volume_up
                      : (_isListening ? Icons.mic_off : Icons.mic), // Mic off when listening
                  color: isOutput || InternetChecker().hasInternet
                      ? Theme.of(context).iconTheme.color
                      : Colors.grey), // Grey out if no internet for mic
              onPressed: (isOutput && _ttsReady) // TTS button depends on TTS readiness
                  ? onTTS
                  : (isOutput ? null : _listen), // Disable mic if not listening and no internet
            ),
            Flexible(
              child: SelectableTextField(
                controller: controller,
                hintText: isOutput ? '' : 'Enter Text'.tr(),
                readOnly: isOutput,
                maxLines: 6,
                onCopy: onCopy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLanguageDropdown(bool isInput) {
    final options = isInput ? ['auto', 'en', 'ru', 'kk'] : ['kk', 'ru', 'en'];
    final value = isInput ? _inputLanguage : _outputLanguage;

    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            items: options.map((String value) {
              String displayText;
              switch (value) {
                case 'auto':
                  displayText = 'Auto-detect'.tr();
                  break;
                case 'en':
                  displayText = 'English'.tr();
                  break;
                case 'ru':
                  displayText = 'Russian'.tr();
                  break;
                case 'kk':
                  displayText = 'Kazakh'.tr();
                  break;
                default:
                  displayText = value;
              }
              return DropdownMenuItem<String>(
                value: value,
                child: Text(displayText,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium),
              );
            }).toList(),
            onChanged: (newLang) {
              setState(() {
                if (isInput) {
                  _inputLanguage = newLang!;
                } else {
                  _outputLanguage = newLang!;
                }
              });
              _translate();
            },
            icon: const Icon(Icons.arrow_drop_down_rounded),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Translation'.tr())),
      body: StreamBuilder<bool>(
        stream: InternetChecker().internetStream,
        initialData: InternetChecker().hasInternet, // Provide initial data
        builder: (context, snapshot) {
          final bool hasInternet = snapshot.data ?? true; // Default to true if snapshot.data is null

          if (!hasInternet) {
            // Show no internet message
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 80,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Internet Connection'.tr(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please connect to the internet to use translation services.'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            // Show translation UI
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _buildLanguageDropdown(true),
                        IconButton(
                          icon: const Icon(Icons.swap_horiz_rounded, size: 40),
                          onPressed: _swapLanguages,
                        ),
                        _buildLanguageDropdown(false),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildTextSection(
                      label: 'Input',
                      controller: _inputTextController,
                      isOutput: false,
                      onTTS: () {}, // Not used for input text, but required by signature
                      onCopy: () => _copyText(_inputTextController.text),
                    ),
                    _buildTextSection(
                      label: 'Output',
                      controller: _outputTextController,
                      isOutput: true,
                      onTTS: () => _speakText(_outputTextController.text, _outputLanguage),
                      onCopy: () => _copyText(_outputTextController.text),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

/// Custom Selectable TextField Widget
class SelectableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool readOnly;
  final int maxLines;
  final VoidCallback? onCopy;

  const SelectableTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.readOnly,
    this.maxLines = 4,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      enableInteractiveSelection: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        suffixIcon: onCopy != null
            ? IconButton(
          icon: const Icon(Icons.copy),
          onPressed: onCopy,
        )
            : null,
      ),
    );
  }
}