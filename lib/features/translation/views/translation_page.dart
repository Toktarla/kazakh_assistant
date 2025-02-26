import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final _translator = GoogleTranslator();
  final _inputTextController = TextEditingController();
  final _outputTextController = TextEditingController();
  String _inputLanguage = 'auto';
  String _outputLanguage = 'kk';

  Future<void> _translate() async {
    try {
      String textToTranslate = _inputTextController.text.trim();
      if (textToTranslate.isEmpty) {
        _outputTextController.text = '';
        setState(() {});
        return;
      }
      if (_inputLanguage == 'auto') {
        final translation =
        await _translator.translate(textToTranslate, to: _outputLanguage);
        setState(() {
          _outputTextController.text = translation.text;
        });
      } else {
        final translation = await _translator.translate(textToTranslate,
            from: _inputLanguage, to: _outputLanguage);
        setState(() {
          _outputTextController.text = translation.text;
        });
      }
    } catch (e) {
      setState(() {
        _outputTextController.text = 'Error: $e';
      });
    }
  }

  void _swapLanguages() {
    setState(() {
      String temp = _inputLanguage;
      _inputLanguage = _outputLanguage;
      _outputLanguage = temp;
      if (_outputLanguage == 'auto') {
        _outputLanguage = 'kk';
      }
      _translate();
    });
  }

  @override
  void dispose() {
    _inputTextController.dispose();
    _outputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButton<String>(
                      value: _inputLanguage,
                      items: <String>['auto', 'en', 'ru', 'kk'].map((String value) {
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                            child: Text(displayText, style: Theme.of(context).textTheme.titleMedium,),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _inputLanguage = value!;
                          _translate();
                        });
                      },
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      style: const TextStyle(fontSize: 16),
                      dropdownColor: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.swap_horiz_rounded, color: Theme.of(context).iconTheme.color, size: 40,),
                    onPressed: _swapLanguages,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButton<String>(
                      value: _outputLanguage,
                      items: <String>['kk', 'ru', 'en'].map((String value) {
                        String displayText;
                        switch (value) {
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                            child: Text(displayText, style: Theme.of(context).textTheme.titleMedium,),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _outputLanguage = value!;
                          _translate();
                        });
                      },
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      style: const TextStyle(fontSize: 16),
                      dropdownColor: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.mic, color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      // Implement STT functionality here
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _inputTextController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        _translate();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      // Implement TTS functionality here
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _outputTextController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}