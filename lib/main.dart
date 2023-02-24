import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/AuthScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/calendar.dart';
import 'model/list_item.dart';
import 'model/utils.dart';
import 'screens/dodadi_element.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      title: 'Lab5-186041',
      theme: ThemeData(
          primarySwatch: Colors.brown,
          textTheme: ThemeData.light()
              .textTheme
              .copyWith(headline1: TextStyle(fontSize: 28))),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return AuthScreen();
            }
          }),
    );
  }
}
