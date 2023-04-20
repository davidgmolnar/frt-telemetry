import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';

class TimeSeriesPoint{
  const TimeSeriesPoint(this.signalValue, this.timestamp);
  final num signalValue;
  final DateTime timestamp;
}

double titleHeight = 20;
double fullHeight = 300;
double canvasHeight = fullHeight - titleHeight - 2 * defaultPadding - 2 * borderWidth;
double yAxisWidth = 30;
double borderWidth = 1;

class TimeSeriesChart extends StatefulWidget{
  const TimeSeriesChart({
    super.key,
    required this.subscribedSignals,
    required this.title,
    required this.min,
    required this.max,
  });

  final List<String> subscribedSignals;
  final String title;
  final double min;
  final double max;

  @override
  State<StatefulWidget> createState() {
    return TimeSeriesChartState();
  }
}

class TimeSeriesChartState extends State<TimeSeriesChart>{
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context , constraints) {
        double canvasWidth = constraints.maxWidth - yAxisWidth - 2 * defaultPadding - 2 * borderWidth;
        return Container(
          height: fullHeight,
          width: constraints.maxWidth,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              SizedBox(
                height: titleHeight,
                child: Row(
                  children: const [
                    Text("Title"),
                    Spacer(),
                    Text('Labels')
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: Colors.grey.shade700,
                    width: borderWidth,
                  )
                ),
                child: Row(
                  children: [
                    Container(
                      height: canvasHeight,
                      width: yAxisWidth,
                      decoration: BoxDecoration(border: Border.all()),
                    ),
                    SizedBox(
                      height: canvasHeight,
                      width: canvasWidth,
                      child: TimeSeriesPlotArea(
                        subscribedSignals: widget.subscribedSignals,
                        max: widget.max,
                        min: widget.min,
                        canvasHeight: canvasHeight,
                        canvasWidth: canvasWidth,
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class TimeSeriesPlotArea extends StatefulWidget{ // TODO ennek egyben kell kezelnie a plotokat mert így időben mindenki magát beskálázza de egymással nincsenek időskálában
  const TimeSeriesPlotArea({
    super.key,
    required this.subscribedSignals,
    required this.min,
    required this.max,
    required this.canvasHeight,
    required this.canvasWidth
  });

  final List<String> subscribedSignals;
  final double min;
  final double max;
  final double canvasHeight;
  final double canvasWidth;

  @override
  State<StatefulWidget> createState() {
    return TimeSeriesPlotAreaState();
  }
}

class TimeSeriesPlotAreaState extends State<TimeSeriesPlotArea>{
  List<List<TimeSeriesPoint>> chartData = [];
  List<List<Offset>> chartDataPoints = [];
  late double yScale;
  late double xScale;
  late double xStart;

  late Timer timer;
  static const Map<int, Color> _colormap = {
    0: Color.fromARGB(255, 255, 17, 0),
    1: Color.fromARGB(255, 0, 255, 8),
    2: Colors.blue,
    3: Colors.yellow,
    4: Colors.purple,
    5: Colors.brown
  };
  List<String> labels = [];

  double refreshXStart(){
    if(chartDataPoints.isEmpty || chartDataPoints.every((element) => element.isEmpty)){
      return 0;
    }
    return chartDataPoints.fold(double.infinity, (previousValue, element) => previousValue = min(previousValue, element.first.dx));
  }

  double refreshXScale(){
    if(chartDataPoints.isEmpty || chartDataPoints.every((element) => element.isEmpty)){
      return 1;
    }
    return chartDataPoints.fold(double.infinity, (previousValue, element) => previousValue = min(previousValue, widget.canvasWidth / (element.last.dx - element.first.dx)));
  }

    @override
  void initState() {
    yScale = widget.canvasHeight / (widget.max - widget.min);

    for(int i = 0; i < widget.subscribedSignals.length; i++){
      chartData.add([]);
      chartDataPoints.add([]);
      // DEBUG
      chartData[i] = widget.subscribedSignals[i] == "AMK1_actual_velocity" ? 
      [
        TimeSeriesPoint(10, DateTime.now().add(const Duration(seconds: 1))),
        TimeSeriesPoint(15, DateTime.now().add(const Duration(seconds: 2))),
        TimeSeriesPoint(60, DateTime.now().add(const Duration(seconds: 4))),
      ]
      :
      [
        TimeSeriesPoint(10, DateTime.now().add(const Duration(seconds: 1))),
        TimeSeriesPoint(70, DateTime.now().add(const Duration(seconds: 4))),
        TimeSeriesPoint(15, DateTime.now().add(const Duration(seconds: 11))),
      ];
      // DEBUG
      for(int j = 0; j < chartData[i].length; j++){
        chartDataPoints[i].add(Offset(
          chartData[i][j].timestamp.difference(appstartdate).inMilliseconds.toDouble(),
          chartData[i][j].signalValue * yScale
        ));
      }
    }
    xScale = refreshXScale();
    xStart = refreshXStart();
    super.initState();
  }

  void updateData(){
    DateTime updateTimeLimit = DateTime.now().subtract(const Duration(seconds: 30)); // param
    if(settings['chartLoadMode']![0] == 0){ // 0 lazy 1 complete
      // remélhetőleg nem lesz
    }
    else{
      for(int i = 0; i < widget.subscribedSignals.length; i++){
        List? tempVal = signalValues[widget.subscribedSignals[i]];
        List<DateTime>? tempTime = signalTimestamps[widget.subscribedSignals[i]];
        if((tempVal == null || tempVal.isEmpty) && (tempTime == null || tempTime.isEmpty)){
          //pass
        }
        else if(tempTime!.last.isAfter(chartData[i].last.timestamp) && tempTime.isNotEmpty){
          int newDataStartIdx = tempTime.length - 1;
          while(tempTime[newDataStartIdx].isAfter(chartData[i].last.timestamp)){
            newDataStartIdx--;
          }
          newDataStartIdx++;
          while(newDataStartIdx < tempTime.length){
            chartData[i].add(TimeSeriesPoint(tempVal![newDataStartIdx], tempTime[newDataStartIdx]));
            chartDataPoints[i].add(Offset(
              tempTime[newDataStartIdx].difference(appstartdate).inMilliseconds.toDouble(),
              tempVal[newDataStartIdx] * yScale
            ));
            newDataStartIdx++;
          }
          // Split at last x sec
          chartData[i] = chartData[i].skipWhile((value) => value.timestamp.isBefore(updateTimeLimit)).toList();
          chartDataPoints[i] = chartDataPoints[i].skipWhile((value) => value.dx < updateTimeLimit.difference(appstartdate).inMilliseconds.toDouble()).toList();
        }
      }
      xScale = refreshXScale();
      xStart = refreshXStart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // clip is inside ChartLinePainter
      children: [
        for(int i = 0; i < widget.subscribedSignals.length; i++)
          CustomPaint(
            painter: ChartLinePainter(widget.canvasWidth, widget.canvasHeight, chartDataPoints[i], xScale, xStart, _colormap[i]!),
          )
      ]
    );
  }
}

class ChartLinePainter extends CustomPainter{
  final double width;
  final double height;
  final double xScale;
  final double xStart;
  final Color lineColor;
  List<Offset> points;

  ChartLinePainter(this.width, this.height, this.points, this.xScale, this.xStart, this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint()..color = lineColor..style = PaintingStyle.stroke..strokeWidth = 2;  // ez kinn
    bool first = true;
    for(int i = 0; i < points.length; i++){
      if(first){
        canvas.clipRect(Rect.fromPoints(const Offset(0,0), Offset(width, height)));
        canvas.translate(-xScale * xStart, height);
        canvas.scale(xScale, -1);
        first = false;
        continue;
      }
      canvas.drawLine(
        points[i - 1],
        points[i],
        painter
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}