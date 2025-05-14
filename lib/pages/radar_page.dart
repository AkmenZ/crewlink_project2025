import 'package:crewlink/providers/location_provider.dart';
import 'package:crewlink/widgets/gradient_scaffold.dart';
import 'package:crewlink/widgets/radar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadarPage extends ConsumerWidget {
  const RadarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get current user
    final user = FirebaseAuth.instance.currentUser;
    // watch location stream provider
    final locationAsyncValue = ref.watch(locationStreamProvider);

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Radar'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: locationAsyncValue.when(
              data: (locationData) {
                final lat =
                    locationData.latitude?.toStringAsFixed(6) ?? 'Unknown';
                final lon =
                    locationData.longitude?.toStringAsFixed(6) ?? 'Unknown';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Active Event',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      'My Location',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('Lat: $lat, Lon: $lon'),
                    // display radar
                    Expanded(
                      child: Radar(
                        userId: user!.uid,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error loading location: $error'),
            ),
      ),
    );
  }
}
