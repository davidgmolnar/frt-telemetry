import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';

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
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => updateLayout());
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
            ],
          ),
          ListTile(
            title: const Text("Connect", textAlign: TextAlign.center),
            onTap: () {
              startListener();
            },
          ),
        ],
      );
    }
    else{
      return ListView(
        children: const [
          SettingsContainer()
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
              decoration: InputDecoration(
                hintText: settings[widget.label][0].toString(),
              ),
              onChanged:(value) {
                input = value;
              },
            ),
          ),
          IconButton(
            splashRadius: 25,
            padding: const EdgeInsets.all(defaultPadding),
            icon: const Icon(Icons.check), 
            onPressed: () {
              if(settings[widget.label][1] <= num.parse(input) && num.parse(input) <= settings[widget.label][1]){
                settings[widget.label][0] = num.parse(input);
              }
              setState(() {
                
              });
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
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      constraints: const BoxConstraints(maxWidth: settingsWidth * 1.0),
      child: Column(
        children: [
          for(int i = 0; i < settings.keys.length; i++)
            SettingsElement(label: settings.keys.toList()[i])
        ]
      ),
    );
  }
}