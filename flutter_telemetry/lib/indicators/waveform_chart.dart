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
  List<WaveformChartElement> chartData = [];
  late Timer timer;
  ChartSeriesController? _chartSeriesController;

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => getDataWrapper());
    }

  void getDataWrapper(){  // TODO ez akkor lesz majd jó ha az app törli akkor ezt újra kell gondolni + több signalra is ki kell találni
    List<dynamic> temp = widget.getData(widget.subscribedSignals[0], true);  // ez most csak lastonly de majd összes lesz
    if(temp.isNotEmpty){
      chartData.add(WaveformChartElement(temp[0], DateTime.now()));
      if(chartData.length > chartSignalValuesToKeep){
        chartData.removeAt(0);
        _chartSeriesController!.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1],
          removedDataIndexes: <int>[0]
        );
      }
      else{
        _chartSeriesController!.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1]
        );
      }
    }
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
