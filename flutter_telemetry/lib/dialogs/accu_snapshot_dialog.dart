import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/dialogs/dialog.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class AccuSnapshotDialog extends StatefulWidget{
  const AccuSnapshotDialog({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return AccuSnapshotDialogState();
  }
}

class AccuSnapshotDialogState extends State<AccuSnapshotDialog>{
  late List<int> bytes;

  void fillExcel(String timeString){
    // params
    double? filler = -1;

    final xlsio.Workbook excel = xlsio.Workbook();
    final xlsio.Worksheet sheet = excel.worksheets[0];
    sheet.name = "Cell Status";
    sheet.showGridlines = true;

    // metadata
    sheet.getRangeByName('A1').setText('Time');
    sheet.getRangeByName('B1').setText(timeString);

    sheet.getRangeByName('A3').setText('Max Temp');
    sheet.getRangeByName('B3').setText('value');
    sheet.getRangeByName('A4').setText('Max Temp ID');
    sheet.getRangeByName('B4').setText('id');
    
    sheet.getRangeByName('A6').setText('Max Voltage');
    sheet.getRangeByName('B6').setText('value');
    sheet.getRangeByName('A7').setText('Max Voltage ID');
    sheet.getRangeByName('B7').setText('id');
    
    sheet.getRangeByName('A9').setText('Min Temp');
    sheet.getRangeByName('B9').setText('value');
    sheet.getRangeByName('A10').setText('Min Temp ID');
    sheet.getRangeByName('B10').setText('id');
    
    sheet.getRangeByName('A12').setText('Min Voltage');
    sheet.getRangeByName('B12').setText('value');
    sheet.getRangeByName('A13').setText('Min Voltage ID');
    sheet.getRangeByName('B13').setText('id');

    sheet.getRangeByName('A1:B100').autoFitColumns();

    // volt title
    sheet.getRangeByName('D1')..setText("Cell Voltages")
                              ..cellStyle.bold = true
                              ..cellStyle.fontSize = 12
                              ..cellStyle.hAlign = xlsio.HAlignType.center;
    sheet.getRangeByName('D1:I1').merge();

    //volt data
    Map<String, String> voltageExcelMap = {
      "D2:D25" : "Volt1",
      "E2:E25" : "Volt2",
      "F2:F25" : "Volt3",
      "G2:G25" : "Volt4",
      "H2:H25" : "Volt5",
      "I2:I25" : "Volt6",
    };

    for (String range in voltageExcelMap.keys) {
      int i = 0;
      sheet.getRangeByName(range).cells.forEach((cell) {
        if(hvCellVoltages.containsKey(hvCellIDRemap[voltageExcelMap[range]]![i].toString())){
          cell.setNumber(hvCellVoltages[hvCellIDRemap[voltageExcelMap[range]]![i].toString()]!.toDouble());
        }
        else{
          cell.setNumber(filler);
        }
        i++;
      });
    }
    sheet.getRangeByName('D2:I25').cellStyle.hAlign = xlsio.HAlignType.right;

    // temp title
    sheet.getRangeByName('D27')..setText("Cell Temps")
                              ..cellStyle.bold = true
                              ..cellStyle.fontSize = 12
                              ..cellStyle.hAlign = xlsio.HAlignType.center;
    sheet.getRangeByName('D27:K27').merge();

    //temp data
    Map<String, String> tempExcelMap = {
      "D28:D51" : "Temp1",
      "E28:E51" : "Temp2",
      "F28:F51" : "Temp3",
      "G28:G51" : "Temp4",
      "H28:H51" : "Temp5",
      "I28:I51" : "Temp6",
      "J28:J51" : "Temp7",
      "K28:K51" : "Temp8",
    };

    for (String range in tempExcelMap.keys) {
      int i = 0;
      sheet.getRangeByName(range).cells.forEach((cell) {
        if(hvCellTemps.containsKey(hvCellIDRemap[tempExcelMap[range]]![i].toString())){
          cell.setNumber(hvCellTemps[hvCellIDRemap[tempExcelMap[range]]![i].toString()]!.toDouble());
        }
        else{
          cell.setNumber(filler);
        }
        i++;
      });
    }
    sheet.getRangeByName('D28:K51').cellStyle.hAlign = xlsio.HAlignType.right;

    // final
    sheet.getRangeByName('D2:K2').columnWidth = 10;
    // Compile excel
    bytes = excel.saveAsStream();
    excel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LayoutBuilder(
        builder: ((context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitleBar(parentContext: context),
              SizedBox(
                height: constraints.maxHeight - dialogTitleBarHeight,
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Center(child: Text("Itt majd lesz egy preview"),),
                    ),
                    SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () async {
                              String timeString = DateTime.now().toIso8601String();
                              fillExcel(timeString);
                              String? outputFile = await FilePicker.platform.saveFile(
                                dialogTitle: 'Please select a save location:',
                                fileName: 'accu_snapshot_${timeString.replaceAll(':', '-')}.xlsx',
                              );
                              if (outputFile != null) {
                                File(outputFile).writeAsBytes(bytes);
                              }
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            },
                            child: const Text("Save")
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
