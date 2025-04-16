import 'package:crewlink/widgets/gradient_scaffold.dart';
import 'package:flutter/material.dart';

class RadarPage extends StatelessWidget {
  const RadarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Radar'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text('Radar page'),
      ),
    );
  }
}
