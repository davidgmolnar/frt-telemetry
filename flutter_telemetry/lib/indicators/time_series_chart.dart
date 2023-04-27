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

double titleHeight = 30;
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
  List<String> labels = [];
  static const Map<int, Color> _colormap = {
    0: Color.fromARGB(255, 255, 17, 0),
    1: Color.fromARGB(255, 0, 255, 8),
    2: Colors.blue,
    3: Colors.yellow,
    4: Colors.purple,
    5: Colors.brown
  };

  late Function toggleVisibility;

  @override
  void initState() {
    for(int i = 0; i < widget.subscribedSignals.length; i++){
      if(labelRemap.containsKey(widget.subscribedSignals[i])){
        labels.add(labelRemap[widget.subscribedSignals[i]]!);
      }
      else{
        labels.add(widget.subscribedSignals[i].replaceAll('_', ' '));
      }
    }
    super.initState();
  }

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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding * 6),
                      child: Text(widget.title, style: const TextStyle(fontSize: subTitleFontSize),),
                    ),
                    const Spacer(),
                    for(int i = 0; i < labels.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                        child: TextButton(
                          onPressed: () {toggleVisibility(i);},
                          child: Text(labels[i], style: TextStyle(color: _colormap[i]),)
                        ),
                      )
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
                        visibilitySetter: (setter) {
                          toggleVisibility = setter;
                        },
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
    required this.canvasWidth,
    required this.visibilitySetter
  });

  final List<String> subscribedSignals;
  final double min;
  final double max;
  final double canvasHeight;
  final double canvasWidth;
  final Function visibilitySetter;

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
  List<bool> visibility = [];

  late Timer timer;
  static const Map<int, Color> _colormap = {
    0: Color.fromARGB(255, 255, 17, 0),
    1: Color.fromARGB(255, 0, 255, 8),
    2: Colors.blue,
    3: Colors.yellow,
    4: Colors.purple,
    5: Colors.brown
  };

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

  void toggleVisibility(int i){
    if(i < visibility.length){
      visibility[i] = !visibility[i];
      setState(() {});
    }
  }

    @override
  void initState() {
    yScale = widget.canvasHeight / (widget.max - widget.min);

    for(int i = 0; i < widget.subscribedSignals.length; i++){
      chartData.add([]);
      chartDataPoints.add([]);
      visibility.add(true);
    }
    xScale = refreshXScale();
    xStart = refreshXStart();
    
    super.initState();
    widget.visibilitySetter(toggleVisibility);
    timer = Timer.periodic(Duration(milliseconds: settings['chartrefreshTimeMS']![0]), (Timer t) => updateData());
  }

  void updateData(){
    DateTime updateTimeLimit = DateTime.now().subtract(const Duration(seconds: 60)); // param
    if(settings['chartLoadMode']![0] == 0){ // 0 lazy 1 complete
      // remélhetőleg nem lesz
    }
    else{
      for(int i = 0; i < widget.subscribedSignals.length; i++){
        List? tempVal = [];
        List<DateTime>? tempTime = [];
        int toSkip = 0;

        if(chartData[i].isEmpty){
          tempTime = signalTimestamps[widget.subscribedSignals[i]];
          if(tempTime == null){
            return;
          }
          tempVal = signalValues[widget.subscribedSignals[i]];
        }
        else{
          tempTime = signalTimestamps[widget.subscribedSignals[i]]?.skipWhile((value) => !value.isAfter(chartData[i].last.timestamp)).toList();
          if(tempTime == null){
            return;
          }
          toSkip = signalValues[widget.subscribedSignals[i]]!.length - tempTime.length;
          tempVal = signalValues[widget.subscribedSignals[i]]?.skip(toSkip).toList();
        }

        if((tempVal == null || tempVal.isEmpty) && (tempTime.isEmpty)){
          //pass
        }
        else if(chartData[i].isEmpty || tempTime.isNotEmpty && tempTime.last.isAfter(chartData[i].last.timestamp)){
          for(int j = 0; j < tempTime.length; j++){
            chartData[i].add(TimeSeriesPoint(tempVal![j], tempTime[j]));
            chartDataPoints[i].add(Offset(
              tempTime[j].difference(appstartdate).inMilliseconds.toDouble(),
              tempVal[j] * yScale
            ));
          }
          
          // Split at last x sec
          chartData[i] = chartData[i].skipWhile((value) => value.timestamp.isBefore(updateTimeLimit)).toList();
          toSkip = chartDataPoints[i].length - chartData[i].length;
          chartDataPoints[i] = chartDataPoints[i].skip(toSkip).toList();
        }
      }
      xScale = refreshXScale();
      xStart = refreshXStart();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // clip is inside ChartLinePainter
      children: [
        for(int i = 0; i < widget.subscribedSignals.length; i++)
          if(visibility[i])
            CustomPaint(
              painter: ChartLinePainter(widget.canvasWidth, widget.canvasHeight, chartDataPoints[i], xScale, xStart, _colormap[i]!),
            )
          else
            Container()
      ]
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
    Paint painter = Paint()..color = lineColor..style = PaintingStyle.stroke..strokeWidth = 3;  // TODO ez kinn
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
    return true;
  }

}