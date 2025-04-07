import 'package:crewlink/widgets/gradient_scaffold.dart';
import 'package:flutter/material.dart';

// basic loading indicator
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
