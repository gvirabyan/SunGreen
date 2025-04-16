import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled14/screens/models/plant.dart';
import 'package:untitled14/screens/models/plant_details.dart';

class PlantApiService {
  static Future<List<Plant>> fetchPlants() async {
    final response = await http.get(
      Uri.parse('http://134.209.254.255:8000/plants/'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Plant.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load plants');
    }
  }

  static Future<void> addPlant({
    required String name,
    required String type,
    required DateTime lastWatered,
  }) async {
    final url = Uri.parse(
      'http://134.209.254.255:8000/plants/',
    ); // замени на настоящий URL
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'name': name,
      'type': type,
      'last_watered': lastWatered.toIso8601String(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Растение успешно добавлено!');
      } else {
        print('❌ Ошибка: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('⚠️ Ошибка подключения: $e');
    }
  }

  static Future<PlantDetails> plantDetails(plantId) async {
    final response = await http.get(
      Uri.parse('http://134.209.254.255:8000/plants/$plantId/details'),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('okkkk');
      final jsonData = json.decode(response.body);
      print("before return");
      return PlantDetails.fromJson(jsonData);
    } else {
      throw Exception('Failed to load plant details');
    }
  }

  static Future<void> changePhoto({
    required String plant_id,
    required String file,
  }) async {
    final url = Uri.parse(
      'http://134.209.254.255:8000/plants/${plant_id}/photos/',
    );
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({'plant_id': plant_id, 'file': file});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Растение успешно добавлено!');
      } else {
        print('❌ Ошибка: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('⚠️ Ошибка подключения: $e');
    }
  }

  static Future<String> getRecommendations(plantId) async {
    final response = await http.get(
      Uri.parse(
        'http://134.209.254.255:8000/diagnose/recommendations/$plantId',
      ),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      print(response.body);

      if (response.body.trim() == '[]') {
        print('empty');
        return "Rexomendations not exists!";
      }
      final jsonData = json.decode(response.body);

      return jsonData;
    } else {
      throw Exception('Failed to load plant details');
    }
  }
}
