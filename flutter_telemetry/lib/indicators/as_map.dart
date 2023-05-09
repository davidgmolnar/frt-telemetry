import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

class Cone {
  late Color color;
  late Offset pos;
  Cone(p, c) {
    color = c;
    pos = p;
  }

  void convertToViewport(Size canvasSize) {
    // (0,0) is top left
    pos = Offset(pos.dx / trackSize.width, pos.dy / trackSize.height);
    pos = Offset((pos.dx / trackSize.width) * canvasSize.width,
        canvasSize.height - (pos.dy / trackSize.height) * canvasSize.height);
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
  }) : super(key: key);

  final List<String> subscribedSignals;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return TrackMapState();
  }
}

// TODO
class TrackMapState extends State<TrackMap> {
  late List<Cone> conesToDisplay = [];
  late Offset carToDisplay = Offset(0, 0);

  @override
  void initState() {
    super.initState();
  }

  void updateData() {
    if (conesOnTrack.isEmpty) {
      return;
    }
    conesToDisplay = conesOnTrack.values.toList(); // i guess
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double sideLength =
          constraints.maxWidth - 2 * defaultPadding - 2 * borderWidth;
      return InteractiveViewer(
          child: Container(
              decoration: BoxDecoration(border: Border.all(width: borderWidth)),
              height: sideLength,
              width: sideLength,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter:
                        TrackMapPainter(Size(sideLength, sideLength)), // TODO
                  ),
                  CustomPaint(
                    painter: CarPainter(), // TODO
                  )
                ],
              )));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// TODO test
class TrackMapPainter extends CustomPainter {
  final Size canvasSize;
  TrackMapPainter(this.canvasSize);

  @override
  void paint(Canvas canvas, Size size) {
    // converts cone pos to canvas coordinates
    convertConesToViewport(canvasSize);
    for (int i = 0; i < conesOnTrack.length; i++) {
      // TODO színenként kiválogatni és egybe rajzolni
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
