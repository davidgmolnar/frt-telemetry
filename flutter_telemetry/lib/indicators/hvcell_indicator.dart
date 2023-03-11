import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

enum ColumnType{
  voltageMeas,
  tempMeas,
  colormap
}

class HVCellVoltageIndicator extends StatefulWidget{
  const HVCellVoltageIndicator({
    super.key,
    required this.id,
    required this.barWidth,
    required this.labelWidth,
    required this.textScaleFactor
  });

  final int id;
  final double barWidth;
  final double labelWidth;
  final double textScaleFactor;

  @override
  State<StatefulWidget> createState() {
    return HVCellVoltageIndicatorState();
  }
}

class HVCellVoltageIndicatorState extends State<HVCellVoltageIndicator>{
  double value = -1;
  double displayWidth = -1;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS']![0]), (Timer t) => updateData());
  }

  void updateData(){
    num? tmp = hvCellVoltages[widget.id.toString()];
    if(tmp != null && tmp != value){
      value = tmp.toDouble();
      displayWidth = normalizeInbetween(value, 0, 6000, 0, widget.barWidth.toInt()).toDouble();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade600, width: 2.0),
          vertical: BorderSide(color: Colors.grey.shade600, width: 1.0),
        )
      ),
      width: widget.barWidth + widget.labelWidth + 2,
      height: 25 + 4,
      child: displayWidth != -1 ? 
        Row(
          children: [
            Container(
              width: widget.labelWidth,
              height: 25,
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.centerLeft,
              color: secondaryColor,
              child: Text(representNumber(value.toString(), maxDigit: 5), textScaleFactor: widget.textScaleFactor,)
            ),
            Container(width: displayWidth, color: const Color.fromARGB(255, 255, 230, 0),),
            Container(width: widget.barWidth - displayWidth, color: bgColor,)
          ],
        )
        :
        Container(color: bgColor,)
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class HVCellTempIndicator extends StatefulWidget{
  const HVCellTempIndicator({
    super.key,
    required this.id,
    required this.width,
    required this.textScaleFactor
  });

  final int id;
  final double width;
  final double textScaleFactor;

  @override
  State<StatefulWidget> createState() {
    return HVCellTempIndicatorState();
  }
}

class HVCellTempIndicatorState extends State<HVCellTempIndicator>{
  double value = -1;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS']![0]), (Timer t) => updateData());
  }

  void updateData(){
    num? tmp = hvCellTemps[widget.id.toString()];
    if(tmp != null && tmp != value){
      value = tmp.toDouble();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade600, width: 2.0),
          vertical: BorderSide(color: Colors.grey.shade600, width: 1.0),
        )
      ),
      width: widget.width + 2,
      height: 25 + 4,
      alignment: Alignment.centerLeft,
      child: value != -1 ?
        Text(representNumber(value.toString(), maxDigit: 4), textScaleFactor: widget.textScaleFactor,)
        : Container(color: bgColor,)
      ,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class HVTempColorItem extends StatefulWidget{
  const HVTempColorItem({super.key, required this.id, required this.width, required this.height});

  final int id;
  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() {
    return HVTempColorItemState();
  }
}

class HVTempColorItemState extends State<HVTempColorItem>{
  double temp = -1;
  Color displayedColor = Colors.grey.shade700;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS']![0]), (Timer t) => updateData());
  }

  void updateData(){
    num? tmp = hvCellTemps[widget.id.toString()];
    if(tmp != null && tmp != temp){
      temp = tmp.toDouble();
      displayedColor = tempColorBank[tempBrakepoints.indexWhere((threshold) => threshold > temp) - 1];
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: displayedColor,
    );
  }
}

class HVCellColumn extends StatelessWidget{
  const HVCellColumn({
    super.key,
    required this.measIds,
    required this.type
  });

  final List<int> measIds;
  final ColumnType type;

  @override
  Widget build(BuildContext context) {
    if(measIds.length != 24){
      return RotatedBox(
        quarterTurns: 1,
        child: SizedBox(
          height: type == ColumnType.voltageMeas ? 92 : 32,
          child: const Text("Upsz", textAlign: TextAlign.center)
        ),
      );
    }
    else {
      return Column(
        children: measIds.map((idx) {
          if(type == ColumnType.voltageMeas){
            return HVCellVoltageIndicator(id: idx, barWidth: 60, labelWidth: 35, textScaleFactor: 0.7);
          }
          else if(type == ColumnType.tempMeas){
            return HVCellTempIndicator(id: idx, width: 30, textScaleFactor: 0.7);
          }
          else{
            return HVTempColorItem(id: idx, width: 30, height: 15);
          }
        }).toList()
      );
    }
  }
}

class HVColorMapLegend extends StatelessWidget{
  const HVColorMapLegend({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: 30, child: Text(tempBrakepoints[0].toString()),),
        Container(width: 30, height: 15, color: tempColorBank[0]),
        SizedBox(width: 30, child: Text(tempBrakepoints[1].toString()),),
        Container(width: 30, height: 15, color: tempColorBank[1]),
        SizedBox(width: 30, child: Text(tempBrakepoints[2].toString()),),
        Container(width: 30, height: 15, color: tempColorBank[2]),
        SizedBox(width: 30, child: Text(tempBrakepoints[3].toString()),),
        Container(width: 30, height: 15, color: tempColorBank[3]),
        SizedBox(width: 30, child: Text(tempBrakepoints[4].toString()),),
        Container(width: 30, height: 15, color: tempColorBank[4]),
        SizedBox(width: 30, child: Text(tempBrakepoints[5].toString()),),
        Container(width: 30, height: 15, color: tempColorBank[5]),
        SizedBox(width: 30, child: Text(tempBrakepoints[6].toString()),),
        Container(width: 30, height: 15, color: tempColorBank[6]),
        SizedBox(width: 30, child: Text(tempBrakepoints[7].toString()),),
        Container(width: 30, height: 15, color: tempColorBank[7]),
        SizedBox(width: 30, child: Text(tempBrakepoints[8].toString()),),        
      ],
    );
  }
  
}

class HVAccu extends StatelessWidget{
  const HVAccu({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        HVCellColumn(measIds: [78,84,84,90,91,97,97,103,104,110,110,106,117,123,123,129,130,136,136,142,143,149,149,155], type: ColumnType.tempMeas),
        HVCellColumn(measIds: [89,84,83,78,102,97,96,91,115,110,109,104,128,123,122,117,141,136,135,130,154,149,148,143], type: ColumnType.voltageMeas),
        HVCellColumn(measIds: [79,83,85,89,92,96,98,102,105,109,111,115,118,122,124,128,131,135,137,141,144,148,150,154], type: ColumnType.tempMeas),
        HVCellColumn(measIds: [88,85,82,79,101,98,95,92,114,111,108,105,127,124,121,118,140,137,134,131,153,150,147,145], type: ColumnType.voltageMeas),
        HVCellColumn(measIds: [80,82,86,88,93,95,99,101,106,108,112,114,119,121,125,127,132,134,138,140,145,147,151,153], type: ColumnType.tempMeas),
        HVCellColumn(measIds: [87,86,81,80,100,99,94,93,113,112,107,106,126,125,120,119,139,138,133,132,152,151,146,145], type: ColumnType.voltageMeas),
        HVCellColumn(measIds: [81,81,87,87,94,94,100,100,107,107,113,113,120,120,126,126,133,133,139,139,146,146,152,152], type: ColumnType.tempMeas),
        HVCellColumn(measIds: [74,74,68,68,61,61,55,55,48,48,42,42,35,35,29,29,22,22,16,16,9,9,3,3], type: ColumnType.tempMeas),
        HVCellColumn(measIds: [67,68,73,74,54,55,60,61,41,42,47,48,28,29,34,35,15,16,21,22,2,3,8,9], type: ColumnType.voltageMeas),
        HVCellColumn(measIds: [75,73,69,67,62,60,56,54,49,47,43,41,36,34,30,28,23,21,17,15,10,8,4,2], type: ColumnType.tempMeas),
        HVCellColumn(measIds: [66,69,72,75,53,56,59,62,40,43,46,49,27,30,33,36,14,17,20,23,1,4,7,10], type: ColumnType.voltageMeas),
        HVCellColumn(measIds: [76,72,70,66,63,59,57,53,50,46,44,40,37,33,31,27,24,20,18,14,11,7,5,1], type: ColumnType.tempMeas),
        HVCellColumn(measIds: [65,70,71,76,52,57,58,63,39,44,45,50,26,31,32,37,13,18,19,24,0,5,6,11], type: ColumnType.voltageMeas),
        HVCellColumn(measIds: [77,71,71,65,64,58,58,52,51,45,45,39,38,32,32,26,25,19,19,13,12,6,6,0], type: ColumnType.tempMeas),
      ],
    );
  }
}

class HVColorMap extends StatelessWidget{
  const HVColorMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: textColor == textColorBright ? BoxDecoration(border: Border.all(width: 2)): null,
      child: Row(
        children: const [
          HVCellColumn(measIds: [78,84,84,90,91,97,97,103,104,110,110,106,117,123,123,129,130,136,136,142,143,149,149,155], type: ColumnType.colormap),
          HVCellColumn(measIds: [79,83,85,89,92,96,98,102,105,109,111,115,118,122,124,128,131,135,137,141,144,148,150,154], type: ColumnType.colormap),
          HVCellColumn(measIds: [80,82,86,88,93,95,99,101,106,108,112,114,119,121,125,127,132,134,138,140,145,147,151,153], type: ColumnType.colormap),
          HVCellColumn(measIds: [81,81,87,87,94,94,100,100,107,107,113,113,120,120,126,126,133,133,139,139,146,146,152,152], type: ColumnType.colormap),
          HVCellColumn(measIds: [74,74,68,68,61,61,55,55,48,48,42,42,35,35,29,29,22,22,16,16,9,9,3,3], type: ColumnType.colormap),
          HVCellColumn(measIds: [75,73,69,67,62,60,56,54,49,47,43,41,36,34,30,28,23,21,17,15,10,8,4,2], type: ColumnType.colormap),
          HVCellColumn(measIds: [76,72,70,66,63,59,57,53,50,46,44,40,37,33,31,27,24,20,18,14,11,7,5,1], type: ColumnType.colormap),
          HVCellColumn(measIds: [77,71,71,65,64,58,58,52,51,45,45,39,38,32,32,26,25,19,19,13,12,6,6,0], type: ColumnType.colormap),
          SizedBox(width: 10,),
          HVColorMapLegend()
        ],
      ),
    );
  }
}
