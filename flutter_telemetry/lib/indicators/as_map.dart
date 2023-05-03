import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';

class Cone {
  late Color color;
  late Offset pos;
  Cone(p, c) {
    color = c;
    pos = p;
  }

  void convertToTrackNormal(Size size) {
    pos = Offset(pos.dx / size.width, pos.dy / size.height);
  }

  void convertToViewport(Size canvasSize) {
    // (0,0) is top left
    pos = Offset(pos.dx * canvasSize.width,
        trackSize.height - pos.dy * canvasSize.height);
  }
}

void convertConesToTrackNormal(Size size) {
  for (int i = 0; i < conesOnTrack.length; i++) {
    conesOnTrack[i]!.convertToTrackNormal(size);
  }
}

void convertConesToViewport(Size canvasSize) {
  for (int i = 0; i < conesOnTrack.length; i++) {
    conesOnTrack[i]!.convertToViewport(canvasSize);
  }
}

// TODO
class TrackMap extends StatefulWidget {
  const TrackMap({
    Key? key,
    required this.subscribedSignals,
    required this.title,
    required this.mapSize,
  }) : super(key: key);

  final List<String> subscribedSignals;
  final String title;
  final Size mapSize;

  @override
  State<StatefulWidget> createState() {
    return TrackMapState();
  }
}

// TODO
class TrackMapState extends State<TrackMap> {
  @override
  void initState() {
    super.initState();
  }

  void updateData() {}

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          painter: TrackMapPainter(), // TODO
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// TODO test
class TrackMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // converts cone pos to [0,1] space
    convertConesToTrackNormal(trackSize); // from dbc, landmark interval [0,255]
    // converts cone pos to canvas coordinates
    convertConesToViewport(size);
    for (int i = 0; i < conesOnTrack.length; i++) {
      // create a list with one point
      List<Offset> singlePoint = [conesOnTrack[i]!.pos];
      // set the color, size, etc.
      Paint conePaint = Paint();
      conePaint.color = conesOnTrack[i]!.color;
      // draw the point
      canvas.drawPoints(PointMode.points, singlePoint, conePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// TODO
class CarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
