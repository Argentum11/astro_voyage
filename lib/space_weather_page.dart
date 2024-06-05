import 'package:flutter/material.dart';
import 'package:astro_voyage/space_weather.dart';
import 'package:astro_voyage/coronal_mass_ejection.dart';

class SpaceWeatherTile extends StatelessWidget {
  const SpaceWeatherTile({super.key, required this.spaceWeather});
  final SpaceWeather spaceWeather;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/${spaceWeather.abbreviation}_small.jpeg',
          width: 150,
        ),
        Text(
          spaceWeather.name,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          width: 8,
        )
      ],
    );
  }
}

class SpaceWeatherPage extends StatelessWidget {
  SpaceWeatherPage({super.key});

  final List<SpaceWeather> spaceWeathers = [
    SpaceWeather('Coronal Mass Ejection', 'CME',
        'Coronal mass ejection (CME), large eruption of magnetized plasma from the Sun’s outer atmosphere, or corona, that propagates outward into interplanetary space. The CME is one of the main transient features of the Sun. Although it is known to be formed by explosive reconfigurations of solar magnetic fields through the process of magnetic reconnection, its exact formation mechanism is not yet understood.')
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: spaceWeathers.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              SpaceWeather spaceWeatherItem = spaceWeathers[index];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: spaceWeatherItem.abbreviation == "CME"
                          ? (context) => CoronalMassEjectionPage(
                              spaceWeather: spaceWeatherItem)
                          : (context) => const Text('s')));
            },
            child: SpaceWeatherTile(
              spaceWeather: spaceWeathers[index],
            ),
          );
        });
  }
}
