import 'package:dio/dio.dart';
import 'package:weather/models/weather_service_model.dart';

class ThirdService {
  final Dio dio = Dio();
  final String baseUrl = "http://api.weatherapi.com/v1/current.json";
  final String apiKey = "key=a81031c933384ae299691247251405";

  Future<WeatherServiceModel> fetch(String data) async {
    try {
      final response = await dio.get(
        baseUrl,
        queryParameters: {"Key": apiKey, "q": data},
      );
      if (response.statusCode == 200) {
        return weatherServiceModelFromJson(response.data);
      } else {
        throw Exception("failed to fetch data");
      }
    } catch (e) {
      throw Exception("");
    }
  }
}
