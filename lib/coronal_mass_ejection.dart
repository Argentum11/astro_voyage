import 'package:flutter/material.dart';
import 'package:astro_voyage/space_weather.dart';
import 'package:astro_voyage/api.dart';
import 'package:astro_voyage/date_time.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Spacecraft {
  Spacecraft({required this.name});
  final String name;

  factory Spacecraft.fromJson(Map<String, dynamic> json) {
    return Spacecraft(
      name: json['displayName'],
    );
  }
}

class SpacecraftBlock extends StatelessWidget {
  const SpacecraftBlock({super.key, required this.spacecraft});
  final Spacecraft spacecraft;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: const Color.fromARGB(255, 218, 218, 218),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              spacecraft.name,
              style: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(255, 35, 143, 231)),
            ),
          ),
        ),
      ),
    );
  }
}

class SpacecraftRow extends StatelessWidget {
  const SpacecraftRow({super.key, required this.spacecrafts});
  final List<Spacecraft> spacecrafts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Observation spacecraft:'),
        Row(
          children: [
            SpacecraftBlock(spacecraft: spacecrafts[0]),
            if (spacecrafts.length >= 2)
              SpacecraftBlock(spacecraft: spacecrafts[1]),
            if (spacecrafts.length >= 3)
              SpacecraftBlock(spacecraft: spacecrafts[2])
          ],
        ),
      ],
    );
  }
}

String removeVisibleTo(String longString) {
  int visibleToIndex = longString.indexOf('visible to');
  if (visibleToIndex == -1) {
    return longString;
  } else {
    int visibleToSentenceEnd = longString.indexOf('.', visibleToIndex) + 1;
    int visibleToSentenceStart = 0;
    for (int i = visibleToIndex - 1; i >= 0; i--) {
      if (longString[i] == '.') {
        visibleToSentenceStart = i;
      }
    }
    return longString.substring(0, visibleToSentenceStart) +
        longString.substring(visibleToSentenceEnd);
  }
}

class CoronalMassEjection {
  final String dateTime;
  final String note;
  final List<Spacecraft> spacecrafts;
  final double speed;

  CoronalMassEjection(
      {required this.dateTime,
      required this.note,
      required this.spacecrafts,
      required this.speed});

  factory CoronalMassEjection.fromJson(Map<String, dynamic> json) {
    var spacecraftsFromJson = json['instruments'] as List;
    List<Spacecraft> spacecraftList =
        spacecraftsFromJson.map((i) => Spacecraft.fromJson(i)).toList();
    String iso8601FormatDatetime = json['startTime'];
    // speed
    var cmeAnalysesJson = json['cmeAnalyses'] as List;
    List<CMEAnalyses> cmeAnalyses =
        cmeAnalysesJson.map((i) => CMEAnalyses.fromJson(i)).toList();
    double speed = 0;
    for (int i = 0; i < cmeAnalyses.length; i++) {
      CMEAnalyses cmeAnalysis = cmeAnalyses[i];
      if (cmeAnalysis.accurate) {
        speed = cmeAnalysis.speed;
        break;
      }
    }
    return CoronalMassEjection(
        dateTime: formatDateTime(iso8601FormatDatetime),
        note: removeVisibleTo(json['note']),
        spacecrafts: spacecraftList,
        speed: speed);
  }
}

class CMEAnalyses {
  const CMEAnalyses({required this.speed, required this.accurate});
  final double speed;
  final bool accurate;

  factory CMEAnalyses.fromJson(Map<String, dynamic> json) {
    return CMEAnalyses(speed: json['speed'], accurate: json['isMostAccurate']);
  }
}

class CoronalMassEjectionPage extends StatefulWidget {
  const CoronalMassEjectionPage({super.key, required this.spaceWeather});
  final SpaceWeather spaceWeather;

  @override
  State<CoronalMassEjectionPage> createState() => _CoronalMassEjectionState();
}

class _CoronalMassEjectionState extends State<CoronalMassEjectionPage> {
  Future<List<CoronalMassEjection>> fetchCoronalMassEjection() async {
    String nasaApiKey = await getNasaApiKey();
    var response = await http
        .get(Uri.parse('https://api.nasa.gov/DONKI/CME?api_key=$nasaApiKey'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse
          .map((objectJson) => CoronalMassEjection.fromJson(objectJson))
          .toList();
    } else {
      throw Exception('Failed to load Coronal Mass Ejection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: SpaceWeatherTitle(
        spaceWeather: widget.spaceWeather,
      )),
      body: FutureBuilder(
          future: fetchCoronalMassEjection(),
          builder: ((context, snapshot) {
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
                    CoronalMassEjection coronalMassEjection = items[index];
                    return CoronalMassEjectionTile(
                        coronalMassEjection: coronalMassEjection);
                  });
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          })),
    );
  }
}

class SpeedBlock extends StatelessWidget {
  const SpeedBlock({super.key, required this.speed});
  final double speed;

  @override
  Widget build(BuildContext context) {
    int displaySpeed = speed.toInt();
    return Row(
      children: [
        const Text('speed: '),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            color: displaySpeed > 1000
                ? Colors.red
                : displaySpeed >= 500
                    ? Colors.amber
                    : Colors.green,
            width: 40,
            height: 25,
            child: Center(
              child: Text(
                displaySpeed.toString(),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CoronalMassEjectionTile extends StatelessWidget {
  const CoronalMassEjectionTile({super.key, required this.coronalMassEjection});
  final CoronalMassEjection coronalMassEjection;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 230, 189, 186),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SpaceWeatherDateTimeBlock(
                  dateTime: coronalMassEjection.dateTime,
                ),
                SpeedBlock(speed: coronalMassEjection.speed)
              ],
            ),
            SpacecraftRow(spacecrafts: coronalMassEjection.spacecrafts),
            const SizedBox(
              height: 6,
            ),
            Text(
              coronalMassEjection.note,
              maxLines: 5,
            )
          ],
        ),
      ),
    );
  }
}
