import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class LapDataSaveDialog extends StatelessWidget{
  const LapDataSaveDialog({super.key, required this.updater});

  final Function updater;

  static List<int> _compileExcel(String timeString){
    List<int> bytes = [];
    final xlsio.Workbook excel = xlsio.Workbook();
    final xlsio.Worksheet sheet = excel.worksheets[0];
    sheet.name = "Cell Status";
    sheet.showGridlines = true;

    sheet.getRangeByIndex(1, 1).setText('Time');
    sheet.getRangeByIndex(1, 2).setText(timeString);

    sheet.getRangeByIndex(2, 1).setText('Number of laps');
    sheet.getRangeByIndex(2, 2).setNumber(lapData.length.toDouble());

    sheet.getRangeByIndex(3, 1).setText('Best lap');
    sheet.getRangeByIndex(3, 2).setText(representMS(lapData.sorted(((a, b) => a.lapTimeMS.compareTo(b.lapTimeMS))).first.lapTimeMS));

    int i = 0;
    List<String> header = ["Lap", "Laptime", "SoC", "Current avg", "FL Motor T", "FR Motor T", "RL Motor T", "RR Motor T", "FL Inv T", "FR Inv T", "RL Inv T", "RR Inv T"];
    sheet.getRangeByIndex(1, 4, 1, 16).cells.forEach((cell) {
      cell.setText(header[i]);
      i++;
    });

    i = 2;
    for(LapData lap in lapData){
      sheet.getRangeByIndex(i, 4).setNumber(lap.lapNum.toDouble());
      sheet.getRangeByIndex(i, 5).setText(representMS(lap.lapTimeMS));
      sheet.getRangeByIndex(i, 6).setNumber(lap.soc);
      sheet.getRangeByIndex(i, 7).setNumber(lap.deltasoc);
      sheet.getRangeByIndex(i, 8).setNumber(lap.mivCellVolt);
      sheet.getRangeByIndex(i, 9).setNumber(lap.motorTemps[0]);
      sheet.getRangeByIndex(i, 10).setNumber(lap.motorTemps[1]);
      sheet.getRangeByIndex(i, 11).setNumber(lap.motorTemps[2]);
      sheet.getRangeByIndex(i, 12).setNumber(lap.motorTemps[3]);
      sheet.getRangeByIndex(i, 13).setNumber(lap.invTemps[0]);
      sheet.getRangeByIndex(i, 14).setNumber(lap.invTemps[1]);
      sheet.getRangeByIndex(i, 15).setNumber(lap.invTemps[2]);
      sheet.getRangeByIndex(i, 16).setNumber(lap.invTemps[3]);
      i++;
    }

    sheet.getRangeByIndex(1, 1, 3, 2).autoFitColumns();
    sheet.getRangeByIndex(1, 4, 1, 16).columnWidth = 10;

    bytes = excel.saveAsStream();
    excel.dispose();
    return bytes;
  }

  static Future<void> _handleSave() async {
    if(lapData.isEmpty){
      showError(tabContext, "No data to save");
      return;
    }
    String timeString = DateTime.now().toIso8601String();
    List<int> bytes = _compileExcel(timeString);
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select a save location:',
      fileName: 'lap_${timeString.replaceAll(':', '-')}.xlsx',
    );
    if (outputFile != null) {
      await File(outputFile).writeAsBytes(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            lapTimerStarted = !lapTimerStarted;
            if(lapTimerStarted){
              lapData.clear();
              lapStart = DateTime.now();
            }
            updater();
            Navigator.of(context).pop();
          },
          child: const Text("Confirm")
        ),
        if(!lapTimerStarted && lapData.isNotEmpty)
          TextButton(
            onPressed: () async {
              await _handleSave();
              lapData.clear();
              lapStart = DateTime.now();
              lapTimerStarted = true;
              updater();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: const Text("Export and Confirm")
          ),
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text("Cancel")
        )
      ],
    );
  }

}