import 'package:astro_voyage/space_weather.dart';
import 'package:flutter/material.dart';
import 'package:astro_voyage/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:astro_voyage/date_time.dart';

class SolarFlare {
  SolarFlare(
      {required this.dateTime,
      required this.type,
      required this.location,
      required this.description});
  String dateTime;
  String type;
  String location;
  String description;

  factory SolarFlare.fromJson(Map<String, dynamic> json) {
    String iso8601FormatDatetime = json['peakTime'];

    return SolarFlare(
        dateTime: formatDateTime(iso8601FormatDatetime),
        type: json['classType'],
        location: json['sourceLocation'],
        description: json['note']);
  }
}

class SolarFlarePage extends StatefulWidget {
  const SolarFlarePage({super.key, required this.spaceWeather});
  final SpaceWeather spaceWeather;

  @override
  State<SolarFlarePage> createState() => _SolarFlarePageState();
}

class _SolarFlarePageState extends State<SolarFlarePage> {
  Future<List<SolarFlare>> fetchSolarFlare() async {
    String nasaApiKey = await getNasaApiKey();
    var response = await http.get(Uri.parse(
        'https://api.nasa.gov/DONKI/FLR?api_key=$nasaApiKey'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse
          .map((objectJson) => SolarFlare.fromJson(objectJson))
          .toList();
    } else {
      throw Exception('Failed to load Solar Flare data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SpaceWeatherTitle(
          spaceWeather: widget.spaceWeather,
        ),
      ),
      body: FutureBuilder(
          future: fetchSolarFlare(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var items = snapshot.data!;
              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return SpaceWeatherIntroduction(
                        spaceWeather: widget.spaceWeather,
                      );
                    }
                    SolarFlare solarFlare = items[index];
                    return SolarFlareTile(
                        solarFlare: solarFlare);
                  });
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class SolarFlareTile extends StatelessWidget {
  const SolarFlareTile({super.key, required this.solarFlare});
  final SolarFlare solarFlare;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [Text(solarFlare.dateTime), Text(solarFlare.type)],
        ),
        Text(solarFlare.location),
        Text(solarFlare.description)
      ],
    );
  }
}
