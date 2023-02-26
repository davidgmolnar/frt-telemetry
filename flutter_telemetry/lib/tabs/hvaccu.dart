import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

List<Widget> hvAccuSmall = [

];

List<Widget> hvAccuBig = [
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const HVAccu(),
      Column(
        children: const [
          BooleanPanel(
            subscribedSignals: [
              "AIR_minus_state",
              "AIR_plus_state",
              "AMS_Relay_State"
            ],
            colsize: 16,
            title: "HV Status"
          ),
        ],
      )
    ],
  )
];

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