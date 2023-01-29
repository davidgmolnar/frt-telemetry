import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class ConfigView extends StatefulWidget{
    const ConfigView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ConfigViewState();
  }
}

class ConfigViewState extends State<ConfigView>{
	late Timer timer;
  double threshold = 1220;
  bool isSmall = false;

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS'][0]), (Timer t) => updateLayout());
    }

  void updateLayout(){
    if(context.size!.width < threshold && !isSmall){
      setState(() {
        isSmall = true;
      });
    }
    else if(context.size!.width > threshold && isSmall){
      setState(() {
        isSmall = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!isSmall){
      return ListView(
        children: [
          Row(
            children: const [
              SettingsContainer(),
              ConnectionHandler(),
            ],
          ),
          Row(
            children: const [
              TerminalDisplay(),
            ],
          ),
          Row(
            children: const [
              AlertContainer()
            ],
          )
        ],
      );
    }
    else{
      return ListView(
        children: [
          Row(
            children: const [
              SettingsContainer(),
            ],
          ),
          Row(
            children: const [
              ConnectionHandler(),
            ],
          ),
          Row(
            children: const [
              TerminalDisplay(),
            ],
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

// Live settings
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
            child: Text(settingsToLabel[widget.label]!),
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

// Connection widget
class ConnectionHandler extends StatefulWidget{
  const ConnectionHandler({super.key});

  @override
  State<StatefulWidget> createState() {
    return ConnectionHandlerState();
  }
}

class ConnectionHandlerState extends State<ConnectionHandler>{
  late Timer timer;
  bool connected = false;

  @override
  void initState() {
    connected = isconnected;
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => update());
  }

  void update(){
    if(isconnected != connected){
      setState(() {
        connected = isconnected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(2 * defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              connected ? "Connected" : "Disconnected",
              style: TextStyle(color: connected ? Colors.green : Colors.red),
            ),
          ),
          TextButton(
            child: const Text("Connect", textAlign: TextAlign.center),
            onPressed: () async {
              await startListener();
            },
          ),
          TextButton(
            child: const Text("Disconnect", textAlign: TextAlign.center),
            onPressed: () async {
              sock.close();
              isconnected = false;
              connected = false;
              setState(() {
                
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
