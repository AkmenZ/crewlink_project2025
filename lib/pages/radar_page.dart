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
        title: const Text('Friends Radar'),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: Radar(
          userId: user!.uid,
        ),
      ),
    );
  }
}
