class HourlyForecastEntity {
  final DateTime dateTime;
  final double temperature;
  final String icon;
  final String description;

  const HourlyForecastEntity({
    required this.dateTime,
    required this.temperature,
    required this.icon,
    required this.description,
  });
}