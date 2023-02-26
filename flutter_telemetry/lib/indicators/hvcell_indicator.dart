import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

enum ColumnType{
  voltageMeas,
  tempMeas,
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
    timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS'][0]), (Timer t) => updateData());
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
        Container(color: Colors.red,)
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
    timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS'][0]), (Timer t) => updateData());
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
        : Container(color: Colors.red,)
      ,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
          else{
            return HVCellTempIndicator(id: idx, width: 30, textScaleFactor: 0.7);
          }  
        }).toList()
      );
    }
  }
}
