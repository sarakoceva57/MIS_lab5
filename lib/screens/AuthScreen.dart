import 'package:flutter/cupertino.dart';
import '../screens/LoginScreen.dart';
import 'SignUpScreen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginScreen(onClickSignUp: toggle)
      : SignUpScreen(onClickSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
