import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/features/auth/widgets/custom_button.dart';

import '../../../config/app_colors.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 80,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(Theme.of(context).iconTheme.color!, BlendMode.srcIn),
                child: Image.asset(
                  "assets/images/app-logo.png",
                  height: 100,
                  width: 100,

                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Learn Kazakh',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ).tr(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Begin your engaging Kazakh language adventure, one spark at a time',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ).tr(),
              ),
            ],
          ),
          Column(
            children: [
              CustomButton(
                  text: 'Sign In'.tr(),
                  onPressed: () {
                    Navigator.pushNamed(context, '/Login');
                  },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                    Navigator.pushNamed(context, '/Register');
                },
                child: Text(
                  'Create a new account',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22)
                ).tr()),
            ],
          )
        ],
      ),
    );
  }
}