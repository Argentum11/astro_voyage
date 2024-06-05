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
          '${SpaceWeather.imageFolder}/${spaceWeather.abbreviation}_small.jpeg',
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
        'Coronal Mass Ejections (CMEs) are large expulsions of plasma and magnetic field from the Sun’s corona. They can eject billions of tons of coronal material and carry an embedded magnetic field (frozen in flux) that is stronger than the background solar wind interplanetary magnetic field (IMF) strength. CMEs travel outward from the Sun at speeds ranging from slower than 250 kilometers per second (km/s) to as fast as near 3000 km/s. The fastest Earth-directed CMEs can reach our planet in as little as 15-18 hours. Slower CMEs can take several days to arrive. They expand in size as they propagate away from the Sun and larger CMEs can reach a size comprising nearly a quarter of the space between Earth and the Sun by the time it reaches our planet')
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
