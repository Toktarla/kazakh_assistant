import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proj_management_project/config/load_json_data.dart';
import 'package:proj_management_project/features/general-info/models/fill_in_the_blank.dart';

class FillInTheBlankPage extends StatefulWidget {
  final String level;

  const FillInTheBlankPage({super.key, this.level = "Intermediate"});

  @override
  State<FillInTheBlankPage> createState() => _FillInTheBlankPageState();
}

class _FillInTheBlankPageState extends State<FillInTheBlankPage> {
  late List<FillInTheBlank> _exercises;
  int _currentIndex = 0;
  final TextEditingController _controller = TextEditingController();

  bool? _isCorrect;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() {
    _exercises = fillInTheBlankBox
        .getAll()
        .where((e) => e.level == widget.level)
        .toList();

    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No exercises found")),
      );
    }
  }

  void _checkAnswer() {
    final current = _exercises[_currentIndex];
    final locale = context.locale.languageCode;
    final userAnswer = _controller.text.trim().toLowerCase();
    final correctAnswer = _getLocalizedAnswer(current, locale).trim().toLowerCase();

    setState(() {
      _isCorrect = userAnswer == correctAnswer;
    });
  }

  void _next() {
    setState(() {
      _currentIndex++;
      _controller.clear();
      _isCorrect = null;
    });
  }

  String _getLocalizedAnswer(FillInTheBlank item, String locale) {
    return locale == 'kk'
        ? item.answerKk
        : locale == 'ru'
        ? item.answerRu
        : item.answerEn;
  }

  String _getLocalizedText(String kk, String ru, String en) {
    final locale = context.locale.languageCode;
    return locale == 'kk'
        ? kk
        : locale == 'ru'
        ? ru
        : en;
  }

  @override
  Widget build(BuildContext context) {
    if (_exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Fill in the Blank")),
        body: const Center(child: Text("No exercises available")),
      );
    }

    if (_currentIndex >= _exercises.length) {
      return Scaffold(
        appBar: AppBar(title: const Text("Fill in the Blank")),
        body: const Center(child: Text("🎉 Finished!")),
      );
    }

    final current = _exercises[_currentIndex];

    final textBefore = _getLocalizedText(current.textBeforeKk, current.textBeforeRu, current.textBeforeEn);
    final textAfter = _getLocalizedText(current.textAfterKk, current.textAfterRu, current.textAfterEn);

    return Scaffold(
      appBar: AppBar(title: const Text("Fill in the Blank")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(text: "$textBefore "),
                const WidgetSpan(
                  child: Icon(Icons.edit, size: 18),
                ),
                TextSpan(text: " $textAfter"),
              ]),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Your answer",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (_isCorrect != null)
              Text(
                _isCorrect! ? "✅ Correct!" : "❌ Incorrect. Try again.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _isCorrect! ? Colors.green : Colors.red,
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isCorrect == null ? _checkAnswer : _next,
              child: Text(_isCorrect == null ? "Check" : "Next"),
            ),
          ],
        ),
      ),
    );
  }
}
