import 'package:flutter/material.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/services/weather_services2.dart';
import '../models/weather_service_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final WeatherServices2 weatherServices2 = WeatherServices2();
  WeatherServiceModel? weather;
  WeatherServices2? weather2;
  // Current
  bool isLoading = false;
  String? selectedCity;
  String error = '';
  bool useCelcius = true;

  Future<void> _getWeather() async {
    if (selectedCity == null || selectedCity!.isEmpty) return;
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final result = await _weatherService.fetchWeather(selectedCity!);
      setState(() => weather = result);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _getBackground(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('sunny') || condition.contains('clear')) {
      return 'assets/sunny.jpg';
    }

    if (condition.contains('rain') || condition.contains('drizzle')) {
      return 'assets/rainy.jpg';
    }

    if (condition.contains('snow')) return 'assets/snowy.jpg';
    if (condition.contains('cloud') ||
        condition.contains('mist') ||
        condition.contains('overcast')) {
      return 'assets/cloudy.jpg';
    }

    return 'assets/default.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final bg = weather != null
        ? _getBackground(weather!.current.condition.text)
        : 'assets/default.jpg';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                useCelcius = !useCelcius;
              });
            },
            icon: useCelcius
                ? Icon(Icons.thermostat, color: Colors.white)
                : Icon(Icons.thermostat_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),

                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return await weatherServices2.searchbyCountry(
                      textEditingValue.text,
                    );
                  },

                  onSelected: (value) {
                    setState(() => selectedCity = value);
                  },
                  fieldViewBuilder:
                      (_, controller, focusNode, onFieldSubmitted) {
                        controller.text = selectedCity ?? '';

                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: "Select City",
                            hintText: "Search or enter location",
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                          ),

                          onFieldSubmitted: (value) => onFieldSubmitted(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'City cannot be empty';
                            }
                            return null;
                          },
                        );
                      },
                ),

                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _getWeather,
                  child: const Text("Get Weather"),
                ),
                const SizedBox(height: 20),

                if (isLoading) const CircularProgressIndicator(),
                if (error.isNotEmpty)
                  Text(error, style: const TextStyle(color: Colors.red)),

                if (weather != null && !isLoading) ...[
                  Text(
                    "${weather!.location.name}, ${weather!.location.country}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${weather!.current.tempC}°C",
                    style: const TextStyle(fontSize: 50),
                  ),
                  Text(
                    weather!.current.condition.text,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text("Humidity: ${weather!.current.humidity}%"),
                  Text("Wind: ${weather!.current.windKph} kph"),
                  Text("Local Time: ${weather!.location.localtime}"),
                  Text(
                    '${useCelcius ? weather!.current.tempC.round() : weather!.current.tempF}${useCelcius ? 'c' : 'f'}',
                  ),
                  Image.network(
                    "https:${weather!.current.condition.icon}",
                    scale: 0.8,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
