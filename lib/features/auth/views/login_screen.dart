import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:proj_management_project/utils/mixins/focus_node_mixin.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: _formKey,
              child: Column(
                spacing: 15,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Sign In', style: Theme.of(context).textTheme.titleLarge,).tr(),
                  Text('Welcome to our app, newbie!', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center).tr(),
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: TextButton(
                      onPressed: () {
                        final isValidForm = _formKey.currentState!.validate();
                        if (isValidForm) {
                          context.read<AuthenticationProvider>().signIn(emailController.text, passwordController.text, context);
                        }
                      },
                      child: const Text('Sign In',
                          style: TextStyle(
                              color: Colors.white, fontSize: 20)).tr(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member?',
                        style: TextStyle(fontSize: 16),
                      ).tr(),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context,'/Register');
                        },
                        child: const Text('Register now',
                            style: TextStyle(
                                fontSize: 16, color: Colors.blue)).tr(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset('assets/images/googlephoto.png', height: 50, width: 50, )),
                        onTap: () async {
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
                          context.read<AuthenticationProvider>().signInAnonymously(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}