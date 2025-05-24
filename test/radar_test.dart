import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crewlink/utils/location_utils.dart';

void main() {
  // shouldUpdateLocation tests
  group('shouldUpdateLocation', () {
    test('Returns true when the last location is null', () {
      // arrange
      final currentLocation = GeoPoint(54.2776, 8.4715); // Sligo coordinates
      GeoPoint? lastLocation; // empty location
      // act
      final result = shouldUpdateLocation(currentLocation, lastLocation);
      //assert
      expect(result, true);
    });

    test('Returns true when distance is more than 2 meters', () {
      // arrange
      final lastLocation = GeoPoint(54.2776, 8.4715); // Sligo coordinates
      final currentLocation = GeoPoint(54.2780, 8.4715); // coordinates difference by more than 2 meters
      // act
      final result = shouldUpdateLocation(currentLocation, lastLocation);

      // assert
      expect(result, true);
    });

    test('Returns false when distance is less than or equal to 2 meters', () {
      // arrange
      final lastLocation = GeoPoint(54.2776, 8.4715); // Sligo coordinates
      final currentLocation = GeoPoint(54.2776001, 8.4715001); // coordinates difference by less than 2 meters
      //act
      final result = shouldUpdateLocation(currentLocation, lastLocation);
      // assert
      expect(result, false);
    });
  });

  // calculateRelativeOffset tests
  group('calculateRelativeOffset', () {
    test('Returns null when member is outside the range', () {
      // arrange
      final userLocation = GeoPoint(54.2776, 8.4715); // Sligo coordinates
      final memberLocation = GeoPoint(54.2776, 8.5715); // far difference
      final center = Offset(100, 100);
      final radarRadius = 200.0;
      final precision = 10.0;

      // act
      final result = calculateRelativeOffset(
        userLocation,
        memberLocation,
        center,
        radarRadius,
        precision,
      );

      // assert
      expect(result, null);
    });

    test('Calculates correct offset for a nearby member', () {
      // arrange
      final userLocation = GeoPoint(54.2776, 8.4715); // Sligo coordinates
      final memberLocation = GeoPoint(54.2777, 8.4716); // close difference
      final center = Offset(100, 100);
      final radarRadius = 200.0;
      final precision = 10.0;

      // act
      final result = calculateRelativeOffset(
        userLocation,
        memberLocation,
        center,
        radarRadius,
        precision,
      );

      // assert
      expect(result, isNotNull);
      expect(result!.dx, greaterThan(100));
      expect(result.dy, greaterThan(100));
    });

    test('Returns center when user and member locations are the same', () {
      // arrange
      final userLocation = GeoPoint(54.2776, 8.4715); //Sligo
      final memberLocation = GeoPoint(54.2776, 8.4715); // same location
      final center = Offset(100, 100);
      final radarRadius = 200.0;
      final precision = 10.0;

      // act
      final result = calculateRelativeOffset(
        userLocation,
        memberLocation,
        center,
        radarRadius,
        precision,
      );

      // assert
      expect(result, center);
    });

    test('Scales offset correctly within radar range', () {
      // arrange
      final userLocation = GeoPoint(54.2776, 8.4715); //Sligo
      final memberLocation = GeoPoint(54.27765, 8.47155); // further away
      final center = Offset(100, 100);
      final radarRadius = 200.0;
      final precision = 10.0;
      // act
      final result = calculateRelativeOffset(
        userLocation,
        memberLocation,
        center,
        radarRadius,
        precision,
      );

      // assert
      expect(result, isNotNull);
      expect(result!.dx, closeTo(100.0, 50.0));
      expect(result.dy, closeTo(100.0, 50.0));
    });
  });

}