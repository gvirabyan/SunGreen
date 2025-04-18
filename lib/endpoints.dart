import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:untitled14/screens/models/plant.dart';
import 'package:untitled14/screens/models/plant_details.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';


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
    final url = Uri.parse('http://134.209.254.255:8000/plants/$plantId/details');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final jsonData = json.decode(response.body);
        print("✅ PLANT DETAILS JSON:");
        print(jsonData);

        try {
          final plantDetails = PlantDetails.fromJson(jsonData);
          return plantDetails;
        } catch (e, stacktrace) {
          print("❌ Ошибка при разборе PlantDetails.fromJson:");
          print("Ошибка: $e");
          print("Stacktrace: $stacktrace");
          throw Exception("Ошибка при разборе данных растения: $e");
        }

      } else {
        print("❌ Сервер вернул код: ${response.statusCode}");
        print("Ответ: ${response.body}");
        throw Exception('Не удалось загрузить детали растения (status code ${response.statusCode})');
      }
    } catch (e, stacktrace) {
      print("❌ Ошибка при выполнении запроса к серверу:");
      print("Ошибка: $e");
      print("Stacktrace: $stacktrace");
      throw Exception("Ошибка при получении данных: $e");
    }
  }


  /*static Future<bool> changePhoto({
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
        return true;
      } else {
        print('❌ Ошибка: ${response.statusCode}');
        print(response.body);
        return false;

      }
    } catch (e) {
      print('⚠️ Ошибка подключения: $e');
      return false;

    }
  }
*/
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

  static Future<String?> fetchPlantPhoto(String plantId) async {
    final url = Uri.parse('http://134.209.254.255:8000/plants/$plantId/photos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List && data.isNotEmpty) {
        final firstPhoto = data[0]; // берем первый элемент из списка
        return firstPhoto['s3_url']; // возвращаем только URL
      }
    }

    return null;
  }





  static Future<bool> uploadPhoto({
    required String plantId,
    required File imageFile,
  }) async {
    final uri = Uri.parse('http://134.209.254.255:8000/plants/$plantId/photos');

    final request = http.MultipartRequest('POST', uri);

    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print('📥 Ответ сервера: $responseBody');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Изображение успешно отправлено');
      return true;
    } else {
      print('❌ Ошибка при отправке изображения: ${response.statusCode}');
      return false;
    }
  }


  static Future<Map<String, dynamic>?> fetchPlantHistory({
    required String plantId,
    required String selectedDate,
  }) async {
    final String url = 'http://134.209.254.255:8000/plants/plants/$plantId/history/$selectedDate';

    try {
      final response = await http.get(Uri.parse(url));
print(response.statusCode);
      if (response.statusCode == 200) {

        return json.decode(response.body);
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
  static Future<bool> shouldWaterPlantsToday() async {
    final url = Uri.parse('http://134.209.254.255:8000/plants/watering-today');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return true;
        }
      }
    } catch (e) {
      print('Ошибка при запросе: $e');
    }

    return false;
  }

}
