import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WaveformChartElement {
  WaveformChartElement(this.y, this.time);
  final num y;
  final DateTime time;
}

class WaveformChart extends StatefulWidget{
  WaveformChart({
  Key? key,
  required this.getData,
  required this.subscribedSignals,
  required this.title,
  required this.flex,
  }) : super(key: key);

  final Function getData;
  final List<String> subscribedSignals;
  final String title;
  final int flex;
  
  @override
  State<StatefulWidget> createState() {
    return WaveformChartState();
  }

}

class WaveformChartState extends State<WaveformChart>{
  List<WaveformChartElement> chartData = [];  //TODO erre majd ki kell találni valamit
  late Timer timer;
  ChartSeriesController? _chartSeriesController;
  List<dynamic>? lastReceived = [];

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(const Duration(milliseconds: highrefreshTimeMS), (Timer t) => getDataWrapper());
  }

  void getDataWrapper(){
    Map<String, List<dynamic>?> temp = widget.getData(widget.subscribedSignals[0], false, true);  // ez most csak lastonly de majd összes lesz
    if(temp["values"]!.isNotEmpty){
      if(chartData.isEmpty || chartData.last.time != temp["timestamps"]!.last){
        chartData.add(WaveformChartElement(temp["values"]![0], temp["timestamps"]![0]));
        if(chartData.length > chartSignalValuesToKeep){
          chartData.removeAt(0);
          _chartSeriesController!.updateDataSource(
            addedDataIndex: chartData.length - 1,
            removedDataIndex: 0
          );
        }
        else{
          _chartSeriesController!.updateDataSource(
            addedDataIndex: chartData.length - 1,
          );
        }

      }
    }
    /*// Todo kell logika arra hogy csak az új részét szedje ki a tempből  values = values[new:end] és timestamp=timestamp[new:end]
    if(temp["values"]!.isNotEmpty && temp["values"]!.length == temp["timestamps"]!.length){
      int added = 0, removed = 0;

      if(lastReceived!.isNotEmpty){
        if(lastReceived!.last == temp["timestamps"]!.last){
          return; // nincs mit tenni :(
        }
        else{
          int i = temp["timestamps"]!.length - 1;
          while(lastReceived!.last != temp["timestamps"]![i] && i > 0){
            i--;
          }
          i++;
          temp["values"] = temp["values"]!.sublist(i);
          temp["timestamps"] = temp["timestamps"]!.sublist(i);
          lastReceived = temp["timestamps"];
        }
      }

      for(int i = 0; i < temp["values"]!.length; i++){
        chartData.add(WaveformChartElement(temp["values"]![i], temp["timestamps"]![i]));
        added++;
      }
      while(chartData.length > chartSignalValuesToKeep){
        chartData.removeAt(0);
        removed++;
      }
      if(removed != 0){
        _chartSeriesController!.updateDataSource(
          addedDataIndexes: List.generate(added, (index) => chartData.length - 1 - index),
          removedDataIndexes: List.generate(removed, (index) => index),
        );
      }
      else{
        _chartSeriesController!.updateDataSource(
          addedDataIndexes: List.generate(added, (index) => chartData.length - 1 - index),
        );
      }
    }*/
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),)
        ),
        SfCartesianChart(
          primaryXAxis: DateTimeAxis(),
          series: <ChartSeries>[
            FastLineSeries<WaveformChartElement,DateTime>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: chartData,
              xValueMapper: (WaveformChartElement elem, _) => elem.time,
              yValueMapper: (WaveformChartElement elem, _) => elem.y,
              )
          ],
        )
      ],
    );
  }


}
