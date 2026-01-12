import 'package:dio/dio.dart';
import 'package:weather/models/weather_service_model.dart';

class WeatherServices2 {
  final Dio dio = Dio();
  final String baseUrl = "http://api.weatherapi.com/v1/current.json";
  final String apiKey = "key=a81031c933384ae299691247251405";

  Future<WeatherServiceModel> fetchData(String data) async {
    try {
      final response = await dio.get(
        baseUrl,
        queryParameters: {"key": apiKey, "q": data},
      );
      if (response.statusCode == 200) {
        return weatherServiceModelFromJson(response.data);
      } else {
        throw Exception("failed to fetch data");
      }
    } catch (e) {
      throw Exception("error:$e");
    }
  }

  Future<List<String>> searchbyCountry(String country) async {
    final url =
        "https://api.weatherapi.com/v1/search.json?key=a81031c933384ae299691247251405&q=$country";
    final response = await Dio().get(url);
    final data = response.data as List;
    return data.map((item) {
      final name = item["name"]?.toString() ?? "";
      final country = item["country"]?.toString() ?? "";
      return "$name,$country";
    }).toList();
    // return data.map((country) => country["country"].toString()).toList();
  }
}
