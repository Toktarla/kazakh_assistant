import 'package:flutter/material.dart';

class BeautifulWordsWidget extends StatefulWidget {
  final List<dynamic> beautifulWords;

  const BeautifulWordsWidget({Key? key, required this.beautifulWords}) : super(key: key);

  @override
  _BeautifulWordsWidgetState createState() => _BeautifulWordsWidgetState();
}

class _BeautifulWordsWidgetState extends State<BeautifulWordsWidget> {
  List<bool> _isCardFlipped = [];

  @override
  void initState() {
    super.initState();
    _isCardFlipped = List.generate(widget.beautifulWords.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.8,
        ),
        itemCount: widget.beautifulWords.length,
        itemBuilder: (context, index) {
          final wordData = widget.beautifulWords[index];
          return _buildWordCard(context, wordData, index);
        },
      ),
    );
  }

  Widget _buildWordCard(BuildContext context, dynamic wordData, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isCardFlipped[index] = !_isCardFlipped[index];
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: _isCardFlipped[index]
            ? _buildCardBack(context, wordData, index)
            : _buildCardFront(context, wordData, index),
      ),
    );
  }

  Widget _buildCardFront(BuildContext context, dynamic wordData, int index) {
    return Card(
      key: const ValueKey<bool>(true),
      color: Theme.of(context).primaryColorLight,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                wordData['word'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Icon(Icons.flip_camera_android, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack(BuildContext context, dynamic wordData, int index) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      key: const ValueKey<bool>(false),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Etymology", wordData['etymology']),
                    _buildDetailRow("Examples", wordData['examples'].join(', ')),
                    _buildDetailRow("Usage", wordData['writingExample']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value),
        ],
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: 3.14, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final value = animation.value;
        var tilt = ((1 - value) * 0.003).clamp(-0.003, 0.003);
        return Transform(
          transform: Matrix4.rotationY(rotateAnim.value).scaled(value, value > 0 ? value : 0.001)
            ..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}