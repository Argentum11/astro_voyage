import 'package:flutter/material.dart';
import 'package:astro_voyage/login.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: const Column(
          children: [
            LoginScreen(),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
