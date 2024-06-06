import 'package:flutter/material.dart';

class SpaceWeather {
  String name;
  String abbreviation;
  String description;
  static const String imageFolder = 'assets/space_weather';

  SpaceWeather(this.name, this.abbreviation, this.description);
}

class SpaceWeatherTitle extends StatelessWidget {
  const SpaceWeatherTitle({super.key, required this.spaceWeather});
  final SpaceWeather spaceWeather;

  @override
  Widget build(BuildContext context) {
    return Text(
      spaceWeather.name,
      style: const TextStyle(fontSize: 30),
    );
  }
}

class SpaceWeatherIntroduction extends StatelessWidget {
  const SpaceWeatherIntroduction(
      {super.key, required this.spaceWeather});
  final SpaceWeather spaceWeather;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("${SpaceWeather.imageFolder}/${spaceWeather.abbreviation}.gif"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(spaceWeather.description),
        )
      ],
    );
  }
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
