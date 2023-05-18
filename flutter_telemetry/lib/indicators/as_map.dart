import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

class Cone {
  late Color color;
  late Offset pos;
  Cone(this.pos, this.color);

  void convertToViewport(Size canvasSize) {
    // (0,0) is top left

    pos = Offset((pos.dx + trackOffset.dx) / trackSize.width, (pos.dy + trackOffset.dy) / trackSize.height);
    pos = Offset(pos.dx * canvasSize.width,
        canvasSize.height - (pos.dy * canvasSize.height));
  }
}

void convertConesToViewport(Size canvasSize) {
  for(String key in conesOnTrack.keys) {
    conesOnTrack[key]!.convertToViewport(canvasSize);
    
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
  late Offset carToDisplay = const Offset(0, 0);
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(milliseconds: settings['chartrefreshTimeMS']![0]), (Timer t) => updateData());
  }

  void updateData() {
    if (conesOnTrack.isEmpty) {
      return;
    }
    conesToDisplay = conesOnTrack.values.toList(); // i guess
    setState(() { });
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
              alignment: AlignmentDirectional.topStart,
              children: [
                CustomPaint(
                  painter:
                      TrackMapPainter(Size(sideLength, sideLength)), // TODO
                ),
                CustomPaint(
                  painter: CarPainter(), // TODO
                )
              ],
            )),
      );
    });
  }

  @override
  void dispose() {
    timer.cancel();
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

    List<Cone> oneColorCones = [];
    for(Color col in coneColors){
      for(String key in conesOnTrack.keys){

        if(conesOnTrack[key]!.color == col){
          
          oneColorCones.add(conesOnTrack[key]!);
        }
      } 
      Paint conePaint = Paint();
      conePaint.color = col;
      conePaint.strokeWidth = 10;

      canvas.drawPoints(PointMode.points, oneColorCones.map((e) => e.pos).toList(), conePaint);
    }
   
    canvas.drawPoints(PointMode.points, [const Offset(700, 700)], Paint());
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
