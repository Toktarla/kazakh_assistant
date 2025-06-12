import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Keep if still needed for AuthenticationProvider
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart'; // Keep if LineIcons are used elsewhere
import 'package:proj_management_project/utils/mixins/focus_node_mixin.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Required for StreamSubscription
import '../../../services/local/internet_checker.dart';
import '../../home/views/home_page.dart';
import '../providers/authentication_provider.dart';

class LoginPage extends StatefulWidget with FocusNodeMixin {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Focus Nodes
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Validator
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;

  // Internet connectivity state
  bool _hasInternet = true; // Initialize with true, updated by stream
  late StreamSubscription<bool> _internetSubscription;


  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

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
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                        'Please connect to the internet to sign in, or you can use the offline version of our app.',
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
              // Display the regular login form when online
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                  child: Form(
                    autovalidateMode: AutovalidateMode.disabled,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox for spacing replaced by explicit spacing if needed
                        ColorFiltered(
                            colorFilter: ColorFilter.mode(Theme.of(context).iconTheme.color!, BlendMode.srcIn),
                            child: Image.asset(
                              "assets/images/app-logo.png",
                              height: 100,
                              width: 100,
                            )
                        ),
                        const SizedBox(height: 20),
                        Text('Sign In', style: Theme.of(context).textTheme.titleLarge,).tr(),
                        const SizedBox(height: 10),
                        Text('Welcome to our app, newbie!', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center).tr(),
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
                              decoration: InputDecoration(
                                hintText: 'Email'.tr(),
                                border: InputBorder.none,
                              ),
                              onFieldSubmitted: (_){
                                widget.fieldFocusChange(context, emailFocusNode, passwordFocusNode);
                              },
                              validator: (email) {
                                if (email != null &&
                                    !EmailValidator.validate(email)) {
                                  return "It is not email!".tr();
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
                              obscureText: _isPasswordObscured,
                              controller: passwordController,
                              focusNode: passwordFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Password'.tr(),
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
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Check internet before attempting email/password login
                              if (!_hasInternet) {
                                _showSnackbar('No internet connection. Cannot sign in.'.tr());
                                return;
                              }
                              final isValidForm = _formKey.currentState!.validate();
                              if (isValidForm) {
                                context.read<AuthenticationProvider>().signIn(emailController.text, passwordController.text, context);
                              }
                            },
                            child: Text(
                              'Sign In',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                            ).tr(),
                          ),
                        ),
                        const SizedBox(height: 15), // Spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Not a member?',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ).tr(),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context,'/Register');
                              },
                              child: Text(
                                'Register now',
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
                                  child: Image.asset('assets/images/googlephoto.png', height: 50, width: 50, )),
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
                                  height: 50,
                                  width: 50,
                                  child: SvgPicture.asset('assets/svg/user.svg', height: 50, width: 50,color: Theme.of(context).textTheme.titleLarge!.color,)),
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