import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

Map<String, String> settingsToLabel = {
  "refreshTimeMS" : "Refresh time in ms",
  "chartrefreshTimeMS": "Chart refresh time in ms",
  "signalValuesToKeep": "Internal buffer",
  "chartSignalValuesToKeep": "Data points on chart",
  "chartLoadMode": "Chart loading mode",
};

Map<String, String> settingsTooltip = {
  "refreshTimeMS" : "Each indicator will periodically attempt to refresh its value with the most recent value possible",
  "chartrefreshTimeMS": "Same as ^^ but for charts",
  "signalValuesToKeep": "The last x values are going to be stored in memory, to be used by charts or time averaged signals",
  "chartSignalValuesToKeep": "Data points on charts",
  "chartLoadMode": "0 - Use the single most recent value each time the chart attempts to refresh (Power saver with potential data loss) \n1 - Update the charts with all the new values since it was last refreshed (More performance intensive, data loss only if more data arrived than would fill a chart)",
};

class SettingsElement extends StatefulWidget{
  const SettingsElement({
    super.key,
    required this.label,
  });

  final String label;

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
            child: Tooltip(
              message: settingsTooltip[widget.label]!,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(5.0)
              ),
              textStyle: TextStyle(color: textColor),
              showDuration: const Duration(milliseconds: 200),
              waitDuration: const Duration(milliseconds: 200),
              verticalOffset: 10,
              child: Text(settingsToLabel[widget.label]!),
            ),
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
                hintText: settings[widget.label][0].toString(),
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
              if(settings[widget.label][1] <= num.parse(input) && num.parse(input) <= settings[widget.label][2]){
                if(widget.label == "chartSignalValuesToKeep" && num.parse(input) > settings["signalValuesToKeep"][0]){
                  showError(context, "Charts cant have more data than the internal buffer");
                }
                else{
                  settings[widget.label][0] = num.parse(input);
                }
              }
              else{
                showError(context, "Setting must be in range ${settings[widget.label][1]}:${settings[widget.label][2]}");
              }
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}

class SettingsContainer extends StatelessWidget{
  const SettingsContainer({super.key});
  
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
                SettingsElement(label: settings.keys.toList()[i])
            ]
          ),
        ),
      ],
    );
  }
}
