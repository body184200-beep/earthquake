import 'dart:convert';
import 'package:http/http.dart' as http;

enum EarthquakeFeedPeriod {
  day('all_day.geojson', 'Past 24 Hours'),
  week('all_week.geojson', 'Past 7 Days'),
  month('all_month.geojson', 'Past 30 Days');

  final String endpoint;
  final String label;
  const EarthquakeFeedPeriod(this.endpoint, this.label);
}

class EarthquakeApiService {
  static const String _baseEndpoint =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/';

  final http.Client _client;

  EarthquakeApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> getRawEarthquakes({
    EarthquakeFeedPeriod period = EarthquakeFeedPeriod.day,
  }) async {
    final url = Uri.parse('$_baseEndpoint${period.endpoint}');
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List features = data['features'] as List? ?? [];
      return features.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load earthquakes (HTTP ${response.statusCode})');
    }
  }
}
