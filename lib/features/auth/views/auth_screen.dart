import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/features/auth/widgets/custom_button.dart';

import '../../../config/app_colors.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height / 1.4,
            decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/app-logo.png",
                  height: 100,
                ),
                const SizedBox(height: 200),
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
              ],
            ),
          ),

          const SizedBox(height: 40),
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
            ).tr())

        ],
      ),
    );
  }
}