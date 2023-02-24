import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:novo/screens/HomeScreen.dart';

import '../model/utils.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onClickSignIn;

  const SignUpScreen({Key? key, required this.onClickSignIn}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();

    super.dispose();
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(top: 120, left: 15, right: 15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign Up!',
                style: TextStyle(
                    fontSize: 45,
                    fontFamily: 'Georgia',
                    color: Color.fromARGB(255, 228, 144, 76)),
              ),
              SizedBox(height: 20),
              Image.asset('assets/images/logo1.png',
                  width: 100, height: 100, fit: BoxFit.cover),
              SizedBox(height: 40),
              TextFormField(
                controller: usernameController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter minimum 8 characters'
                    : null,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Color.fromARGB(255, 228, 144, 76)),
                  icon: Icon(Icons.login, size: 30),
                  label: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 26),
                  ),
                  onPressed: signUp),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                    text: "Already have an account?",
                    style: TextStyle(
                      color: Color.fromARGB(255, 228, 144, 76),
                      fontSize: 22,
                    ),
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickSignIn,
                          text: "  Log In",
                          style: TextStyle(
                              color: Color.fromARGB(255, 15, 15, 15),
                              fontSize: 22))
                    ]),
              )
            ],
          ),
        ));
  }
}
