import 'package:flutter/material.dart';
import 'package:astro_voyage/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:astro_voyage/astro.dart';

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
        return const CircularProgressIndicator();
      }),
    );
  }
}

class LoginBlock extends StatelessWidget {
  const LoginBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: 'ID',
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: 'password',
            ),
          ),
          TextButton(
            child: const Text('login'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AstroPage();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
