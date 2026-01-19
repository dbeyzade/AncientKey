import 'package:flutter/material.dart';

class PeriodWeatherScreen extends StatelessWidget {
  const PeriodWeatherScreen({super.key});

  final List<HistoricalWeather> weatherData = const [
    HistoricalWeather(
      location: 'Antik Mısır - Nil Deltası',
      era: 'MÖ 2500',
      temperature: '35°C',
      condition: 'Güneşli ve Kurak',
      description: 'Nil Nehri her yıl taşar ve verimli toprak bırakırdı. Yağmur neredeyse hiç yağmazdı.',
      icon: Icons.wb_sunny,
      color: Colors.amber,
      humidity: '10%',
      windSpeed: '15 km/s',
    ),
    HistoricalWeather(
      location: 'Antik Roma - Roma Şehri',
      era: 'MS 100',
      temperature: '28°C',
      condition: 'Akdeniz İklimi',
      description: 'Sıcak ve kurak yazlar, ılık ve yağışlı kışlar. Tarım için ideal koşullar.',
      icon: Icons.wb_cloudy,
      color: Colors.blue,
      humidity: '60%',
      windSpeed: '20 km/s',
    ),
    HistoricalWeather(
      location: 'Antik Yunan - Atina',
      era: 'MÖ 400',
      temperature: '32°C',
      condition: 'Sıcak Yaz',
      description: 'Olimpiyat oyunları sıcak yaz aylarında düzenlenirdi. Atletler kavurucu sıcakla mücadele ederdi.',
      icon: Icons.sunny,
      color: Colors.orange,
      humidity: '40%',
      windSpeed: '25 km/s',
    ),
    HistoricalWeather(
      location: 'Vikinglerin Diyarı - İskandinavya',
      era: 'MS 900',
      temperature: '5°C',
      condition: 'Soğuk ve Karlı',
      description: 'Uzun, soğuk kışlar. Vikinglerin dayanıklılığını test eden sert iklim koşulları.',
      icon: Icons.ac_unit,
      color: Colors.cyan,
      humidity: '80%',
      windSpeed: '40 km/s',
    ),
    HistoricalWeather(
      location: 'Maya Medeniyeti - Tikal',
      era: 'MS 800',
      temperature: '30°C',
      condition: 'Tropikal Yağmurlu',
      description: 'Yoğun yağmur ormanlarında yağmur ve nem hakim. Mayalar bu zorlu ortamda şehirler kurdu.',
      icon: Icons.water_drop,
      color: Colors.green,
      humidity: '90%',
      windSpeed: '10 km/s',
    ),
    HistoricalWeather(
      location: 'Pers İmparatorluğu - Persepolis',
      era: 'MÖ 500',
      temperature: '38°C',
      condition: 'Çöl Sıcağı',
      description: 'İran yaylasında kavurucu sıcaklar. Saraylar serin kalmak için özel tasarlanmıştı.',
      icon: Icons.whatshot,
      color: Colors.deepOrange,
      humidity: '15%',
      windSpeed: '30 km/s',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dönem Hava Durumu'),
        elevation: 2,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: weatherData.length,
        itemBuilder: (context, index) {
          return _buildWeatherCard(context, weatherData[index]);
        },
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context, HistoricalWeather weather) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showWeatherDetails(context, weather),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                weather.color.withOpacity(0.8),
                weather.color.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.location,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weather.era,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    weather.icon,
                    size: 60,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.temperature,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        weather.condition,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildWeatherInfo(Icons.water_drop, weather.humidity),
                      const SizedBox(height: 8),
                      _buildWeatherInfo(Icons.air, weather.windSpeed),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                weather.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  void _showWeatherDetails(BuildContext context, HistoricalWeather weather) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [weather.color, weather.color.withOpacity(0.7)],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Icon(weather.icon, size: 80, color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      weather.temperature,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weather.condition,
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.location,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weather.era,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Nem', weather.humidity, Icons.water_drop),
                      const SizedBox(height: 8),
                      _buildDetailRow('Rüzgar', weather.windSpeed, Icons.air),
                      const SizedBox(height: 16),
                      Text(
                        weather.description,
                        style: const TextStyle(fontSize: 15, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}

class HistoricalWeather {
  final String location;
  final String era;
  final String temperature;
  final String condition;
  final String description;
  final IconData icon;
  final Color color;
  final String humidity;
  final String windSpeed;

  const HistoricalWeather({
    required this.location,
    required this.era,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.icon,
    required this.color,
    required this.humidity,
    required this.windSpeed,
  });
}
