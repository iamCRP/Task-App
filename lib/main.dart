import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_app/firebase_options.dart';
import 'package:task_app/pages/homepage.dart';
import 'package:task_app/pages/loginpage.dart';
import 'package:task_app/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _auth.currentUser != null ? Homepage() : Loginpage(),
    );
  }
}

// Platform  Firebase App Id
// android   1:39506632624:android:fcf9e1f61e802c2dd64075
// ios       1:39506632624:ios:297bf2e826e2e416d64075
