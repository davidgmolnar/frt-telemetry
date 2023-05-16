import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';
import 'package:flutter_telemetry/helpers/session.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

Map<String, String> settingsToLabel = {
  "refreshTimeMS" : "Refresh time in ms",
  "chartrefreshTimeMS": "Chart refresh time in ms",
  "signalValuesToKeep": "Internal buffer",
  "listenPort": "Port to listen",
  "chartShowSeconds": "Chart timespan in sec",
  "scrollCache": "Scrolling cache"
};

Map<String, String> settingsTooltip = {
  "refreshTimeMS" : "Each indicator will periodically attempt to refresh its value with the most recent value possible",
  "chartrefreshTimeMS": "Same as ^^ but for charts",
  "signalValuesToKeep": "The last x values are going to be stored in memory, to be used by charts or time averaged signals",
  "listenPort": "This port will be used to receive UDP data to be displayed",
  "chartShowSeconds": "The charts will show data received in the last x seconds",
  "scrollCache": "Widgets are loaded out of sight within this vertical distance"
};

class SettingsElement extends StatefulWidget{
  const SettingsElement({
    super.key,
    required this.label, required this.updater,
  });

  final String label;
  final Function updater;

  @override
  State<SettingsElement> createState() => SettingsElementState();
}

class SettingsElementState extends State<SettingsElement> {
  String input = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: settingsWidth * 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: AdvancedTooltip(
              tooltipText: settingsTooltip[widget.label]!,
              child: Text(settingsToLabel[widget.label]!)
            )
          ),
          const Spacer(),
          Container(
            width: 100,
            padding: const EdgeInsets.all(defaultPadding),
            child: TextFormField(
              initialValue: "",
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                hintText: settings[widget.label]![0].toString(),
                hintStyle: const TextStyle(color: Colors.grey)
              ),
              onChanged:(value) {
                input = value;
              },
            ),
          ),
          IconButton(
            splashRadius: 25,
            padding: const EdgeInsets.all(defaultPadding),
            icon: Icon(Icons.check, color: primaryColor,), 
            onPressed: () {
              if(settings[widget.label]![1] <= int.parse(input) && int.parse(input) <= settings[widget.label]![2]){
                if(widget.label == "signalValuesToKeep" && int.parse(input) < settings["signalValuesToKeep"]![0]){
                  needsTruncate = true;
                  turncateTo = int.parse(input);
                  settings["signalValuesToKeep"]![0] = int.parse(input);
                }
                else{
                  settings[widget.label]![0] = int.parse(input);
                }
              }
              else{
                showError(context, "Setting must be in range ${settings[widget.label]![1]}:${settings[widget.label]![2]}");
              }
              SchedulerBinding.instance.scheduleTask(() => saveSession(), Priority.animation);
              widget.updater();
            },
          )
        ],
      ),
    );
  }
}

class SettingsContainer extends StatefulWidget{
  const SettingsContainer({super.key});

  @override
  State<SettingsContainer> createState() => SettingsContainerState();
}

class SettingsContainerState extends State<SettingsContainer> {
  void update(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Text("Settings",
          style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          constraints: const BoxConstraints(maxWidth: settingsWidth * 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for(int i = 0; i < settings.keys.length; i++)
                SettingsElement(label: settings.keys.toList()[i], updater: update)
            ]
          ),
        ),
      ],
    );
  }
}
