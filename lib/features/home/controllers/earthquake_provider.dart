import 'package:earthquake/core/services/earthquake_api_service.dart';
import 'package:earthquake/features/data/models/earth_quake_models.dart';
import 'package:earthquake/features/data/repositories/earthquake_repository.dart';
import 'package:flutter/foundation.dart';

class EarthquakeProvider extends ChangeNotifier {
  final EarthquakeRepository _repository;

  EarthquakeProvider({EarthquakeRepository? repository})
      : _repository = repository ?? EarthquakeRepository();

  // State
  List<EarthquakeModel> _earthquakes = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _searchQuery = '';
  double _minMagnitude = 0.0;
  bool _sortByMagnitude = false;
  bool _isSearchOpen = false;
  EarthquakeFeedPeriod _feedPeriod = EarthquakeFeedPeriod.day;

  // Getters
  List<EarthquakeModel> get earthquakes => _earthquakes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;
  double get minMagnitude => _minMagnitude;
  bool get sortByMagnitude => _sortByMagnitude;
  bool get isSearchOpen => _isSearchOpen;
  EarthquakeFeedPeriod get feedPeriod => _feedPeriod;

  // Computed Properties
  List<EarthquakeModel> get filteredEarthquakes {
    final list = _earthquakes.where((quake) {
      final matchesSearch = _searchQuery.isEmpty ||
          quake.place.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesMagnitude = quake.magnitude >= _minMagnitude;
      return matchesSearch && matchesMagnitude;
    }).toList();

    if (_sortByMagnitude) {
      list.sort((a, b) => b.magnitude.compareTo(a.magnitude));
    } else {
      list.sort((a, b) => b.date.compareTo(a.date));
    }

    return list;
  }

  int get totalCount => _earthquakes.length;

  double get peakMagnitude {
    if (_earthquakes.isEmpty) return 0.0;
    return _earthquakes.map((e) => e.magnitude).reduce((a, b) => a > b ? a : b);
  }

  EarthquakeModel? get peakEarthquake {
    if (_earthquakes.isEmpty) return null;
    return _earthquakes.reduce((a, b) => a.magnitude > b.magnitude ? a : b);
  }

  int get significantCount {
    return _earthquakes.where((e) => e.magnitude >= 4.5).length;
  }

  bool get hasActiveFilters => _searchQuery.isNotEmpty || _minMagnitude > 0;

  // Actions
  Future<void> fetchEarthquakes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _earthquakes = await _repository.getEarthquakes(period: _feedPeriod);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFeedPeriod(EarthquakeFeedPeriod period) {
    if (_feedPeriod != period) {
      _feedPeriod = period;
      fetchEarthquakes();
    }
  }

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  void setMinMagnitude(double mag) {
    if (_minMagnitude != mag) {
      _minMagnitude = mag;
      notifyListeners();
    }
  }

  void toggleSortOrder() {
    _sortByMagnitude = !_sortByMagnitude;
    notifyListeners();
  }

  void toggleSearchOpen() {
    _isSearchOpen = !_isSearchOpen;
    if (!_isSearchOpen) {
      _searchQuery = '';
    }
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _minMagnitude = 0.0;
    _isSearchOpen = false;
    notifyListeners();
  }
}
