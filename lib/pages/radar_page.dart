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

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Radar'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Active Event',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // display radar
                    Expanded(
                      child: Radar(
                        userId: user!.uid,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
