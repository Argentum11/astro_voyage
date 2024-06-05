import 'package:flutter/material.dart';

class SpaceWeather {
  String name;
  String abbreviation;
  String description;

  SpaceWeather(this.name, this.abbreviation, this.description);
}

class SpaceWeatherDescription extends StatelessWidget {
  const SpaceWeatherDescription({super.key, required this.spaceWeather});
  final SpaceWeather spaceWeather;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(spaceWeather.name),
        Text(spaceWeather.description),
      ],
    );
  }
}
