class SavedLocation {
  final String city;
  final String temperature;
  final String weatherDesc;
  final DateTime savedTime;

  SavedLocation({
    required this.city,
    required this.temperature,
    required this.weatherDesc,
    required this.savedTime,
  });

  Map<String, dynamic> toJson() => {
    'city': city,
    'temperature': temperature,
    'weatherDesc': weatherDesc,
    'savedTime': savedTime.toIso8601String(),
  };

  factory SavedLocation.fromJson(Map<String, dynamic> json) => SavedLocation(
    city: json['city'],
    temperature: json['temperature'],
    weatherDesc: json['weatherDesc'],
    savedTime: DateTime.parse(json['savedTime']),
  );
}