class PlantDetails {
  final String plantId;
  final String name;
  final String type;
  final DateTime? lastWatered;
  final DateTime? nextWatering;
  final DateTime? lastPhoto;
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
      lastWatered: json['last_watered'] != null
          ? DateTime.parse(json['last_watered'])
          : null,
      nextWatering: json['next_watering'] != null
          ? DateTime.parse(json['next_watering'])
          : null,
      lastPhoto: json['last_photo'] != null
          ? DateTime.parse(json['last_photo'])
          : null,
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
      'last_watered': lastWatered?.toIso8601String(),
      'next_watering': nextWatering?.toIso8601String(),
      'last_photo': lastPhoto?.toIso8601String(),
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
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
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
