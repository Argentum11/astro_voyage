import 'package:flutter/material.dart';
import 'package:astro_voyage/space_weather.dart';
import 'package:astro_voyage/api.dart';
import 'package:astro_voyage/date_time.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Spacecraft {
  final String name;

  Spacecraft({required this.name});

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
    return Container(
      color: const Color.fromARGB(255, 218, 218, 218),
      child: Text(
        spacecraft.name,
        style: const TextStyle(
            fontSize: 12, color: Color.fromARGB(255, 35, 143, 231)),
      ),
    );
  }
}

class SpacecraftColumn extends StatelessWidget {
  const SpacecraftColumn({super.key, required this.spacecrafts});
  final List<Spacecraft> spacecrafts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpacecraftBlock(spacecraft: spacecrafts[0]),
        if (spacecrafts.length >= 2)
          SpacecraftBlock(spacecraft: spacecrafts[1]),
        if (spacecrafts.length >= 3) SpacecraftBlock(spacecraft: spacecrafts[2])
      ],
    );
  }
}

class CoronalMassEjection {
  final String date;
  final String note;
  final List<Spacecraft> spacecrafts;

  CoronalMassEjection(
      {required this.date, required this.note, required this.spacecrafts});

  factory CoronalMassEjection.fromJson(Map<String, dynamic> json) {
    var spacecraftsFromJson = json['instruments'] as List;
    List<Spacecraft> spacecraftList =
        spacecraftsFromJson.map((i) => Spacecraft.fromJson(i)).toList();
    String iso8601FormatDatetime = json['startTime'];
    return CoronalMassEjection(
      date: formatDateTime(iso8601FormatDatetime),
      note: json['note'],
      spacecrafts: spacecraftList,
    );
  }
}

class CoronalMassEjectionIntroduction extends StatelessWidget {
  const CoronalMassEjectionIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Coronal Mass Ejections',style: TextStyle(fontSize: 30),),
        Text('Coronal Mass Ejections (CMEs) are large expulsions of plasma and magnetic field from the Sun’s corona. They can eject billions of tons of coronal material and carry an embedded magnetic field (frozen in flux) that is stronger than the background solar wind interplanetary magnetic field (IMF) strength. CMEs travel outward from the Sun at speeds ranging from slower than 250 kilometers per second (km/s) to as fast as near 3000 km/s. The fastest Earth-directed CMEs can reach our planet in as little as 15-18 hours. Slower CMEs can take several days to arrive. They expand in size as they propagate away from the Sun and larger CMEs can reach a size comprising nearly a quarter of the space between Earth and the Sun by the time it reaches our planet')
      ],
    );
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
      throw Exception('Failed to load name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: fetchCoronalMassEjection(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              var items = snapshot.data!;
              return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    if(index==0) return const CoronalMassEjectionIntroduction();
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

class CoronalMassEjectionTile extends StatelessWidget {
  const CoronalMassEjectionTile({super.key, required this.coronalMassEjection});
  final CoronalMassEjection coronalMassEjection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(coronalMassEjection.date),
              SpacecraftColumn(spacecrafts: coronalMassEjection.spacecrafts)
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: Text(
            coronalMassEjection.note,
            maxLines: 5,
          ))
        ],
      ),
    );
  }
}
