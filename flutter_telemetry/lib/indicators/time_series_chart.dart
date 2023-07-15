import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/dialogs/chart_settings_dialog.dart';
import 'package:flutter_telemetry/dialogs/dialog.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

class ChartSetting{
  ChartSetting({
    required this.yMax,
    required this.yMin,
    required this.showSeconds,
    required this.gridOn,
    required this.realTime,
    required this.enteredRealtime,
    required this.isAtEnd,
    required this.startShowTimestamp
  });

  double yMax;
  double yMin;
  int showSeconds;
  bool gridOn;
  bool realTime;
  bool enteredRealtime;
  bool isAtEnd;
  int startShowTimestamp;

  ChartSetting update({double? yMax, double? yMin, int? showSeconds, bool? gridOn, bool? realTime, int? startShowTimestamp, bool? enteredRealtime, bool? isAtEnd}){
    this.yMax = yMax ?? this.yMax;
    this.yMin = yMin ?? this.yMin;
    this.showSeconds = showSeconds ?? this.showSeconds;
    this.gridOn = gridOn ?? this.gridOn;
    this.realTime = realTime ?? this.realTime;
    this.enteredRealtime = enteredRealtime ?? this.enteredRealtime;
    this.isAtEnd = isAtEnd ?? this.isAtEnd;
    this.startShowTimestamp = startShowTimestamp ?? this.startShowTimestamp;
    return this;
  }  
}

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
  ChartSetting chartSetting = ChartSetting(yMax: 100, yMin: 0, showSeconds: settings['chartShowSeconds']!.value, gridOn: true, realTime: true, startShowTimestamp: 0, enteredRealtime: false, isAtEnd: false);

  late Function toggleVisibility;
  late Function resetState;
  late String folded;

  @override
  void initState() {
    folded = widget.subscribedSignals.fold("", (previousValue, element) => "$previousValue$element");
    if(chartSettings.keys.contains(folded)){
      chartSetting = chartSettings[folded]!;
    }
    else{
      chartSetting.yMax = widget.max;
      chartSetting.yMin = widget.min;
      chartSettings[folded] = chartSetting;
    }

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

  void update(ChartSetting newSetting){
    chartSettings[folded] = newSetting;
    chartSetting = newSetting;
    resetState();
    setState(() {});
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
                  max: chartSetting.yMax,
                  min: chartSetting.yMin,
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
                          IconButton(
                            onPressed: () async {
                              showDialog<Widget>(
                                barrierDismissible: false,
                                context: tabContext,
                                builder: (BuildContext context) => DialogBase(title: "Chart settings for ${widget.title}", dialog: ChartSettingDialog(updater: update, chartSetting: chartSetting,), minWidth: 400, maxWidth: 500,)
                              );
                            },
                            padding: const EdgeInsets.all(0),
                            splashRadius: iconSplashRadius,
                            icon: Icon(Icons.settings, color: primaryColor,),
                          ),
                          Flexible(
                            child: ChartSlider(chartIdentifier: folded, updater: update,)
                          ),
                          for(int i = 0; i < labels.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                              child: TextButton(
                                onPressed: () {toggleVisibility(i);},
                                child: AdvancedTooltip(
                                  tooltipText: "Listening to ${widget.subscribedSignals[i]}",
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
                                  child: Divider(
                                    thickness: borderWidth,
                                    color: Colors.grey.withOpacity(0.4),
                                  )
                                ),
                              TimeSeriesPlotArea(
                                subscribedSignals: widget.subscribedSignals,
                                max: chartSetting.yMax,
                                min: chartSetting.yMin,
                                canvasHeight: canvasHeight,
                                canvasWidth: canvasWidth,
                                chartSetting: chartSetting,
                                onInitialized: (Function visibility, Function reset) {
                                  toggleVisibility = visibility;
                                  resetState = reset;
                                },
                              ),
                            ]
                          )
                        ),
                        SizedBox(
                          height: xAxisHeight,
                          width: canvasWidth,
                          child: XAxis(width: canvasWidth, chartSetting: chartSetting,),
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
    required this.chartSetting,
    required this.onInitialized
  });

  final List<String> subscribedSignals;
  final double min;
  final double max;
  final double canvasHeight;
  final double canvasWidth;
  final ChartSetting chartSetting;
  final Function onInitialized;

  @override
  State<StatefulWidget> createState() {
    return TimeSeriesPlotAreaState();
  }
}

class TimeSeriesPlotAreaState extends State<TimeSeriesPlotArea>{
  List<List<TimeSeriesPoint>> chartData = [];
  List<List<Offset>> chartDataPoints = [];
  late double yScale;
  late double yStart;
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

  void resetState(){
    if(timer.isActive){
      timer.cancel();
    }
    chartData = [];
    chartDataPoints = [];
    for(int i = 0; i < widget.subscribedSignals.length; i++){
      chartData.add([]);
      chartDataPoints.add([]);
    }
    timer = Timer.periodic(Duration(milliseconds: settings['chartrefreshTimeMS']!.value), (Timer t) => updateData());
  }

    @override
  void initState() {
    for(int i = 0; i < widget.subscribedSignals.length; i++){
      chartData.add([]);
      chartDataPoints.add([]);
      visibility.add(true);
    }
    xStart = DateTime.now().subtract(Duration(seconds: widget.chartSetting.showSeconds)).difference(appstartdate).inMilliseconds.toDouble();
    if(!widget.chartSetting.realTime){
      xStart = widget.chartSetting.startShowTimestamp.toDouble();
    }
    xScale = widget.canvasWidth / (widget.chartSetting.showSeconds * 1000);
    yScale = widget.canvasHeight / (widget.max - widget.min);
    yStart = widget.min;
    super.initState();
    widget.onInitialized(toggleVisibility, resetState);
    timer = Timer.periodic(Duration(milliseconds: settings['chartrefreshTimeMS']!.value), (Timer t) => updateData());
  }

  void updateData(){
    DateTime updateTimeLimit = DateTime.now().subtract(Duration(seconds: widget.chartSetting.showSeconds));
    
    xStart = updateTimeLimit.difference(appstartdate).inMilliseconds.toDouble();
    if(!widget.chartSetting.realTime){
      xStart = widget.chartSetting.startShowTimestamp.toDouble();
    }
    xScale = widget.canvasWidth / (widget.chartSetting.showSeconds * 1000);
    yStart = widget.min;
    yScale = widget.canvasHeight / (widget.max - widget.min);

    if(widget.chartSetting.enteredRealtime){
      chartData = [];
      chartDataPoints = [];
      for(int i = 0; i < widget.subscribedSignals.length; i++){
        chartData.add([]);
        chartDataPoints.add([]);
      }
      widget.chartSetting.enteredRealtime = false;
    }

    for(int i = 0; i < widget.subscribedSignals.length; i++){
      List? tempVal = [];
      List<DateTime>? tempTime = [];
      int toSkip = 0;
      bool needsUpdate = false;

      if(widget.chartSetting.realTime){
        if(chartData[i].isEmpty){
          tempTime = signalTimestamps[widget.subscribedSignals[i]];
          if(tempTime != null){
            tempVal = signalValues[widget.subscribedSignals[i]];
            needsUpdate = true;
          }
        }
        else{
          tempTime = signalTimestamps[widget.subscribedSignals[i]]?.reversed.takeWhile((value) => !value.isBefore(chartData[i].last.timestamp)).toList().reversed.toList();
          
          if(tempTime != null){
            toSkip = tempTime.length;
            tempVal = signalValues[widget.subscribedSignals[i]]?.reversed.take(toSkip).toList().reversed.toList();
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
                tempTime[j].difference(appstartdate).inMilliseconds.toDouble(),
                tempVal[j].toDouble()
              ));
            }
          }
        }
        // Split at last x sec
        chartData[i] = chartData[i].skipWhile((value) => value.timestamp.isBefore(updateTimeLimit)).toList();
        toSkip = chartDataPoints[i].length - chartData[i].length;
        chartDataPoints[i] = chartDataPoints[i].skip(toSkip).toList();
      }
      else{
        if(chartDataPoints[i].isEmpty){
          tempTime = signalTimestamps[widget.subscribedSignals[i]]!.skipWhile((value) => value.difference(appstartdate).inMilliseconds < xStart).toList();
          final int startIndex = signalTimestamps[widget.subscribedSignals[i]]!.length - tempTime.length;
          tempTime = tempTime.takeWhile((value) => value.difference(appstartdate).inMilliseconds < xStart + widget.chartSetting.showSeconds * 1000).toList();
          if(tempTime.isNotEmpty){
            tempVal = signalValues[widget.subscribedSignals[i]]!.sublist(startIndex, startIndex + tempTime.length);
          }
        }
        else{
          if (chartDataPoints[i].first.dx >= xStart && chartDataPoints[i].first.dx <= xStart * 1.1 &&
            chartDataPoints[i].last.dx <= xStart + widget.chartSetting.showSeconds * 1000 &&
            chartDataPoints[i].last.dx >= (xStart + widget.chartSetting.showSeconds * 1000) * 0.9 && !widget.chartSetting.isAtEnd){
            return;
          }
          else{
            if(widget.chartSetting.isAtEnd){
              tempTime = signalTimestamps[widget.subscribedSignals[i]]!.skipWhile((value) => value.difference(appstartdate).inMilliseconds < chartDataPoints[i].last.dx).toList();
              final int startIndex = signalTimestamps[widget.subscribedSignals[i]]!.length - tempTime.length;
              tempTime = tempTime.takeWhile((value) => value.difference(appstartdate).inMilliseconds < xStart + widget.chartSetting.showSeconds * 1000).toList();
              if(tempTime.isNotEmpty){
                tempVal = signalValues[widget.subscribedSignals[i]]!.sublist(startIndex, startIndex + tempTime.length);
              }
            }
            else{
              tempTime = signalTimestamps[widget.subscribedSignals[i]]!.skipWhile((value) => value.difference(appstartdate).inMilliseconds < xStart).toList();
              final int startIndex = signalTimestamps[widget.subscribedSignals[i]]!.length - tempTime.length;
              tempTime = tempTime.takeWhile((value) => value.difference(appstartdate).inMilliseconds < xStart + widget.chartSetting.showSeconds * 1000).toList();
              if(tempTime.isNotEmpty){
                tempVal = signalValues[widget.subscribedSignals[i]]!.sublist(startIndex, startIndex + tempTime.length);
              }
            }
          }
        }
        if((tempVal.isEmpty) && (tempTime.isEmpty)){
          //pass
        }
        else if(!widget.chartSetting.isAtEnd){
          chartDataPoints[i] = [];
          for(int j = 0; j < tempTime.length; j++){
            chartDataPoints[i].add(Offset(
              tempTime[j].difference(appstartdate).inMilliseconds.toDouble(),
              tempVal[j].toDouble()
            ));
          }
        }
        else if(widget.chartSetting.isAtEnd){
          for(int j = 0; j < tempTime.length; j++){
            chartDataPoints[i].add(Offset(
              tempTime[j].difference(appstartdate).inMilliseconds.toDouble(),
              tempVal[j].toDouble()
            ));
          }
          chartDataPoints[i] = chartDataPoints[i].skipWhile((value) => value.dx <= xStart).toList();
        }
      }
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
              painter: ChartLinePainter(widget.canvasWidth, widget.canvasHeight, chartDataPoints[i], xScale, xStart, yScale, yStart, _colormap[i]!),
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
  final double yScale;
  final double yStart;
  final Color lineColor;
  List<Offset> points;

  ChartLinePainter(this.width, this.height, this.points, this.xScale, this.xStart, this.yScale, this.yStart, this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    bool first = true;
    Paint painter = chartLinePainterBase..color = lineColor;
    Path path = Path();
    for(int i = 0; i < points.length; i++){
      if(first){
        canvas.clipRect(Rect.fromPoints(const Offset(0,0), Offset(width, height - borderWidth)));
        canvas.translate(-xScale * xStart, height + yStart * yScale);
        canvas.scale(1, -1);
        path.moveTo(points[i].dx * xScale, points[i].dy * yScale);
        first = false;
        continue;
      }
      path.lineTo(points[i].dx * xScale, points[i].dy * yScale);
    }
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ChartSlider extends StatefulWidget{
  const ChartSlider({super.key, required this.chartIdentifier, required this.updater});

  final String chartIdentifier;
  final Function updater;

  @override
  State<ChartSlider> createState() => _ChartSliderState();
}

class _ChartSliderState extends State<ChartSlider> {
  late Timer timer;
  int appTimeMS = 0;
  double min = 0;
  double max = 1;

  @override
  void initState() {    
    appTimeMS = DateTime.now().difference(appstartdate).inMilliseconds;
    min = appTimeMS - settings['signalValuesToKeep']!.value * 1000 * 60;
    max = appTimeMS - chartSettings[widget.chartIdentifier]!.showSeconds * 1000;
    chartSettings[widget.chartIdentifier]!.startShowTimestamp = 0;
    chartSettings[widget.chartIdentifier]!.realTime = true;
    timer = Timer.periodic(Duration(milliseconds: settings['chartrefreshTimeMS']!.value), (timer) {update();});
    super.initState();
  }

  void update(){
    appTimeMS = DateTime.now().difference(appstartdate).inMilliseconds;
    min = appTimeMS - settings['signalValuesToKeep']!.value * 1000 * 60;
    max = appTimeMS - chartSettings[widget.chartIdentifier]!.showSeconds * 1000;
    if(chartSettings[widget.chartIdentifier]!.startShowTimestamp <= min){
      chartSettings[widget.chartIdentifier]!.startShowTimestamp = min.toInt();
      chartSettings[widget.chartIdentifier]!.isAtEnd = true;
    }
    else if(chartSettings[widget.chartIdentifier]!.startShowTimestamp >= max){
      chartSettings[widget.chartIdentifier]!.startShowTimestamp -= max.toInt();
      chartSettings[widget.chartIdentifier]!.isAtEnd = false;
    }
    else{
      chartSettings[widget.chartIdentifier]!.isAtEnd = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: min,
      max: max,
      activeColor: primaryColor,
      value: chartSettings[widget.chartIdentifier]!.realTime ? max : chartSettings[widget.chartIdentifier]!.startShowTimestamp.toDouble(),
      onChanged: (newValue){
        if(newValue == max){
          chartSettings[widget.chartIdentifier]!.realTime = true;
          chartSettings[widget.chartIdentifier]!.enteredRealtime = true;
        }
        else{
          chartSettings[widget.chartIdentifier]!.startShowTimestamp = newValue.toInt();
          chartSettings[widget.chartIdentifier]!.realTime = false;

        }
        setState(() {});
      }
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
                  child: Text(representNumber("${max - i * valueIncrement}", maxDigit: 6), style: const TextStyle(fontSize: chartLabelFontSize),)
                ),
                CustomPaint(painter: TickPainter(true),),
              ],
            ),
          )
      ]
    );
  }
}

class XAxis extends StatefulWidget{
  const XAxis({super.key, required this.width, required this.chartSetting});

  final double width;
  final ChartSetting chartSetting;

  @override
  State<XAxis> createState() => _XAxisState();
}

class _XAxisState extends State<XAxis> {
  double increment = 0;
  double valueIncrement = 0;
  int timeOffset = 0;
  late Timer timer;

  @override
  void initState() {
    increment = (widget.width - borderWidth) / (verticalTickCount + 1);
    valueIncrement = widget.chartSetting.showSeconds / (verticalTickCount + 1);
    timeOffset = widget.chartSetting.realTime ? 0 : DateTime.now().difference(appstartdate).inSeconds - widget.chartSetting.showSeconds - widget.chartSetting.startShowTimestamp ~/ 1000;
    timer = Timer.periodic(Duration(milliseconds: settings['chartrefreshTimeMS']!.value), (timer) {update();});
    super.initState();
  }

  void update(){
    valueIncrement = widget.chartSetting.showSeconds / (verticalTickCount + 1);
    timeOffset = widget.chartSetting.realTime ? 0 : DateTime.now().difference(appstartdate).inSeconds - widget.chartSetting.showSeconds - widget.chartSetting.startShowTimestamp ~/ 1000;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text("${representNumber("${-(verticalTickCount - i) * valueIncrement - timeOffset}", maxDigit: 10)} s", style: const TextStyle(fontSize: chartLabelFontSize),)
                )
              ],
            ),
          )
      ],
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
