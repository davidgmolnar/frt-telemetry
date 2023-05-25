import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

enum SortLogic{
  // ignore: constant_identifier_names
  STARTSWITH,
  // ignore: constant_identifier_names
  CONTAINS
}

class AlertAddDialog extends StatefulWidget {
  const AlertAddDialog({super.key});

  @override
  State<AlertAddDialog> createState() => AlertAddDialogState();
}

class AlertAddDialogState extends State<AlertAddDialog> {
  String signal = "";
  TextEditingController controller = TextEditingController();
  SortLogic logic = SortLogic.STARTSWITH;
  num min = -double.infinity;
  num max = double.infinity;
  bool inRange = true;

  @override
  Widget build(BuildContext context) {
    List<String> validSignalList;
    if(logic == SortLogic.STARTSWITH){
      validSignalList = signalValues.keys
        .toList().sorted((a, b) => a.compareTo(b))
        .where((key) => key.startsWith(signal)).toList();
    }
    else{
      validSignalList = signalValues.keys
        .toList().sorted((a, b) => a.compareTo(b))
        .where((key) => key.contains(signal)).toList();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  width: constraints.maxWidth - 2 * defaultPadding - 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      hintText: "Signal",
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    controller: controller,
                    onChanged:(value) {
                      signal = value;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: () {
                      if(logic == SortLogic.STARTSWITH){
                        logic = SortLogic.CONTAINS;
                      }
                      else{
                        logic = SortLogic.STARTSWITH;
                      }
                      setState(() {});
                    },
                    child: Text(logic == SortLogic.STARTSWITH ? "Starts with" : "Contains", style: const TextStyle(fontSize: numericFontSize + 1),),
                  )
                )
              ],
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.all(defaultPadding),
              width: constraints.maxWidth - 2 * defaultPadding,
              child: ListView.builder(
                itemCount: validSignalList.length,
                itemExtent: 30,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      signal = validSignalList[index];
                      controller.text = signal;
                    },
                    leading: Text(validSignalList[index]),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      hintText: "MIN",
                      hintStyle: const TextStyle(color: Colors.grey)
                    ),
                    onChanged:(value) {
                      try{
                        min = num.parse(value);
                      }
                      catch (_){}
                    },
                  ),
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      hintText: "MAX",
                      hintStyle: const TextStyle(color: Colors.grey)
                    ),
                    onChanged:(value) {
                      try{
                        max = num.parse(value);
                      }
                      catch (_){}
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    inRange = !inRange;
                    setState((){});
                  },
                  child: Text(inRange ? "In range" : "Out of range", style: TextStyle(color: primaryColor),),
                ),
                IconButton(
                  splashRadius: 20,
                  icon: Icon(Icons.check, color: primaryColor),
                  onPressed: () {
                    if(!signalValues.keys.contains(signal)){
                      showError(context, "Please select a signal");
                      return;
                    }
                    if(min > max){
                      showError(context, "Min > max ?");
                      return;
                    }
                    alerts.add(TelemetryAlert(signal, min, max, inRange));
                    showInfo(context, "Alert for $signal added");
                    setState((){});
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}