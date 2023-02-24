import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/utils.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onClickSignUp;

  const LoginScreen({Key? key, required this.onClickSignUp}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 120, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Log In',
            style: TextStyle(
                fontSize: 45,
                fontFamily: 'Georgia',
                color: Color.fromARGB(255, 228, 144, 76)),
          ),
          SizedBox(height: 20),
          Image.asset('assets/images/logo1.png',
              width: 100, height: 100, fit: BoxFit.cover),
          SizedBox(height: 40),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 6),
          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Color.fromARGB(255, 228, 144, 76)),
              icon: Icon(Icons.lock, size: 30),
              label: Text(
                'Sign in',
                style: TextStyle(fontSize: 26),
              ),
              onPressed: signIn),
          SizedBox(height: 20),
          RichText(
            text: TextSpan(
                text: "No account?",
                style: TextStyle(
                  color: Color.fromARGB(255, 228, 144, 76),
                  fontSize: 22,
                ),
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickSignUp,
                      text: "  Sign up here",
                      style: TextStyle(
                          color: Color.fromARGB(255, 15, 15, 15), fontSize: 22))
                ]),
          )
        ],
      ),
    );
  }
}
