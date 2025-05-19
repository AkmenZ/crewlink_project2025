import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crewlink/models/event_group_member.dart';
import 'package:crewlink/providers/event_group_provider.dart';
import 'package:crewlink/providers/location_provider.dart';
import 'package:crewlink/services/event_group_service.dart';
import 'package:crewlink/utils/location_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Radar extends ConsumerStatefulWidget {
  const Radar({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  ConsumerState<Radar> createState() => _RadarState();
}

class _RadarState extends ConsumerState<Radar> {
  GeoPoint? _lastUpdatedLocation;
  final _service = EventGroupService();
  double _heading = 0.0; // initial facing north
  Timer? _timer; // timer for periodic updates

  // colors list
  final List<Color> _availableColors = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.teal,
    Colors.purple,
    Colors.yellow,
    Colors.indigo,
    Colors.pinkAccent,
  ];
  Map<String, Color> _memberColors = {}; // map to store member colors
  Set<String> _checkedMembers = {}; // checked members
  // flag to check if memebers are initialized
  bool _isMembersInitialized = false;

  @override
  void initState() {
    super.initState();

    // listen to compass updates
    FlutterCompass.events?.listen((event) {
      setState(() {
        _heading = event.heading ?? 0.0; // update the heading
      });
    });

    // start timer to update location
    _startLocationUpdateTimer();
  }

  @override
  void dispose() {
    // disposes timer
    _timer?.cancel();
    super.dispose();
  }

  // method to assign member colors and init checked members set
  void _assignMembers(List<EventGroupMember> members) {
    _memberColors = {};
    _checkedMembers = {};
    for (int i = 0; i < members.length; i++) {
      final member = members[i];
      // assign color to each member
      _memberColors[member.userId] =
          _availableColors[i % _availableColors.length];
      // add member to checked members
      _checkedMembers.add(member.userId);
    }
  }

  /// updates the members location
  Future<void> _updateMemberLocation(String groupId, GeoPoint location) async {
    try {
      await _service.updateMemberLocation(
        groupId: groupId,
        userId: widget.userId,
        location: location,
      );
    } catch (error) {
      throw Exception('Failed to update location: $error');
    }
  }

  // start the timer to update location every 2 seconds
  void _startLocationUpdateTimer() {
    // run every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      // read latest location data
      final locationAsyncValue = ref.read(locationStreamProvider);

      // skip if no data
      locationAsyncValue.whenData((locationData) {
        if (locationData.latitude == null || locationData.longitude == null) {
          return;
        }

        final currentLocation = GeoPoint(
          locationData.latitude!,
          locationData.longitude!,
        );

        // read active event group and members
        final membersStream =
            ref.read(eventGroupMembersWithGroupIdStreamProvider(widget.userId));

        membersStream.whenData((data) {
          final groupId = data['groupId'];

          if (groupId != null) {
            // check if should be updated
            if (shouldUpdateLocation(currentLocation, _lastUpdatedLocation)) {
              // update member location
              _updateMemberLocation(groupId, currentLocation);
              // update last location
              _lastUpdatedLocation = currentLocation;
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // stream member data from active event group
    final membersStream =
        ref.watch(eventGroupMembersWithGroupIdStreamProvider(widget.userId));
    // watch location stream provider
    final locationAsyncValue = ref.watch(locationStreamProvider);

    return membersStream.when(
      data: (data) {
        final groupId = data['groupId'];
        final members = data['members'] as List<EventGroupMember>;

        if (groupId == null || members.isEmpty) {
          return const Center(
              child: Text('There is no active event at the moment!'));
        }

        // find current user in the list of members
        final userMember = members.firstWhere(
          (member) => member.userId == widget.userId,
          orElse: () => throw Exception('User not found among the members'),
        );

        // members list without the current user
        final filteredMembers =
            members.where((member) => member.userId != widget.userId).toList();

        // initialize members list once to prevent from rebuilding
        if (!_isMembersInitialized) {
          _assignMembers(filteredMembers);
          _isMembersInitialized = true;
        }

        return locationAsyncValue.when(
          data: (locationData) {
            final lat = locationData.latitude?.toStringAsFixed(6) ?? 'Unknown';
            final lon = locationData.longitude?.toStringAsFixed(6) ?? 'Unknown';

            return Column(
              children: [
                // radar section
                SizedBox(
                  height: 300,
                  child: CustomPaint(
                    size: const Size(300, 300), // size
                    painter: RadarPainter(
                      userId: widget.userId,
                      userLocation: userMember.location,
                      // show only checked members
                      members: filteredMembers
                          .where((member) =>
                              _checkedMembers.contains(member.userId))
                          .toList(),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      heading: _heading,
                      memberColors: _memberColors,
                      precision: 5.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // user location
                Text(
                  'My Location',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Lat: $lat, Lon: $lon'),
                const SizedBox(height: 20),
                // list of member names
                Expanded(
                  child: members.isEmpty
                      ? const Center(child: Text('No members found!'))
                      : ListView.builder(
                          itemCount: filteredMembers.length,
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            final color =
                                _memberColors[member.userId] ?? Colors.grey;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListTile(
                                title: Text(member.name),
                                // members assigned color
                                leading: CircleAvatar(
                                  backgroundColor: color,
                                  radius: 10,
                                ),
                                // checkbox to toggle member visibility
                                trailing: Checkbox(
                                  value:
                                      _checkedMembers.contains(member.userId),
                                  onChanged: (bool? isChecked) {
                                    setState(() {
                                      if (isChecked == true) {
                                        _checkedMembers.add(member.userId);
                                      } else {
                                        _checkedMembers.remove(member.userId);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Error loading location: $error'),
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
  final double heading;
  final Map<String, Color> memberColors;

  RadarPainter({
    required this.userId,
    required this.userLocation,
    required this.members,
    this.precision = 10,
    required this.backgroundColor,
    this.heading = 0.0, // default setting to north
    required this.memberColors,
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

    for (int i = 1; i <= 4; i++) {
      // draws 4 circles
      final circleRadius = radius * (i / 4);
      canvas.drawCircle(center, circleRadius, radarPaint);

      // offset text position
      final textOffset = Offset(center.dx, center.dy - circleRadius - 10);

      // deistance text
      final distanceText = "${i * precision}m";

      // drawing distance texts
      final textSpan = TextSpan(
        text: distanceText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        textOffset - Offset(textPainter.width / 2, 0), // alligh centered
      );
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

    canvas.save(); // Save the canvas state
    canvas.translate(center.dx, center.dy); // Translate to the center
    canvas.rotate(-heading * pi / 180); // Rotate the canvas based on heading
    canvas.translate(-center.dx, -center.dy); // Translate back

    // drawing member dots
    final memberDotOffsets = <Offset, String>{};
    for (final member in members) {
      final offset = _calculateRelativeOffset(
        userLocation,
        member.location,
        center,
        radius,
      );

      if (offset != null) {
        // Draw member dots
        final memberPaint = Paint()
          ..color = memberColors[member.userId] ?? Colors.grey
          ..style = PaintingStyle.fill;

        canvas.drawCircle(offset, 6, memberPaint);

        // Save the member's position and name for later (outside rotation)
        memberDotOffsets[offset] = member.name;
      }
    }

    canvas.restore(); // restore the canvas state

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
    if (distance > 40) return null;

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
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
