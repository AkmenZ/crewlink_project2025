import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InvitationPage extends StatelessWidget {
  const InvitationPage({
    super.key,
    required this.eventGroupId,
  });

  final String eventGroupId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invitation'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Invitation Page'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: user will join the event group members
              },
              child: const Text('Join Event Group'),
            ),
          ],
        ),
      ),
    );
  }
}
