import 'package:flutter/material.dart';
import 'package:proj_management_project/config/app_colors.dart';

class IntroButton extends StatelessWidget {
  final String text;
  const IntroButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(text, style: Theme.of(context).textTheme.displayMedium,))),
    );
  }
}
