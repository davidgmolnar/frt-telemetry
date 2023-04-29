import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class TimeSeriesPoint{
  const TimeSeriesPoint(this.signalValue, this.timestamp);
  final num signalValue;
  final DateTime timestamp;
}

const double fullHeight = 330;
const double titleHeight = 30;
const double xAxisHeight = 30;
const double borderWidth = 1;
const double yAxisHeight =  fullHeight - 2 * defaultPadding - 2 * borderWidth;
const double canvasHeight = fullHeight - titleHeight - 2 * defaultPadding - 2 * borderWidth - xAxisHeight;
const double yAxisWidth = 40;

const int horizontalGridCount = 5;
const int verticalTickCount = 3;
const double tickLength = 5;
const double gridWidth = 3;
Color borderColor = Colors.grey.shade700;
Paint tickPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = borderWidth..color = borderColor;
Paint chartLinePainterBase = Paint()..style = PaintingStyle.stroke..strokeWidth = 0.5; 

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
    double increment = (canvasHeight - borderWidth) / horizontalGridCount;
    return LayoutBuilder(
      builder: (context , constraints) {
        double canvasWidth = constraints.maxWidth - yAxisWidth - 2 * defaultPadding - 2 * borderWidth;
        return Container(
          height: fullHeight,
          width: constraints.maxWidth,
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: yAxisHeight,
                width: yAxisWidth,
                child: YAxis(
                  max: widget.max,
                  min: widget.min,
                  height: yAxisHeight,
                  topInset: titleHeight,
                  bottomInset: xAxisHeight,
                ),
              ),
              SizedBox(
                width: constraints.maxWidth - yAxisWidth - 2 * defaultPadding,
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
                                child: Tooltip(
                                  message: "Listening to ${widget.subscribedSignals[i]}",
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(5.0)
                                  ),
                                  textStyle: TextStyle(color: textColor),
                                  showDuration: Duration(milliseconds: tooltipShowMs),
                                  waitDuration: Duration(milliseconds: tooltipWaitMs),
                                  verticalOffset: 10,
                                  child: Text(labels[i], style: TextStyle(color: _colormap[i], fontSize: chartLabelFontSize),)
                                )
                              ),
                            )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: borderColor,
                              width: borderWidth,
                            )
                          ),
                          height: canvasHeight,
                          width: canvasWidth,
                          child: Stack(
                            children: [
                              for(int i = 1; i < horizontalGridCount; i++)
                                Transform.translate(
                                  offset: Offset(0, i * increment - defaultPadding - borderWidth / 2),
                                  child: const Divider(
                                    thickness: borderWidth,
                                  )
                                ),
                              TimeSeriesPlotArea(
                                subscribedSignals: widget.subscribedSignals,
                                max: widget.max,
                                min: widget.min,
                                canvasHeight: canvasHeight,
                                canvasWidth: canvasWidth,
                                visibilitySetter: (setter) {
                                  toggleVisibility = setter;
                                },
                              ),
                            ]
                          )
                        ),
                        SizedBox(
                          height: xAxisHeight,
                          width: canvasWidth,
                          child: XAxis(width: canvasWidth,),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TimeSeriesPlotArea extends StatefulWidget{
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

  void toggleVisibility(int i){
    if(i < visibility.length){
      visibility[i] = !visibility[i];
      setState(() {});
    }
  }

    @override
  void initState() {
    for(int i = 0; i < widget.subscribedSignals.length; i++){
      chartData.add([]);
      chartDataPoints.add([]);
      visibility.add(true);
    }
    xStart = DateTime.now().subtract(Duration(seconds: settings['chartShowSeconds']![0])).difference(appstartdate).inMilliseconds.toDouble();
    xScale = widget.canvasWidth / (settings['chartShowSeconds']![0] * 1000);
    yScale = widget.canvasHeight / (widget.max - widget.min);
    super.initState();
    widget.visibilitySetter(toggleVisibility);
    timer = Timer.periodic(Duration(milliseconds: settings['chartrefreshTimeMS']![0]), (Timer t) => updateData());
  }

  void updateData(){
    DateTime updateTimeLimit = DateTime.now().subtract(Duration(seconds: settings['chartShowSeconds']![0])); // param
    if(settings['chartLoadMode']![0] == 0){ // 0 lazy 1 complete
      // remélhetőleg nem lesz
    }
    else{
      for(int i = 0; i < widget.subscribedSignals.length; i++){
        List? tempVal = [];
        List<DateTime>? tempTime = [];
        int toSkip = 0;
        bool needsUpdate = false;

        if(chartData[i].isEmpty){
          tempTime = signalTimestamps[widget.subscribedSignals[i]];
          if(tempTime != null){
            tempVal = signalValues[widget.subscribedSignals[i]];
            needsUpdate = true;
          }
        }
        else{
          tempTime = signalTimestamps[widget.subscribedSignals[i]]?.skipWhile((value) => !value.isAfter(chartData[i].last.timestamp)).toList();
          if(tempTime != null){
            toSkip = signalValues[widget.subscribedSignals[i]]!.length - tempTime.length;
            tempVal = signalValues[widget.subscribedSignals[i]]?.skip(toSkip).toList();
            needsUpdate = true;
          }
        }
        if(needsUpdate){
          if((tempVal == null || tempVal.isEmpty) && (tempTime!.isEmpty)){
            //pass
          }
          else if(chartData[i].isEmpty || tempTime!.isNotEmpty && tempTime.last.isAfter(chartData[i].last.timestamp)){
            for(int j = 0; j < tempTime!.length; j++){
              chartData[i].add(TimeSeriesPoint(tempVal![j], tempTime[j]));
              chartDataPoints[i].add(Offset(
                tempTime[j].difference(appstartdate).inMilliseconds.toDouble() * xScale,
                tempVal[j] * yScale + borderWidth
              ));
            }
          }
        }
        // Split at last x sec
        chartData[i] = chartData[i].skipWhile((value) => value.timestamp.isBefore(updateTimeLimit)).toList();
        toSkip = chartDataPoints[i].length - chartData[i].length;
        chartDataPoints[i] = chartDataPoints[i].skip(toSkip).toList();
      }
      xStart = updateTimeLimit.difference(appstartdate).inMilliseconds.toDouble();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        for(int i = 0; i < widget.subscribedSignals.length; i++)
          if(visibility[i])
            CustomPaint(
              painter: ChartLinePainter(widget.canvasWidth, widget.canvasHeight, chartDataPoints[i], xScale, xStart, _colormap[i]!),
            )
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
    bool first = true;
    Paint painter = chartLinePainterBase..color = lineColor;
    Path path = Path();
    for(int i = 0; i < points.length; i++){
      if(first){
        canvas.clipRect(Rect.fromPoints(const Offset(0,0), Offset(width, height - borderWidth)));
        canvas.translate(-xScale * xStart, height);
        canvas.scale(1, -1);
        path.moveTo(points[i].dx, points[i].dy);
        first = false;
        continue;
      }
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class YAxis extends StatelessWidget{
  const YAxis({super.key, required this.min, required this.max, required this.height, required this.topInset, required this.bottomInset});

  final double min;
  final double max;
  final double height;
  final double topInset;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    double increment = (height - topInset - bottomInset - borderWidth) / horizontalGridCount;
    double valueIncrement = (max - min)/horizontalGridCount;
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.topEnd,
      children: [
        for(int i = 0; i < horizontalGridCount + 1; i++)
          Transform.translate(
            offset: Offset(borderWidth, topInset + borderWidth/2 + i * increment),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(-tickLength, -chartLabelFontSize* 3/4),
                  child: Text(representNumber("${max - i * valueIncrement}", maxDigit: 5), style: const TextStyle(fontSize: chartLabelFontSize),)
                ),
                CustomPaint(painter: TickPainter(true),),
              ],
            ),
          )
      ]
    );
  }
}

class XAxis extends StatelessWidget{
  const XAxis({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    double increment = (width - borderWidth) / (verticalTickCount + 1);
    double valueIncrement = settings['chartShowSeconds']![0] / (verticalTickCount + 1);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        for(int i = 0; i < verticalTickCount; i++)
          Transform.translate(
            offset: Offset(borderWidth/2 + (i + 1) * increment ,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomPaint(painter: TickPainter(false)),
                Transform.translate(
                  offset: const Offset(-chartLabelFontSize, tickLength),
                  child: Text("-${representNumber("${settings['chartShowSeconds']![0] - (i + 1) * valueIncrement}", maxDigit: 4)} s", style: const TextStyle(fontSize: chartLabelFontSize),)
                )
              ],
            ),
          )
      ],
    );
  }
}

class TickPainter extends CustomPainter{

  final bool isHorizontal;

  TickPainter(this.isHorizontal);

  @override
  void paint(Canvas canvas, Size size) {
    if(isHorizontal){
      canvas.drawLine(const Offset(0,0), const Offset(-tickLength, 0), tickPaint);
    }
    else{
      canvas.drawLine(const Offset(0,0), const Offset(0, tickLength), tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
