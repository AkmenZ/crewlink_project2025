import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewlink/models/event_group_member.dart';
import 'package:crewlink/providers/event_group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Radar extends ConsumerWidget {
  const Radar({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // stream member data from active event group
    final membersStream = ref.watch(eventGroupMembersStreamProvider(userId));

    return membersStream.when(
      data: (members) {
        if (members.isEmpty) {
          return const Center(child: Text('There is no active event at the moment!'));
        }
        // find current user in the list of members
        final userMember = members.firstWhere(
          (member) => member.userId == userId,
          orElse: () => throw Exception('User not found among the members'),
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // radar section
            SizedBox(
              height: 300,
              child: CustomPaint(
                size: const Size(300, 300), // size 
                painter: RadarPainter(
                  userId: userId,
                  userLocation: userMember.location,
                  members: members
                      .where((member) => member.userId != userId)
                      .toList(),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // list of member names
            Expanded(
              child: members.isEmpty
                  ? const Center(child: Text('No members found'))
                  : ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return ListTile(
                          title: Text(member.name),
                        );
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Error loading members: $error')),
    );
  }
}

class RadarPainter extends CustomPainter {
  final String userId;
  final GeoPoint userLocation;
  final List<EventGroupMember> members;
  final double precision; // in meters
  final Color backgroundColor;

  RadarPainter({
    required this.userId,
    required this.userLocation,
    required this.members,
    this.precision = 10,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // drawing largest circle with set bakcground color
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, backgroundPaint);

    // drawing radar circle lines
    final radarPaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // draws 4 circles
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), radarPaint);
    }

    // drawing cross lines
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      radarPaint,
    );
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      radarPaint,
    );

    // drawing a triangle icon that represents current user
    final trianglePaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy - 10); // top point
    path.lineTo(center.dx - 10, center.dy + 10); // bottom left
    path.lineTo(center.dx + 10, center.dy + 10); // bottom right
    path.close(); // close path

    canvas.drawPath(path, trianglePaint);

    // adds members to radar
    for (final member in members) {
      final offset = _calculateRelativeOffset(
        userLocation,
        member.location,
        center,
        radius,
      );

      if (offset != null) {
        // drawing member dots
        final memberPaint = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;

        canvas.drawCircle(offset, 6, memberPaint);

        // draws name on top of the dot
        final textPainter = TextPainter(
          text: TextSpan(
            text: member.name,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, offset + const Offset(6, -12));
      }
    }
  }

  // calculate the relative offset of a members location on the radar
  Offset? _calculateRelativeOffset(
    GeoPoint userLocation,
    GeoPoint memberLocation,
    Offset center,
    double radarRadius,
  ) {
    const earthRadius = 6371000; // earths radius meters

    // convert latitude and longitude from degrees to radians
    final userLat = userLocation.latitude * pi / 180;
    final userLon = userLocation.longitude * pi / 180;
    final memberLat = memberLocation.latitude * pi / 180;
    final memberLon = memberLocation.longitude * pi / 180;

    // calculate the distance between the two points
    final dLat = memberLat - userLat;
    final dLon = memberLon - userLon;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(userLat) * cos(memberLat) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;

    // if member is outside the range return null
    if (distance > 300) return null;

    // calculate the angle relative to the user location
    final angle = atan2(
      memberLocation.latitude - userLocation.latitude,
      memberLocation.longitude - userLocation.longitude,
    );

    // map the distance to the radius
    final scaledDistance = (distance / precision) * (radarRadius / 6);

    // calculate the member position on the radar
    final dx = scaledDistance * cos(angle);
    final dy = scaledDistance * sin(angle);

    return center + Offset(dx, dy);
  }

  // repaint when location changes
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
