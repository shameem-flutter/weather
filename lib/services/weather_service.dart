import 'package:dio/dio.dart';
import '../../models/weather_service_model.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://api.weatherapi.com/v1/current.json';
  final String _apiKey = 'a81031c933384ae299691247251405';

  Future<WeatherServiceModel> fetchWeather(String query) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'key': _apiKey, 'q': query},
      );

      if (response.statusCode == 200) {
        return WeatherServiceModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<String>> searchCities(String query) async {
    final url =
        "https://api.weatherapi.com/v1/search.json?key=a81031c933384ae299691247251405&q=$query";
    final response = await Dio().get(url);
    final data = response.data as List;

    return data.map((city) {
      final name = city["name"]?.toString() ?? "";
      final country = city["country"]?.toString() ?? "";
      return "$name,$country";
    }).toList();
  }

  // Future<List<String>>fetch(String que)async{
  //   final url="";
  //   final response=await Dio().get(url);
  //   final data=response.data as List;

  //   return data.map((country) =>country["country"].toString() ,).toList();
  // }
}
