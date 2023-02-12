import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WaveformChartElement {
  const WaveformChartElement(this.y, this.time);
  final num y;
  final DateTime time;
}

class WaveformChart extends StatefulWidget{
  const WaveformChart({
    Key? key,
    required this.subscribedSignals,
    required this.title,
    required this.min,
    required this.max,
    required this.multiplier,
  }) : super(key: key);

  final List<String> subscribedSignals;
  final String title;
  final double min;
  final double max;
  final List<double> multiplier;
  
  @override
  State<StatefulWidget> createState() {
    return WaveformChartState();
  }
}

class WaveformChartState extends State<WaveformChart>{
  List<WaveformChartElement> chartData1 = [];
  List<WaveformChartElement> chartData2 = [];
  List<WaveformChartElement> chartData3 = [];
  List<WaveformChartElement> chartData4 = [];
  List<List<WaveformChartElement>> chartData = [];
  final List<ChartSeriesController?> _controller = [];
  late Timer timer;
  static const Map<int, Color> _colormap = {
    0: Colors.red,
    1: Colors.green,
    2: Colors.blue,
    3: Colors.yellow,
  };
  List<String> labels = [];
  //List<bool> visibility = [];

  @override
  void initState() {
    super.initState();
    chartData = [chartData1, chartData2, chartData3, chartData4];
    for(int i = 0; i < widget.subscribedSignals.length; i++){
      _controller.add(null);
      if(labelRemap.containsKey(widget.subscribedSignals[i])){
        labels.add(labelRemap[widget.subscribedSignals[i]]!);
      }
      else{
        labels.add(widget.subscribedSignals[i].replaceAll('_', ' '));
      }
      List? tempVal = signalValues[widget.subscribedSignals[i]];
      List? tempTime = signalTimestamps[widget.subscribedSignals[i]];
      if(tempVal != null && tempTime != null && tempVal.isNotEmpty && tempTime.isNotEmpty){
        if(tempVal.length > settings['chartSignalValuesToKeep'][0]){
          tempVal = tempVal.sublist(tempVal.length - 128);
          tempTime = tempTime.sublist(tempTime.length - 128);
        }
        for(int j = 0; j < tempVal.length; j++){
          chartData[i].add(WaveformChartElement(widget.multiplier[i] * tempVal[j], tempTime[j]));
        }
      }
      else{
        chartData[i] = [WaveformChartElement(0, DateTime.now())];
      }
    }
    timer = Timer.periodic(Duration(milliseconds: settings['chartrefreshTimeMS'][0]), (Timer t) => updateData());
  }

  void updateData(){
    for(int i = 0; i < widget.subscribedSignals.length; i++){ // TODO fetch in isolate chartData[i], signalValues, signalTimestamps => chartData[i] with all new, change cnt (addedindexes = range(len, len-cnt) removed indexes = range(0, cnt)) ezt lehet mindenkinek egyszerre is és akkor listák mennek be és ki
      dynamic tempVal = signalValues[widget.subscribedSignals[i]]?.last;
      dynamic tempTime = signalTimestamps[widget.subscribedSignals[i]]?.last;
      if(tempVal == null && tempTime == null && _controller[i] != null){
        if(chartData.any((element) => element.isNotEmpty ? element.last.time.isAfter(chartData[i].first.time) : false)){
          chartData[i].removeAt(0);
          chartData[i].add(WaveformChartElement(widget.min - 1000, DateTime.now()));
          _controller[i]!.updateDataSource(
            addedDataIndex: chartData[i].length - 1,
            removedDataIndex: 0
          );
        }
      }
      else if(_controller[i] != null){
        if(chartData[i].last.time != tempTime){
          chartData[i].add(WaveformChartElement(widget.multiplier[i] * tempVal, tempTime));
          if(chartData[i].length >= settings['chartSignalValuesToKeep'][0]){
            chartData[i].removeAt(0);
            _controller[i]!.updateDataSource(
              addedDataIndex: chartData[i].length - 1,
              removedDataIndex: 0
            );
          }
          else{
            _controller[i]!.updateDataSource(
              addedDataIndex: chartData[i].length - 1
            );
          }
        } 
      }
    }    
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: defaultPadding * 10, right: defaultPadding * 2),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const Spacer(),
            for(int i = 0; i < widget.subscribedSignals.length; i++)
              TextButton(
                onPressed: () { /* TODO toggle plot visibility ezt vhogy setstate nélkül kéne mert az valahogy leválasztja a timert a widgettől */ },
                child: Text(labels[i],
                  style: TextStyle(color: _colormap[i]),
                ),
              ),
          ],
        ),
        SfCartesianChart(
          enableAxisAnimation: false,
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(
              color: Colors.transparent,
            ),
            labelStyle: TextStyle(color: textColor),
          ),
          primaryYAxis: NumericAxis(
            minimum: widget.min,
            maximum: widget.max,
            majorGridLines: MajorGridLines(
              color: secondaryColor,
              width: 1,
            ),
            labelStyle: TextStyle(color: textColor),
          ),
          series: [
            for(int i = 0; i < widget.subscribedSignals.length; i++)
              FastLineSeries<WaveformChartElement,DateTime>(
                onRendererCreated: (ChartSeriesController controller) {
                  _controller[i] = (controller);
                },
                dataSource: chartData[i],
                xValueMapper: (WaveformChartElement elem, _) => elem.time,
                yValueMapper: (WaveformChartElement elem, _) => elem.y,
                color: _colormap[i],
                animationDuration: 0,
                //isVisible: visibility[i]
              )
          ]
        )
      ],
    );
  }

  @override
  void dispose() {
    timer.cancel();
    chartData.clear();
    _controller.clear();
    super.dispose();
  }
}
