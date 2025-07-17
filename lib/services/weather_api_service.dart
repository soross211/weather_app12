import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  static const String baseUrl = 'http://localhost:3001/weather';

  // Fetch all weather data from the local API
  Future<List<Map<String, dynamic>>> fetchAllWeather() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Add new weather data to the local API
  Future<void> addWeather(String location, int temperature, String conditions) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'location': location,
        'temperature': temperature,
        'conditions': conditions,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add weather data');
    }
  }

  // Delete weather data from the local API
  Future<void> deleteWeather(String city) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$city'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete weather data');
    }
  }
}
