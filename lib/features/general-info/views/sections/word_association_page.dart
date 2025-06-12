import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WordAssociationPage extends StatefulWidget {
  final List<MapEntry<String, String>> wordSynonymPairs;

  const WordAssociationPage({super.key, required this.wordSynonymPairs});

  @override
  State<WordAssociationPage> createState() => _WordAssociationPageState();
}

class _WordAssociationPageState extends State<WordAssociationPage> {
  late List<String> words;
  late List<String> synonyms;
  late List<String> shuffledSynonyms;

  Map<int, int?> matches = {};
  int score = 0;

  @override
  void initState() {
    super.initState();
    words = widget.wordSynonymPairs.map((e) => e.key).toList();
    synonyms = widget.wordSynonymPairs.map((e) => e.value).toList();
    shuffledSynonyms = List<String>.from(synonyms)..shuffle();

    for (var i = 0; i < words.length; i++) {
      matches[i] = null;
    }
  }

  void checkAnswers() {
    int correct = 0;
    for (var i = 0; i < words.length; i++) {
      final selectedIndex = matches[i];
      if (selectedIndex != null && synonyms[i] == shuffledSynonyms[selectedIndex]) {
        correct++;
      }
    }
    setState(() => score = correct);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Completed"),
        content: Text("You got $score out of ${words.length} correct!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  void resetQuiz() {
    setState(() {
      shuffledSynonyms.shuffle();
      matches.updateAll((key, value) => null);
      score = 0;
    });
  }

  Color _colorForMatch(int wordIndex, int synonymIndex) {
    // Use a fixed set of colors to assign for matched pairs (loop colors if more than available)
    const matchColors = [
      Color(0xFFa8dadc),
      Color(0xFF457b9d),
      Color(0xFF1d3557),
      Color(0xFFf1faee),
      Color(0xFFe63946),
      Color(0xFFf4a261),
      Color(0xFF2a9d8f),
    ];

    if (matches[wordIndex] == synonymIndex) {
      return matchColors[wordIndex % matchColors.length];
    }
    return Colors.blueAccent.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Word Association")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: score / words.length,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              "Match each word with its synonym",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ).tr(),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                children: [
                  // Left: Words
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(words.length, (i) {
                        final matchedSynonymIndex = matches[i];
                        return Draggable<int>(
                          data: i,
                          feedback: _dragBubble(
                            words[i],
                            backgroundColor: matchedSynonymIndex != null
                                ? _colorForMatch(i, matchedSynonymIndex)
                                : null,
                          ),
                          childWhenDragging: _dragBubble(words[i], dimmed: true),
                          child: _dragBubble(
                            words[i],
                            backgroundColor: matchedSynonymIndex != null
                                ? _colorForMatch(i, matchedSynonymIndex)
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                  // Center: Divider
                  const VerticalDivider(width: 1),
                  // Right: Drop Targets (shuffled synonyms)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(shuffledSynonyms.length, (j) {
                        final matchedWordIndex = matches.entries.firstWhere(
                              (entry) => entry.value == j,
                          orElse: () => const MapEntry(-1, null),
                        ).key;

                        return DragTarget<int>(
                          builder: (context, candidateData, rejectedData) {
                            return _dragBubble(
                              shuffledSynonyms[j],
                              backgroundColor:
                              matchedWordIndex != -1 ? _colorForMatch(matchedWordIndex, j) : null,
                              highlight: matchedWordIndex != -1,
                            );
                          },
                          onAccept: (fromIndex) {
                            setState(() {
                              // Remove existing matches of this synonym index
                              matches.updateAll((k, v) => v == j ? null : v);
                              matches[fromIndex] = j;
                            });
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Styled Reset Button
                ElevatedButton.icon(
                  onPressed: resetQuiz,
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    elevation: 4,
                    shadowColor: Colors.redAccent.shade200,
                  ),
                ),

                // Styled Check Button
                ElevatedButton.icon(
                  onPressed: checkAnswers,
                  icon: const Icon(Icons.check_circle, size: 20),
                  label: const Text("Check"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    elevation: 4,
                    shadowColor: Colors.green.shade300,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _dragBubble(String text,
      {bool dimmed = false, bool highlight = false, Color? backgroundColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: highlight
            ? Colors.greenAccent.shade100
            : dimmed
            ? Colors.grey.shade300
            : backgroundColor ?? Colors.blueAccent.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
