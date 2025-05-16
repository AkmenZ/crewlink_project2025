import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:location/location.dart';

part 'location_provider.g.dart';

// official docs
// https://riverpod.dev/docs/providers/stream_provider

@riverpod
Stream<LocationData> locationStream(Ref ref) async* {
  final location = Location();

  // ensures permission is given
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) return;
  }

  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) return;
  }

  // configure accuracy
  location.changeSettings(
    accuracy: LocationAccuracy.high, // highest accuracy
    interval: 1000,// every second
    distanceFilter: 0.2, // short value here
  );

  // start listening to changes
  yield* location.onLocationChanged;
}
