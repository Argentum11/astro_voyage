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
        'Coronal Mass Ejections (CMEs) are large expulsions of plasma and magnetic field from the Sun’s corona. They can eject billions of tons of coronal material and carry an embedded magnetic field (frozen in flux) that is stronger than the background solar wind interplanetary magnetic field (IMF) strength. CMEs travel outward from the Sun at speeds ranging from slower than 250 kilometers per second (km/s) to as fast as near 3000 km/s. The fastest Earth-directed CMEs can reach our planet in as little as 15-18 hours. Slower CMEs can take several days to arrive. They expand in size as they propagate away from the Sun and larger CMEs can reach a size comprising nearly a quarter of the space between Earth and the Sun by the time it reaches our planet'),
    SpaceWeather('Solar flare', 'FLR',
        'Solar flares are large eruptions of electromagnetic radiation from the Sun lasting from minutes to hours. The sudden outburst of electromagnetic energy travels at the speed of light, therefore any effect upon the sunlit side of Earth’s exposed outer atmosphere occurs at the same time the event is observed. The increased level of X-ray and extreme ultraviolet (EUV) radiation results in ionization in the lower layers of the ionosphere on the sunlit side of Earth. Under normal conditions, high frequency (HF) radio waves are able to support communication over long distances by refraction via the upper layers of the ionosphere. When a strong enough solar flare occurs, ionization is produced in the lower, more dense layers of the ionosphere (the D-layer), and radio waves that interact with electrons in layers lose energy due to the more frequent collisions that occur in the higher density environment of the D-layer. This can cause HF radio signals to become degraded or completely absorbed. This results in a radio blackout – the absence of HF communication, primarily impacting the 3 to 30 MHz band. The D-RAP (D-Region Absorption Prediction) product correlates flare intensity to D-layer absorption strength and spread.'),
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
