import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
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
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          for(int i = 0; i < widget.subscribedSignals.length; i++)
                            TimeSeriesPlotArea(
                              subscribedSignal: widget.subscribedSignals[i],
                              min: widget.min,
                              max: widget.max,
                              canvasHeight: canvasHeight,
                              canvasWidth: canvasWidth,
                            )
                        ]
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
    required this.subscribedSignal,
    required this.min,
    required this.max,
    required this.canvasHeight,
    required this.canvasWidth
  });

  final String subscribedSignal;
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
  List<TimeSeriesPoint> chartData = [];
  List<Offset> chartDataPoints = [];
  late double yScale;
  late double xScale;
  late double xStart;

    @override
  void initState() {
    yScale = widget.canvasHeight / (widget.max - widget.min);
    chartData = [];
    chartDataPoints = [];
    //
    chartData = widget.subscribedSignal == "AMK1_actual_velocity" ? 
    [
      TimeSeriesPoint(10, DateTime.now().add(const Duration(seconds: 1))),
      TimeSeriesPoint(15, DateTime.now().add(const Duration(seconds: 2))),
      TimeSeriesPoint(60, DateTime.now().add(const Duration(seconds: 4))),
    ]
    :
    [
      TimeSeriesPoint(10, DateTime.now().add(const Duration(seconds: 1))),
      TimeSeriesPoint(40, DateTime.now().add(const Duration(seconds: 4))),
      TimeSeriesPoint(5, DateTime.now().add(const Duration(seconds: 11))),
    ];
    //
    for(int i = 0; i < chartData.length; i++){
      chartDataPoints.add(Offset(
        chartData[i].timestamp.difference(appstartdate).inMilliseconds.toDouble(),
        chartData[i].signalValue * yScale
      ));
    }
    xScale = widget.canvasWidth / (chartDataPoints.last.dx - chartDataPoints.first.dx);
    xStart = chartDataPoints.first.dx;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ChartLinePainter(widget.canvasWidth, widget.canvasHeight, chartDataPoints, xScale, xStart),
    );
  }

}

class ChartLinePainter extends CustomPainter{
  final double width;
  final double height;
  final double xScale;
  final double xStart;
  List<Offset> points;

  Paint painter = Paint()..color = Colors.blue..style = PaintingStyle.stroke..strokeWidth = 2;

  ChartLinePainter(this.width, this.height, this.points, this.xScale, this.xStart);

  @override
  void paint(Canvas canvas, Size size) {
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