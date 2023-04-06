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
    0: Color.fromARGB(255, 255, 17, 0),
    1: Color.fromARGB(255, 0, 255, 8),
    2: Colors.blue,
    3: Colors.yellow,
    4: Colors.purple,
    5: Colors.brown
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
        if(tempVal.length > settings['chartSignalValuesToKeep']![0]){
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
    timer = Timer.periodic(Duration(milliseconds: settings['chartrefreshTimeMS']![0]), (Timer t) => updateData());
  }

  void updateData(){
    if(settings['chartLoadMode']![0] == 0){ // 0 lazy 1 complete
      for(int i = 0; i < widget.subscribedSignals.length; i++){
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
            if(chartData[i].length >= settings['chartSignalValuesToKeep']![0]){
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
    else{
      for(int i = 0; i < widget.subscribedSignals.length; i++){
        List? tempVal = signalValues[widget.subscribedSignals[i]];
        List<DateTime>? tempTime = signalTimestamps[widget.subscribedSignals[i]];
        bool didUpdate = false;
        if((tempVal == null || tempVal.isEmpty) && (tempTime == null || tempTime.isEmpty) && _controller[i] != null){  // Nem jött adat de van controllere
          //pass
        }
        else if(_controller[i] != null && tempTime!.last.isAfter(chartData[i].last.time) && tempTime.isNotEmpty){
          int newDataStartIdx = tempTime.length - 1;
          while(tempTime[newDataStartIdx].isAfter(chartData[i].last.time)){
            newDataStartIdx--;
          }
          newDataStartIdx++;
          int added = 0;
          int removed = 0;
          while(newDataStartIdx < tempTime.length){
            chartData[i].add(WaveformChartElement(widget.multiplier[i] * tempVal![newDataStartIdx], tempTime[newDataStartIdx]));
            if(chartData[i].length > settings['chartSignalValuesToKeep']![0]){
              chartData[i].removeAt(0);
              removed++;
            }
            added++;
            newDataStartIdx++;
            didUpdate = added > 0 || removed > 0;
          }
          _controller[i]!.updateDataSource(
            addedDataIndexes: List<int>.generate(added, (index) => chartData[i].length - added + index),
            removedDataIndexes: List<int>.generate(removed, (index) => index)
          );
        }
        if(!didUpdate){
          if(chartData.any((element) => element.length > 1 ? element.first.time.isAfter(chartData[i].last.time) : false)){
            int prevLen = chartData[i].length;
            chartData[i].clear();
            chartData[i].add(WaveformChartElement(widget.min - 1000, DateTime.now()));
            _controller[i]!.updateDataSource(
              addedDataIndex: 0,
              removedDataIndexes: List<int>.generate(prevLen, (index) => index)
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
                  style: TextStyle(color: _colormap[i], fontSize: chartLabelFontSize),
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
                animationDuration: settings['chartrefreshTimeMS']![0].toDouble(),
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
