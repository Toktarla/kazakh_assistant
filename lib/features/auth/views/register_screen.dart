import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/features/auth/providers/authentication_provider.dart';
import 'package:proj_management_project/utils/mixins/focus_node_mixin.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    fullNameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.phone_iphone_outlined,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('HELLO FRESH!',style: Theme.of(context).textTheme.titleLarge,).tr(),
                const SizedBox(
                  height: 15,
                ),
                Text('Welcome to our app, newbie!', style: Theme.of(context).textTheme.titleMedium
                ).tr(),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    // Email TextFormField
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
                ),
                const SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    // Full Name TextFormField
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
                ),
                const SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    // New Password TextFormField
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
                          widget.fieldFocusChange(context, passwordFocusNode,
                              confirmPasswordFocusNode);
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'New Password'.tr(),
                          border: InputBorder.none,
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
                ),
                const SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    // Confirm Password TextFormField
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          confirmPasswordFocusNode.unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirm Password'.tr(),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value != null &&
                              (confirmPasswordController.text !=
                                  passwordController.text)) {
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
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      confirmPasswordFocusNode.unfocus();
                      final isValidForm = _formKey.currentState!.validate();
                      if (isValidForm) {
                        context.read<AuthenticationProvider>().signUp(emailController.text, passwordController.text, confirmPasswordController.text, fullNameController.text, context);
                      }
                    },
                    child: const Text('Sign Up',
                        style: TextStyle(
                            color: Colors.white, fontSize: 20
                        )).tr(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Are you a member?',
                    ).tr(),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/Login');
                      },
                      child: const Text('Sign In',
                          style: TextStyle(
                              fontSize: 16, color: Colors.blue)).tr(),
                    ),
                  ],
                ),
                Center(child: GestureDetector(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/images/googlephoto.png')),
                  onTap: () async {
                    context.read<AuthenticationProvider>().signInWithGoogle(context);
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}