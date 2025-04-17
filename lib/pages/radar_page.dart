import 'package:crewlink/providers/location_provider.dart';
import 'package:crewlink/widgets/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadarPage extends ConsumerWidget {
  const RadarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch location stream provider
    final locationAsyncValue = ref.watch(locationStreamProvider);

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Radar'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        // data state
        child: locationAsyncValue.when(
          data: (locationData) {
            final lat = locationData.latitude?.toStringAsFixed(6) ?? 'Unknown';
            final lon = locationData.longitude?.toStringAsFixed(6) ?? 'Unknown';
            return Column(
              children: [
                Text('My location'),
                Text('Lat: $lat, Lon: $lon'),
              ],
            );
          },
          // loading state
          loading: () => const CircularProgressIndicator(),
          // error state
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}
