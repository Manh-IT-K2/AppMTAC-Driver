import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = 'd17cf1a97478452788c80626250206';

  Future<Map<String, dynamic>> fetchWeather(String location) async {
    final url =
        'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$location';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch weather');
    }
  }
}
