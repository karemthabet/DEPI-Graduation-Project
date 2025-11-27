import 'dart:math';

class DistanceCalculator {
  static const double earthRadiusMeters = 6371000;

  static double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double lat1Rad = _degreesToRadians(lat1);
    final double lat2Rad = _degreesToRadians(lat2);

    final double a =
        pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) * cos(lat1Rad) * cos(lat2Rad);

    final double c = 2 * asin(sqrt(a));

    return earthRadiusMeters * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static bool isWithinThreshold({
    required double distance,
    required double thresholdMeters,
  }) {
    return distance < thresholdMeters;
  }

  static double metersToKilometers(double meters) {
    return meters / 1000;
  }

  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} م';
    } else {
      return '${metersToKilometers(meters).toStringAsFixed(1)} كم';
    }
  }
}

class DistanceConstants {
  static const double cacheThresholdMeters = 700;

  static const double searchRadiusMeters = 50000;
}
