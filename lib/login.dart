import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:astro_voyage/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:astro_voyage/astro.dart';
import 'package:astro_voyage/status.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AstronomyPictureOfTheDayBlock(),
        LoginBlock(),
      ],
    );
  }
}

class AstronomyPictureOfTheDay {
  final String date;
  final String explanation;
  final String title;
  final String imageUrl;

  AstronomyPictureOfTheDay(
      {required this.date,
      required this.explanation,
      required this.title,
      required this.imageUrl});

  factory AstronomyPictureOfTheDay.fromJson(Map<String, dynamic> json) {
    return AstronomyPictureOfTheDay(
      date: json['date'],
      explanation: json['explanation'],
      title: json['title'],
      imageUrl: json['url'],
    );
  }
}

class AstronomyPictureOfTheDayBlock extends StatelessWidget {
  const AstronomyPictureOfTheDayBlock({super.key});

  Future<AstronomyPictureOfTheDay> fetchAstronomyPictureOfTheDay() async {
    String nasaApiKey = await getNasaApiKey();
    var response = await http.get(
        Uri.parse('https://api.nasa.gov/planetary/apod?api_key=$nasaApiKey'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return AstronomyPictureOfTheDay.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchAstronomyPictureOfTheDay(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final AstronomyPictureOfTheDay astronomyPictureOfTheDay =
              snapshot.data!;
          return Column(
            children: [
              Image.network(
                astronomyPictureOfTheDay.imageUrl,
                width: 350,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  astronomyPictureOfTheDay.title,
                  style: const TextStyle(
                      fontSize: 19, color: Color.fromARGB(255, 5, 121, 174)),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressWithTitle(
          title: 'Fetching Astronomy Picture of the Day',
        );
      }),
    );
  }
}

class LoginBlock extends StatefulWidget {
  const LoginBlock({super.key});

  @override
  State<LoginBlock> createState() => _LoginBlockState();
}

class _LoginBlockState extends State<LoginBlock> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'email',
            ),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: 'password',
            ),
            obscureText: true,
          ),
          TextButton(
            child: const Text('login'),
            onPressed: () async {
              final email = _emailController.text.trim();
              final password = _passwordController.text.trim();
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                if (context.mounted) {
                  // When you use async/await or Futures, your code enters an asynchronous zone,
                  // meaning it might continue execution even after the widget tree that provided the BuildContext has been disposed of,
                  // that's why directly access context in this async function (onPressed function for login button)
                  // without any check might cause errors
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AstroPage(),
                    ),
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (context.mounted) {
                  if (e.code == 'user-not-found') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${e.toString()} No user found for the provided email.($email)'),
                      ),
                    );
                  } else if (e.code == 'wrong-password') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Wrong password'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                } // Print any other errors
              }
            },
          )
        ],
      ),
    );
  }
}
