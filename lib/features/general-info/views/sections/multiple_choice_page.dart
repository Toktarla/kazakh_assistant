import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../services/local/ranking_service.dart';
import '../../../home/views/home_page.dart';

class MultipleChoicePage extends StatefulWidget {
  final List<MultipleChoiceItem> items;
  final String title;

  const MultipleChoicePage({super.key, required this.title, required this.items});

  @override
  State<MultipleChoicePage> createState() => _MultipleChoicePageState();
}

class _MultipleChoicePageState extends State<MultipleChoicePage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  int? selectedIndex;
  bool isAnswered = false;
  int score = 0;

  late ConfettiController _confettiController;
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void selectOption(int index) {
    if (isAnswered) return;

    setState(() {
      selectedIndex = index;
      isAnswered = true;
    });

    final isCorrect = index == widget.items[currentIndex].correctIndex;
    if (isCorrect) score++;

    Future.delayed(const Duration(seconds: 1), () async {
      if (currentIndex + 1 < widget.items.length) {
        setState(() {
          currentIndex++;
          selectedIndex = null;
          isAnswered = false;
          _controller.reset();
          _controller.forward();
        });
      } else {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _buildResultDialog(),
        );
        await RankingService.addProgress(widget.items.length * 5);
      }
    });
  }

  AlertDialog _buildResultDialog() {
    final total = widget.items.length;

    _confettiController.play();

    return AlertDialog(

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Quiz Completed'.tr()),
      content: Text(
        'you_got_x_out_of_y_correct'
            .tr(namedArgs: {'score': '$score', 'total': '$total'}),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              currentIndex = 0;
              selectedIndex = null;
              isAnswered = false;
              score = 0;
              _controller.forward(from: 0);
            });
          },
          child: Text('Restart'.tr(), style: Theme.of(context).textTheme.titleMedium,),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          },
          child: Text('Close'.tr(), style: Theme.of(context).textTheme.titleMedium),
        ),
      ],
    );
  }

  Color _getOptionColor(int index) {
    if (!isAnswered) return Theme.of(context).scaffoldBackgroundColor;
    final correctColor = Theme.of(context).brightness == Brightness.light ? Colors.green.shade100 : Colors.green.shade700;
    final incorrectColor = Theme.of(context).brightness == Brightness.light ? Colors.red.shade100 : Colors.red.shade700;

    if (index == widget.items[currentIndex].correctIndex) return correctColor;
    if (index == selectedIndex) return incorrectColor;
    return Theme.of(context).scaffoldBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.items[currentIndex];
    final total = widget.items.length;
    final progress = (currentIndex + 1) / total;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(widget.title, style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 14,
              fontWeight: FontWeight.bold
            ),
            maxLines: 2,
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: FadeTransition(
            opacity: _fadeIn,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blueAccent,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 24),
                  _buildQuestionCard(item),
                  const SizedBox(height: 24),
                  ...List.generate(
                    item.options.length,
                        (i) => _buildOptionTile(item.options[i], i),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.red, Colors.blue, Colors.green, Colors.orange],
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(MultipleChoiceItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        item.question,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildOptionTile(String option, int index) {
    return GestureDetector(
      onTap: () => selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _getOptionColor(index),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: selectedIndex == index ? Colors.blueAccent : Colors.grey.shade300,
              child: Text(
                String.fromCharCode(65 + index), // A, B, C, ...
                style: TextStyle(color: selectedIndex == index ? Colors.white : Colors.black, fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultipleChoiceItem {
  final String question;
  final List<String> options;
  final int correctIndex;

  MultipleChoiceItem({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

