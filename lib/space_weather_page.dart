import 'package:flutter/material.dart';
import 'package:astro_voyage/space_weather.dart';
import 'package:astro_voyage/coronal_mass_ejection.dart';
import 'package:astro_voyage/solar_flare.dart';

class SpaceWeatherTile extends StatelessWidget {
  const SpaceWeatherTile({super.key, required this.spaceWeather});
  final SpaceWeather spaceWeather;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          '${SpaceWeather.imageFolder}/${spaceWeather.abbreviation}_small.png',
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
        'Coronal Mass Ejections (CMEs) are large expulsions of plasma and magnetic field from the Sun’s corona. They can eject billions of tons of coronal material and carry an embedded magnetic field (frozen in flux) that is stronger than the background solar wind interplanetary magnetic field strength.'),
    SpaceWeather('Solar flare', 'FLR',
        'Solar flares are large eruptions of electromagnetic radiation from the Sun lasting from minutes to hours. The sudden outburst of electromagnetic energy travels at the speed of light, therefore any effect upon the sunlit side of Earth’s exposed outer atmosphere occurs at the same time the event is observed. The increased level of X-ray and extreme ultraviolet (EUV) radiation results in ionization in the lower layers of the ionosphere on the sunlit side of Earth. The X-ray flux levels start with the “A” level (nominally starting at 10^-8 W/m^2). The next level, ten times higher, is the “B” level, followed by “C”, “M” and finally “X” flares (10^-4 W/m^2).'),
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
                      builder: spaceWeatherItem.abbreviation == 'CME'
                          ? (context) => CoronalMassEjectionPage(
                              spaceWeather: spaceWeatherItem)
                          : spaceWeatherItem.abbreviation == 'FLR'
                              ? (context) => SolarFlarePage(
                                    spaceWeather: spaceWeatherItem,
                                  )
                              : (context) => const Text('s')));
            },
            child: SpaceWeatherTile(
              spaceWeather: spaceWeathers[index],
            ),
          );
        });
  }
}
