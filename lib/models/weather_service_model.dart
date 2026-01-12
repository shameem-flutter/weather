// To parse this JSON data, do
//
//     final weatherServiceModel = weatherServiceModelFromJson(jsonString);

import 'dart:convert';

WeatherServiceModel weatherServiceModelFromJson(String str) =>
    WeatherServiceModel.fromJson(json.decode(str));

String weatherServiceModelToJson(WeatherServiceModel data) =>
    json.encode(data.toJson());

class WeatherServiceModel {
  Location location;
  Current current;

  WeatherServiceModel({required this.location, required this.current});

  factory WeatherServiceModel.fromJson(Map<String, dynamic> json) =>
      WeatherServiceModel(
        location: Location.fromJson(json["location"]),
        current: Current.fromJson(json["current"]),
      );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "current": current.toJson(),
  };
}

class Current {
  int lastUpdatedEpoch;
  String lastUpdated;
  double tempC;
  double tempF;
  int isDay;
  Condition condition;
  double windMph;
  double windKph;
  double windDegree;
  String windDir;
  double pressureMb;
  double pressureIn;
  double precipMm;
  double precipIn;
  double humidity;
  double cloud;
  double feelslikeC;
  double feelslikeF;
  double visKm;
  double visMiles;
  double uv;
  double gustMph;
  double gustKph;

  Current({
    required this.lastUpdatedEpoch,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
    lastUpdatedEpoch: json["last_updated_epoch"],
    lastUpdated: json["last_updated"],
    tempC: (json["temp_c"] ?? 0).toDouble(),
    tempF: (json["temp_f"] ?? 0).toDouble(),
    isDay: json["is_day"],
    condition: Condition.fromJson(json["condition"]),
    windMph: (json["wind_mph"] ?? 0).toDouble(),
    windKph: (json["wind_kph"] ?? 0).toDouble(),
    windDegree: (json["wind_degree"] ?? 0).toDouble(),
    windDir: json["wind_dir"] ?? "",
    pressureMb: (json["pressure_mb"] ?? 0).toDouble(),
    pressureIn: (json["pressure_in"] ?? 0).toDouble(),
    precipMm: (json["precip_mm"] ?? 0).toDouble(),
    precipIn: (json["precip_in"] ?? 0).toDouble(),
    humidity: (json["humidity"] ?? 0).toDouble(),
    cloud: (json["cloud"] ?? 0).toDouble(),
    feelslikeC: (json["feelslike_c"] ?? 0).toDouble(),
    feelslikeF: (json["feelslike_f"] ?? 0).toDouble(),
    visKm: (json["vis_km"] ?? 0).toDouble(),
    visMiles: (json["vis_miles"] ?? 0).toDouble(),
    uv: (json["uv"] ?? 0).toDouble(),
    gustMph: (json["gust_mph"] ?? 0).toDouble(),
    gustKph: (json["gust_kph"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "last_updated_epoch": lastUpdatedEpoch,
    "last_updated": lastUpdated,
    "temp_c": tempC,
    "temp_f": tempF,
    "is_day": isDay,
    "condition": condition.toJson(),
    "wind_mph": windMph,
    "wind_kph": windKph,
    "wind_degree": windDegree,
    "wind_dir": windDir,
    "pressure_mb": pressureMb,
    "pressure_in": pressureIn,
    "precip_mm": precipMm,
    "precip_in": precipIn,
    "humidity": humidity,
    "cloud": cloud,
    "feelslike_c": feelslikeC,
    "feelslike_f": feelslikeF,
    "vis_km": visKm,
    "vis_miles": visMiles,
    "uv": uv,
    "gust_mph": gustMph,
    "gust_kph": gustKph,
  };
}

class Condition {
  String text;
  String icon;
  int code;

  Condition({required this.text, required this.icon, required this.code});

  factory Condition.fromJson(Map<String, dynamic> json) =>
      Condition(text: json["text"], icon: json["icon"], code: json["code"]);

  Map<String, dynamic> toJson() => {"text": text, "icon": icon, "code": code};
}

class Location {
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String tzId;
  int localtimeEpoch;
  String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    name: json["name"],
    region: json["region"],
    country: json["country"],
    lat: (json["lat"] ?? 0).toDouble(),
    lon: (json["lon"] ?? 0).toDouble(),
    tzId: json["tz_id"],
    localtimeEpoch: json["localtime_epoch"],
    localtime: json["localtime"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "region": region,
    "country": country,
    "lat": lat,
    "lon": lon,
    "tz_id": tzId,
    "localtime_epoch": localtimeEpoch,
    "localtime": localtime,
  };
}
