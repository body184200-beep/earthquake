import 'package:earthquake/core/services/earthquake_api_service.dart';
import 'package:earthquake/features/data/models/earth_quake_models.dart';

class EarthquakeRepository {
  final EarthquakeApiService _apiService;

  EarthquakeRepository({EarthquakeApiService? apiService})
      : _apiService = apiService ?? EarthquakeApiService();

  Future<List<EarthquakeModel>> getEarthquakes({
    EarthquakeFeedPeriod period = EarthquakeFeedPeriod.day,
  }) async {
    final rawFeatures = await _apiService.getRawEarthquakes(period: period);
    return rawFeatures.map((item) => EarthquakeModel.fromFeature(item)).toList();
  }
}
