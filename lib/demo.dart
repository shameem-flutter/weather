import 'package:flutter/material.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/services/weather_services2.dart';
import '../models/weather_service_model.dart';

class WeatherScreenDemo extends StatefulWidget {
  const WeatherScreenDemo({super.key});

  @override
  State<WeatherScreenDemo> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreenDemo> {
  final WeatherService weatherService = WeatherService();
  final WeatherServices2 weatherServices2 = WeatherServices2();
  WeatherServiceModel? weatherModel;
  WeatherServices2? weatherModel2;
  String? selectLocation;
  bool isLoading = false;
  String error = '';
  bool useCelcius = true;

  Future<void> _getWeather() async {
    if (selectLocation == null && selectLocation!.isEmpty) return;
    setState(() {
      isLoading = false;
      error = '';
    });
    try {
      final result = await weatherService.fetchWeather(selectLocation!);
      setState(() {
        weatherModel = result;
      });
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
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
  // Current

  @override
  Widget build(BuildContext context) {
    final bg = weatherModel != null
        ? _getBackground(weatherModel!.current.condition.text)
        : "assets/default.jpg";

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
                : Icon(Icons.thermostat_outlined),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bg.toString()),
            fit: BoxFit.cover,
          ),
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
                    setState(() => selectLocation = value);
                  },
                  fieldViewBuilder:
                      (_, controller, focusNode, onFieldSubmitted) {
                        controller.text = selectLocation ?? '';

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
                ElevatedButton(onPressed: _getWeather, child: Text("Get data")),
                if (isLoading) CircularProgressIndicator(),
                if (weatherModel != null && !isLoading) ...[
                  Text(weatherModel!.location.name),
                ],
                //Text(),

                //    const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
