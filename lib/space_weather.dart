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
  const SpaceWeatherIntroduction({super.key, required this.spaceWeather});
  final SpaceWeather spaceWeather;

  @override
  Widget build(BuildContext context) {
    const double desiredRadius = 30;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(desiredRadius),
          bottomRight: Radius.circular(desiredRadius)),
      child: Container(
        color: const Color.fromARGB(255, 181, 124, 211),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "${SpaceWeather.imageFolder}/${spaceWeather.abbreviation}.gif",
              width: 900,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 8.0, bottom: 5),
              child: Text(
                spaceWeather.description,
                style: const TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SpaceWeatherDateTimeBlock extends StatelessWidget {
  const SpaceWeatherDateTimeBlock({super.key, required this.dateTime});
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    return Text(
      dateTime,
      style: const TextStyle(
          color: Color.fromARGB(192, 239, 86, 20), fontSize: 20),
    );
  }
}
