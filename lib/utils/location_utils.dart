import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

bool shouldUpdateLocation(GeoPoint currentLocation, GeoPoint? lastLocation) {
  if (lastLocation == null) {
    return true;
  }

  // check if distance is more than 2 meters
  final distance = calculateDistance(
    lastLocation.latitude,
    lastLocation.longitude,
    currentLocation.latitude,
    currentLocation.longitude,
  );

  return distance > 2;
}

// calculate the meter distance between two points
// haversine formula
// https://www.movable-type.co.uk/scripts/latlong.html
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const earthRadius = 6371000; // earths raduis
  final dLat = degreesToRadians(lat2 - lat1);
    final dLon = degreesToRadians(lon2 - lon1);

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) *
          cos(lat2 * pi / 180) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

// converts degrees to radians
  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
