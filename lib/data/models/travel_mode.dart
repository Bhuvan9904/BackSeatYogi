import 'package:hive/hive.dart';

part 'travel_mode.g.dart';

@HiveType(typeId: 5)
enum TravelMode {
  @HiveField(0)
  car('Car', '🚗', 'Perfect for road trips and commutes'),
  
  @HiveField(1)
  train('Train', '🚆', 'Ideal for longer journeys with steady motion'),
  
  @HiveField(2)
  flight('Flight', '✈️', 'Great for air travel and jet lag relief'),
  
  @HiveField(3)
  general('General', '🧘', 'Works anywhere you\'re seated');

  const TravelMode(this.displayName, this.emoji, this.description);

  final String displayName;
  final String emoji;
  final String description;

  String get id => name;
}
