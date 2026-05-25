import 'dart:convert';

import 'package:http/http.dart' as http;

class NewsApiException implements Exception {
  NewsApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'NewsApiException(statusCode: $statusCode, $message)';
}

class WeatherData {
  const WeatherData({
    required this.cityName,
    required this.description,
    required this.tempC,
    required this.feelsLikeC,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
  });

  final String cityName;
  final String description;
  final double tempC;
  final double feelsLikeC;
  final int humidity;
  final double windSpeed;
  final String? iconCode;
}

class NewsArticle {
  const NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAtRaw,
    required this.sourceName,
    required this.author,
    required this.content,
  });

  final String title;
  final String description;
  final String url;
  final String? imageUrl;
  final String publishedAtRaw;
  final String sourceName;
  final String author;
  final String content;
}

class NewsApi {
  NewsApi({
    http.Client? client,
    this.newsBaseUrl = 'https://newsapi.org',
    this.weatherBaseUrl = 'https://api.openweathermap.org',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String newsBaseUrl;
  final String weatherBaseUrl;

  Uri _newsUri(
    String path, {
    Map<String, String?> query = const <String, String?>{},
  }) {
    final Map<String, String> qs = <String, String>{};
    for (final MapEntry<String, String?> entry in query.entries) {
      final String? value = entry.value;
      if (value == null || value.isEmpty) continue;
      qs[entry.key] = value;
    }
    return Uri.parse('$newsBaseUrl$path').replace(queryParameters: qs);
  }

  Uri _weatherUri(
    String path, {
    Map<String, String?> query = const <String, String?>{},
  }) {
    final Map<String, String> qs = <String, String>{};
    for (final MapEntry<String, String?> entry in query.entries) {
      final String? value = entry.value;
      if (value == null || value.isEmpty) continue;
      qs[entry.key] = value;
    }
    return Uri.parse('$weatherBaseUrl$path').replace(queryParameters: qs);
  }

  Future<WeatherData> weather({
    required double lat,
    required double lon,
    required String apiKey,
    String units = 'metric',
    String lang = 'en',
  }) async {
    final http.Response res = await _client.get(
      _weatherUri(
        '/data/2.5/weather',
        query: <String, String?>{
          'lat': lat.toString(),
          'lon': lon.toString(),
          'appid': apiKey,
          'units': units,
          'lang': lang,
        },
      ),
    );

    if (res.statusCode != 200) {
      throw NewsApiException(
        'Weather request failed.',
        statusCode: res.statusCode,
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(res.body) as Map<String, dynamic>;

    final String cityName = (json['name'] as String?) ?? '';
    final Map<String, dynamic> main =
        ((json['main'] as Map?) ?? const <String, dynamic>{})
            .cast<String, dynamic>();
    final Map<String, dynamic> wind =
        ((json['wind'] as Map?) ?? const <String, dynamic>{})
            .cast<String, dynamic>();

    final List<dynamic> weatherList =
        (json['weather'] as List<dynamic>?) ?? <dynamic>[];
    final Iterable<Map<dynamic, dynamic>> weatherMaps =
        weatherList.whereType<Map<dynamic, dynamic>>();
    final Map<String, dynamic> firstWeather = weatherMaps.isNotEmpty
        ? weatherMaps.first.cast<String, dynamic>()
        : const <String, dynamic>{};

    return WeatherData(
      cityName: cityName,
      description: (firstWeather['description'] as String?) ?? '',
      tempC: ((main['temp'] as num?) ?? 0).toDouble(),
      feelsLikeC: ((main['feels_like'] as num?) ?? 0).toDouble(),
      humidity: ((main['humidity'] as num?) ?? 0).toInt(),
      windSpeed: ((wind['speed'] as num?) ?? 0).toDouble(),
      iconCode: firstWeather['icon'] as String?,
    );
  }

  Future<List<NewsArticle>> everything({
    required String query,
    required String apiKey,
    String language = 'en',
    DateTime? from,
    DateTime? to,
    String? sortBy,
    int? pageSize,
    int? page,
  }) async {
    final http.Response res = await _client.get(
      _newsUri(
        '/v2/everything',
        query: <String, String?>{
          'q': query,
          'apiKey': apiKey,
          'language': language,
          'from': from?.toIso8601String(),
          'to': to?.toIso8601String(),
          'sortBy': sortBy,
          'pageSize': pageSize?.toString(),
          'page': page?.toString(),
        },
      ),
    );

    if (res.statusCode != 200) {
      throw NewsApiException(
        'Everything request failed.',
        statusCode: res.statusCode,
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(res.body) as Map<String, dynamic>;
    if (json['status'] != 'ok') {
      throw NewsApiException('Everything request failed (status!=ok).');
    }

    final List<dynamic> articles =
        (json['articles'] as List<dynamic>?) ?? <dynamic>[];
    return articles.whereType<Map>().map((Map raw) {
      final Map<String, dynamic> map = raw.cast<String, dynamic>();
      final Map<String, dynamic> source =
          ((map['source'] as Map?) ?? const <String, dynamic>{})
              .cast<String, dynamic>();
      return NewsArticle(
        title: (map['title'] as String?) ?? '',
        description: (map['description'] as String?) ?? '',
        url: (map['url'] as String?) ?? '',
        imageUrl: map['urlToImage'] as String?,
        publishedAtRaw: (map['publishedAt'] as String?) ?? '',
        sourceName: (source['name'] as String?) ?? '',
        author: (map['author'] as String?) ?? '',
        content: (map['content'] as String?) ?? '',
      );
    }).toList();
  }

  Future<List<NewsArticle>> topHeadlines({
    required String apiKey,
    String? query,
    String? category,
    String? country,
    int? pageSize,
    int? page,
  }) async {
    final http.Response res = await _client.get(
      _newsUri(
        '/v2/top-headlines',
        query: <String, String?>{
          'apiKey': apiKey,
          'q': query,
          'category': category,
          'country': country,
          'pageSize': pageSize?.toString(),
          'page': page?.toString(),
        },
      ),
    );

    if (res.statusCode != 200) {
      throw NewsApiException(
        'Top-headlines request failed.',
        statusCode: res.statusCode,
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(res.body) as Map<String, dynamic>;
    if (json['status'] != 'ok') {
      throw NewsApiException('Top-headlines request failed (status!=ok).');
    }

    final List<dynamic> articles =
        (json['articles'] as List<dynamic>?) ?? <dynamic>[];
    return articles.whereType<Map>().map((Map raw) {
      final Map<String, dynamic> map = raw.cast<String, dynamic>();
      final Map<String, dynamic> source =
          ((map['source'] as Map?) ?? const <String, dynamic>{})
              .cast<String, dynamic>();
      return NewsArticle(
        title: (map['title'] as String?) ?? '',
        description: (map['description'] as String?) ?? '',
        url: (map['url'] as String?) ?? '',
        imageUrl: map['urlToImage'] as String?,
        publishedAtRaw: (map['publishedAt'] as String?) ?? '',
        sourceName: (source['name'] as String?) ?? '',
        author: (map['author'] as String?) ?? '',
        content: (map['content'] as String?) ?? '',
      );
    }).toList();
  }
}
