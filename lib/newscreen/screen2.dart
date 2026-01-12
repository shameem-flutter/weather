import 'package:flutter/material.dart';
import 'package:weather/models/weather_service_model.dart';
import 'package:weather/services/weather_service.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2();
}

class _Screen2 extends State<Screen2> {
  WeatherService weatherService = WeatherService();
  WeatherServiceModel? weatherServiceModel;
  bool isLoading = false;
  String? selectLocation;
  String error = '';
  bool useCelcius = true;

  Future<void> _getDetails() async {
    if (selectLocation == null && selectLocation!.isEmpty) return;
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      final result = await weatherService.fetchWeather(selectLocation!);
      setState(() {
        weatherServiceModel = result;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text.isEmpty) {
                return const Iterable.empty();
              }
              return await weatherService.searchCities(textEditingValue.text);
            },
            onSelected: (value) {
              setState(() {
                selectLocation = value;
              });
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
                  textEditingController.text = selectLocation ?? '';
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(hintText: "enter the location"),
                  );
                },
          ),
          ElevatedButton(onPressed: _getDetails, child: Text("weather")),
          if (isLoading) CircularProgressIndicator(),
          if (error.isNotEmpty) Text(error),
          if (weatherServiceModel != null && !isLoading) ...[
            Text(weatherServiceModel!.current.windKph.toString()),
          ],
        ],
      ),
    );
  }
}
