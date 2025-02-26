import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:proj_management_project/features/intro/widgets/intro_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/di/injection_container.dart';

final prefs = sl<SharedPreferences>();

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final GlobalKey<IntroductionScreenState> _introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _onDone() async {
    await prefs.setBool('intro_seen', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/Auth');
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      key: _introKey,
      pages: [
        PageViewModel(
          title: "PageViewTitle1".tr(),
          body: "PageViewBody1".tr(),
          image: Center(child: Lottie.asset("assets/lottie/intro1.json")),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "PageViewTitle2".tr(),
          body: "PageViewBody2".tr(),
          image: Center(child: Lottie.asset("assets/lottie/intro2.json")),
          decoration: _pageDecoration(),
        ),
        PageViewModel(
          title: "PageViewTitle3".tr(),
          body: "PageViewBody3".tr(),
          image: Center(child: Lottie.asset("assets/lottie/intro3.json")),
          decoration: _pageDecoration(),
        ),
      ],
      showNextButton: true,
      showBackButton: true,
      back: IntroButton(text: "Back".tr()),
      next: IntroButton(text: "Next".tr()),
      done: IntroButton(text: "Done".tr()),
      onDone: _onDone,
      dotsDecorator: _dotsDecorator(),
    );
  }

  PageDecoration _pageDecoration() {
    return PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.displayLarge!,
      bodyTextStyle: Theme.of(context).textTheme.displaySmall!,
      contentMargin: const EdgeInsets.all(20),
    );
  }

  DotsDecorator _dotsDecorator() {
    return DotsDecorator(
      size: const Size.square(20.0),
      activeSize: const Size(20.0, 20.0),
      activeColor: Theme.of(context).primaryColor,
      color: Colors.grey,
      spacing: const EdgeInsets.symmetric(horizontal: 3.0),
      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
    );
  }
}

Future<bool> shouldShowIntro() async {
  return prefs.getBool('intro_seen') ?? false;
}
