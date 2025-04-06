import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // gradient colors
          colors: [
            Colors.deepPurpleAccent,
            theme.colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.fitHeight,
              alignment: Alignment.center,
              child: SizedBox(
                width: 1,
                height: 1,
                child: rive.RiveAnimation.asset(
                    'assets/rive/background_effect.riv'),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors
                .transparent, // transparent to see linear gradient instead
            appBar: appBar,
            floatingActionButton: floatingActionButton,
            body: body,
          ),
        ],
      ),
    );
  }
}
