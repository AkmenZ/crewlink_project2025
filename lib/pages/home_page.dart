import 'package:crewlink/widgets/gradient_scaffold.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text('Home page'),
      ),
    );
  }
}
