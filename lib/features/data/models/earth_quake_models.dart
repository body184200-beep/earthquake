class EarthquakeModel {
  final double magnitude;
  final String place;
  final DateTime date;
  final double? longitude;
  final double? latitude;
  final double? depth;
  final String? url;
  final bool tsunami;
  final int? significance;

  EarthquakeModel({
    required this.magnitude,
    required this.place,
    required this.date,
    this.longitude,
    this.latitude,
    this.depth,
    this.url,
    this.tsunami = false,
    this.significance,
  });

  factory EarthquakeModel.fromFeature(Map<String, dynamic> feature) {
    final properties = (feature['properties'] as Map<String, dynamic>?) ?? {};
    final geometry = (feature['geometry'] as Map<String, dynamic>?) ?? {};
    final coordinates = (geometry['coordinates'] as List<dynamic>?) ?? [];

    final double? lon = coordinates.isNotEmpty ? (coordinates[0] as num?)?.toDouble() : null;
    final double? lat = coordinates.length > 1 ? (coordinates[1] as num?)?.toDouble() : null;
    final double? dep = coordinates.length > 2 ? (coordinates[2] as num?)?.toDouble() : null;

    final magRaw = properties['mag'];
    final double mag = magRaw != null ? (magRaw as num).toDouble() : 0.0;
    final int timeRaw = (properties['time'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch;

    return EarthquakeModel(
      magnitude: mag,
      place: (properties['place'] as String?)?.trim() ?? 'Unknown location',
      date: DateTime.fromMillisecondsSinceEpoch(timeRaw),
      longitude: lon,
      latitude: lat,
      depth: dep,
      url: properties['url'] as String?,
      tsunami: (properties['tsunami'] as num?)?.toInt() == 1,
      significance: (properties['sig'] as num?)?.toInt(),
    );
  }

  factory EarthquakeModel.fromJson(Map<String, dynamic> json) {
    final magRaw = json['mag'];
    final double mag = magRaw != null ? (magRaw as num).toDouble() : 0.0;
    final int timeRaw = (json['time'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch;

    return EarthquakeModel(
      magnitude: mag,
      place: (json['place'] as String?)?.trim() ?? 'Unknown location',
      date: DateTime.fromMillisecondsSinceEpoch(timeRaw),
      url: json['url'] as String?,
      tsunami: (json['tsunami'] as num?)?.toInt() == 1,
      significance: (json['sig'] as num?)?.toInt(),
    );
  }

  /// Separates "12 km NE of Ridgecrest, CA" into primary name "Ridgecrest, CA"
  String get primaryLocation {
    if (place.contains(' of ')) {
      final parts = place.split(' of ');
      if (parts.length > 1 && parts[1].trim().isNotEmpty) {
        return parts.sublist(1).join(' of ').trim();
      }
    }
    return place;
  }

  /// Returns proximity portion, e.g. "12 km NE of" or empty if none
  String get distanceOffset {
    if (place.contains(' of ')) {
      final parts = place.split(' of ');
      return '${parts[0].trim()} of';
    }
    return '';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String get formattedTime {
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[date.month - 1];
    return '$month ${date.day}, ${date.year} at $formattedTime';
  }

  String get severityLabel {
    if (magnitude < 2.5) return 'Micro';
    if (magnitude < 4.0) return 'Minor';
    if (magnitude < 5.0) return 'Light';
    if (magnitude < 6.0) return 'Moderate';
    if (magnitude < 7.0) return 'Strong';
    if (magnitude < 8.0) return 'Major';
    return 'Great';
  }

  String get depthCategory {
    if (depth == null) return 'Unknown Depth';
    if (depth! < 70) return 'Shallow focus (<70 km)';
    if (depth! <= 300) return 'Intermediate focus (70-300 km)';
    return 'Deep focus (>300 km)';
  }

  String get coordinatesDisplay {
    if (latitude == null || longitude == null) return 'N/A';
    final latDir = latitude! >= 0 ? 'N' : 'S';
    final lonDir = longitude! >= 0 ? 'E' : 'W';
    return '${latitude!.abs().toStringAsFixed(3)}° $latDir, ${longitude!.abs().toStringAsFixed(3)}° $lonDir';
  }
}
