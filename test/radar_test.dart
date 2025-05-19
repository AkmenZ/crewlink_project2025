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
}