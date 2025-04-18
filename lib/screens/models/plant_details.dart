class PlantDetails {
  final String plantId;
  final String name;
  final String type;
  final DateTime? lastWatered;
  final DateTime? nextWatering;
  final String? lastPhoto;
  final SensorData? lastSensorData;

  PlantDetails({
    required this.plantId,
    required this.name,
    required this.type,
    this.lastWatered,
    this.nextWatering,
    this.lastPhoto,
    this.lastSensorData,
  });

  factory PlantDetails.fromJson(Map<String, dynamic> json) {
    return PlantDetails(
      plantId: json['plant_id'],
      name: json['name'],
      type: json['type'],
      lastWatered: json['last_watered'] != null && json['last_watered'] is String
          ? DateTime.tryParse(json['last_watered']) // Используем tryParse для безопасного парсинга
          : null,
      nextWatering: json['next_watering'] != null && json['next_watering'] is String
          ? DateTime.tryParse(json['next_watering']) // Используем tryParse для безопасного парсинга
          : null,
      lastPhoto: json['last_photo'], // Оставляем как строку URL
      lastSensorData: json['last_sensor_data'] != null
          ? SensorData.fromJson(json['last_sensor_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant_id': plantId,
      'name': name,
      'type': type,
      'last_watered': lastWatered?.toIso8601String(), // Конвертируем DateTime в строку
      'next_watering': nextWatering?.toIso8601String(), // Конвертируем DateTime в строку
      'last_photo': lastPhoto, // Оставляем URL как строку
      'last_sensor_data': lastSensorData?.toJson(),
    };
  }
}

class SensorData {
  final double? temperature;
  final double? humidity;
  final double? soilMoisture;
  final double? light;
  final double? gasQuality;
  final DateTime? createdAt;

  SensorData({
    this.temperature,
    this.humidity,
    this.soilMoisture,
    this.light,
    this.gasQuality,
    this.createdAt,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: json['temperature']?.toDouble(),
      humidity: json['humidity']?.toDouble(),
      soilMoisture: json['soil_moisture']?.toDouble(),
      light: json['light']?.toDouble(),
      gasQuality: json['gas_quality']?.toDouble(),
      createdAt: json['created_at'] != null && json['created_at'] is String
          ? DateTime.tryParse(json['created_at']) // Используем tryParse для безопасного парсинга
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'soil_moisture': soilMoisture,
      'light': light,
      'gas_quality': gasQuality,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
