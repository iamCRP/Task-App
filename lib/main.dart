import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_app/firebase_options.dart';
import 'package:task_app/pages/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Signup(),
    );
  }
}

// Platform  Firebase App Id
// android   1:39506632624:android:fcf9e1f61e802c2dd64075
// ios       1:39506632624:ios:297bf2e826e2e416d64075
