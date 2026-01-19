class Civilization {
  final String id;
  final String name;
  final String period;
  final String location;
  final String description;
  final String rise;
  final String peak;
  final String decline;
  final List<String> majorCities;
  final List<String> achievements;
  final List<String> famousFigures;
  final String imagePath;
  final int startYear; // Negatif değerler MÖ
  final int endYear;

  Civilization({
    required this.id,
    required this.name,
    required this.period,
    required this.location,
    required this.description,
    required this.rise,
    required this.peak,
    required this.decline,
    required this.majorCities,
    required this.achievements,
    required this.famousFigures,
    required this.imagePath,
    required this.startYear,
    required this.endYear,
  });
}
