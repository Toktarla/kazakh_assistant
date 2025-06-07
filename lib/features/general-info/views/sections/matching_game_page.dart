import 'package:flutter/material.dart';

class MatchingGamePage extends StatelessWidget {
  const MatchingGamePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Matching Game')),
    body: const Center(child: Text('Matching Game Exercise')),
  );
}