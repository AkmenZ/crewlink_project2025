import 'package:crewlink/providers/common_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingOverlay extends ConsumerWidget {
  const LoadingOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watching loading state
    final isLoading = ref.watch(loadingStateProvider);

    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Card(
                elevation: 8,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  // spinner
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
