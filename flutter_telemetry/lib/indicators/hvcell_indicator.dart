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
          horizontal: BorderSide(color: textColor, width: 2.0),
          vertical: BorderSide(color: textColor, width: 1.0),
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
              alignment: Alignment.center,
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
          horizontal: BorderSide(color: textColor, width: 2.0),
          vertical: BorderSide(color: textColor, width: 1.0),
        )
      ),
      width: widget.width + 2,
      height: 25 + 4,
      alignment: Alignment.center,
      child: value != -1 ?
        Text(representNumber(value.toString(), maxDigit: 3), textScaleFactor: widget.textScaleFactor,)
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
  Color displayedColor = Colors.grey.shade600;
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
            return HVCellTempIndicator(id: idx, width: 30, textScaleFactor: 0.8);
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
        const Text("-inf"),
        Container(width: 30, height: 15, decoration: BoxDecoration(border: Border.all(width: 0), color: tempColorBank[0]),),
        Text(tempBrakepoints[1].toInt().toString()),
        Container(width: 30, height: 15, decoration: BoxDecoration(border: Border.all(width: 0), color: tempColorBank[1]),),
        Text(tempBrakepoints[2].toInt().toString()),
        Container(width: 30, height: 15, decoration: BoxDecoration(border: Border.all(width: 0), color: tempColorBank[2]),),
        Text(tempBrakepoints[3].toInt().toString()),
        Container(width: 30, height: 15, decoration: BoxDecoration(border: Border.all(width: 0), color: tempColorBank[3]),),
        Text(tempBrakepoints[4].toInt().toString()),
        Container(width: 30, height: 15, decoration: BoxDecoration(border: Border.all(width: 0), color: tempColorBank[4]),),
        Text(tempBrakepoints[5].toInt().toString()),
        Container(width: 30, height: 15, decoration: BoxDecoration(border: Border.all(width: 0), color: tempColorBank[5]),),
        Text(tempBrakepoints[6].toInt().toString()),
        Container(width: 30, height: 15, decoration: BoxDecoration(border: Border.all(width: 0), color: tempColorBank[6]),),
        Text(tempBrakepoints[7].toInt().toString()),
        Container(width: 30, height: 15, decoration: BoxDecoration(border: Border.all(width: 0), color: tempColorBank[7]),),
        const Text("inf"),
      ],
    );
  }
  
}

class HVAccu extends StatelessWidget{
  const HVAccu({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HVCellColumn(measIds: hvCellIDRemap["Temp1"]!, type: ColumnType.tempMeas),
        HVCellColumn(measIds: hvCellIDRemap["Volt1"]!, type: ColumnType.voltageMeas),
        HVCellColumn(measIds: hvCellIDRemap["Temp2"]!, type: ColumnType.tempMeas),
        HVCellColumn(measIds: hvCellIDRemap["Volt2"]!, type: ColumnType.voltageMeas),
        HVCellColumn(measIds: hvCellIDRemap["Temp3"]!, type: ColumnType.tempMeas),
        HVCellColumn(measIds: hvCellIDRemap["Volt3"]!, type: ColumnType.voltageMeas),
        HVCellColumn(measIds: hvCellIDRemap["Temp4"]!, type: ColumnType.tempMeas),
        HVCellColumn(measIds: hvCellIDRemap["Temp5"]!, type: ColumnType.tempMeas),
        HVCellColumn(measIds: hvCellIDRemap["Volt4"]!, type: ColumnType.voltageMeas),
        HVCellColumn(measIds: hvCellIDRemap["Temp6"]!, type: ColumnType.tempMeas),
        HVCellColumn(measIds: hvCellIDRemap["Volt5"]!, type: ColumnType.voltageMeas),
        HVCellColumn(measIds: hvCellIDRemap["Temp7"]!, type: ColumnType.tempMeas),
        HVCellColumn(measIds: hvCellIDRemap["Volt6"]!, type: ColumnType.voltageMeas),
        HVCellColumn(measIds: hvCellIDRemap["Temp8"]!, type: ColumnType.tempMeas),
      ],
    );
  }
}

class HVColorMap extends StatelessWidget{
  const HVColorMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Row(
            children: [
              HVCellColumn(measIds: hvCellIDRemap["Temp1"]!, type: ColumnType.colormap),
              HVCellColumn(measIds: hvCellIDRemap["Temp2"]!, type: ColumnType.colormap),
              HVCellColumn(measIds: hvCellIDRemap["Temp3"]!, type: ColumnType.colormap),
              HVCellColumn(measIds: hvCellIDRemap["Temp4"]!, type: ColumnType.colormap),
              HVCellColumn(measIds: hvCellIDRemap["Temp5"]!, type: ColumnType.colormap),
              HVCellColumn(measIds: hvCellIDRemap["Temp6"]!, type: ColumnType.colormap),
              HVCellColumn(measIds: hvCellIDRemap["Temp7"]!, type: ColumnType.colormap),
              HVCellColumn(measIds: hvCellIDRemap["Temp8"]!, type: ColumnType.colormap),
            ],
          ),
        ),
        const SizedBox(width: 10,),
        const HVColorMapLegend()
      ],
    );
  }
}
