import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.phone_android,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  height: 75,
                ),
                Text('HELLO AGAIN!', style: Theme.of(context).textTheme.titleLarge,).tr(),
                const SizedBox(
                  height: 15,
                ),
                Text('Welcome back , you have been missed', style: Theme.of(context).textTheme.titleMedium).tr(),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
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
                ),
                const SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Password'.tr(),
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
                const SizedBox(
                  height: 20,
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