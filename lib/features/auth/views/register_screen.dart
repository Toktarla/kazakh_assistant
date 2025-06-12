import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart'; // Keep if LineIcons are used elsewhere
import 'package:proj_management_project/features/auth/providers/authentication_provider.dart';
import 'package:proj_management_project/utils/mixins/focus_node_mixin.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../../services/local/internet_checker.dart';
import '../../home/views/home_page.dart'; // Required for StreamSubscription

class RegisterPage extends StatefulWidget with FocusNodeMixin {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text Controllers
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Validator
  final _formKey = GlobalKey<FormState>();

  late FocusNode emailFocusNode;
  late FocusNode fullNameFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  // Internet connectivity state
  bool _hasInternet = true; // Initialize with true, updated by stream
  late StreamSubscription<bool> _internetSubscription;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    fullNameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    // Initialize internet status and subscribe to changes
    _hasInternet = InternetChecker().hasInternet;
    _internetSubscription = InternetChecker().internetStream.listen((status) {
      setState(() {
        _hasInternet = status;
      });
    });
  }

  @override
  void dispose() {
    _internetSubscription.cancel(); // Cancel the subscription
    emailFocusNode.dispose();
    fullNameFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  // Helper function to show a Snackbar message
  void _showSnackbar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.tr()),
        backgroundColor: backgroundColor ?? Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<bool>(
          stream: InternetChecker().internetStream,
          initialData: InternetChecker().hasInternet,
          builder: (context, snapshot) {
            final bool currentInternetStatus = snapshot.data ?? true; // Default to true if snapshot is null

            if (!currentInternetStatus) {
              // Display "No Internet" message and offline option
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.signal_wifi_off_rounded,
                        size: 100,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No Internet Connection',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ).tr(),
                      const SizedBox(height: 10),
                      Text(
                        'Please connect to the internet to register, or you can use the offline version of our app.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ).tr(),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the home page for offline use
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // A clear color for offline mode
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Use Offline Mode',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                          ).tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Display the regular registration form when online
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ColorFiltered(
                            colorFilter: ColorFilter.mode(Theme.of(context).iconTheme.color!, BlendMode.srcIn),
                            child: Image.asset(
                              "assets/images/app-logo.png",
                              height: 100,
                              width: 100,
                            )
                        ),
                        const SizedBox(height: 20),
                        Text('Sign Up',style: Theme.of(context).textTheme.titleLarge,).tr(),
                        const SizedBox(height: 10),
                        Text('Welcome to our app, newbie!', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,).tr(),
                        const SizedBox(height: 30), // Spacing
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              focusNode: emailFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                widget.fieldFocusChange(
                                    context, emailFocusNode, fullNameFocusNode);
                              },
                              decoration: InputDecoration(
                                hintText: 'Email'.tr(),
                                border: InputBorder.none,
                              ),
                              validator: (email) {
                                if (email != null &&
                                    !EmailValidator.validate(email)) {
                                  return "Enter a valid email!".tr();
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15), // Spacing
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: fullNameController,
                              focusNode: fullNameFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                widget.fieldFocusChange(
                                    context, fullNameFocusNode, passwordFocusNode);
                              },
                              decoration: InputDecoration(
                                hintText: 'Full Name'.tr(),
                                border: InputBorder.none,
                              ),
                              validator: (fullName) {
                                final namePattern =
                                RegExp(r'^[A-Z][a-z]+\s[A-Z][a-z]+$');
                                if (fullName == null || fullName.isEmpty) {
                                  return 'Please enter your full name'.tr();
                                } else if (!namePattern.hasMatch(fullName.trim())) {
                                  return 'Please enter a valid full name'.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15), // Spacing
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              focusNode: passwordFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                widget.fieldFocusChange(context, passwordFocusNode, confirmPasswordFocusNode);
                              },
                              obscureText: _isPasswordObscured,
                              decoration: InputDecoration(
                                hintText: 'New Password'.tr(),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordObscured = !_isPasswordObscured;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value != null && value.length < 8) {
                                  return "Password must be 8 chars".tr();
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15), // Spacing
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _isConfirmPasswordObscured,
                              controller: confirmPasswordController,
                              focusNode: confirmPasswordFocusNode,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                confirmPasswordFocusNode.unfocus();
                              },
                              decoration: InputDecoration(
                                hintText: 'Confirm Password'.tr(),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordObscured ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value != null &&
                                    (confirmPasswordController.text != passwordController.text)) {
                                  return "Passwords must match!".tr();
                                } else if (passwordController.text == "") {
                                  return "Passwords must match!".tr();
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15), // Spacing
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: TextButton(
                            onPressed: () {
                              confirmPasswordFocusNode.unfocus();
                              // Check internet before attempting registration
                              if (!_hasInternet) {
                                _showSnackbar('No internet connection. Cannot register.'.tr());
                                return;
                              }
                              final isValidForm = _formKey.currentState!.validate();
                              if (isValidForm) {
                                context.read<AuthenticationProvider>().signUp(emailController.text, passwordController.text, confirmPasswordController.text, fullNameController.text, context);
                              }
                            },
                            child: Text(
                              'Sign Up',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                            ).tr(),
                          ),
                        ),
                        const SizedBox(height: 15), // Spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Are you a member?',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ).tr(),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/Login');
                              },
                              child: Text(
                                'Sign In',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blue),
                              ).tr(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15), // Spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset('assets/images/googlephoto.png', height: 50, width: 50,)),
                              onTap: () async {
                                // Check internet before attempting Google sign-in
                                if (!_hasInternet) {
                                  _showSnackbar('No internet connection. Cannot sign in with Google.'.tr());
                                  return;
                                }
                                context.read<AuthenticationProvider>().signInWithGoogle(context);
                              },
                            ),
                            const SizedBox(width: 20,),
                            GestureDetector(
                              child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: SvgPicture.asset('assets/svg/user.svg', height: 50, width: 50, color: Theme.of(context).textTheme.titleLarge!.color)),
                              onTap: () async {
                                // Check internet before attempting anonymous sign-in
                                if (!_hasInternet) {
                                  _showSnackbar('No internet connection. Cannot sign in anonymously.'.tr());
                                  return;
                                }
                                context.read<AuthenticationProvider>().signInAnonymously(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}