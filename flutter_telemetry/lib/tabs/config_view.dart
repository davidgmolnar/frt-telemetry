import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';
import 'package:flutter_telemetry/helpers/session.dart';

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
          Row(
            children: const [
              AlertContainer(),
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
              terminalQueue.add(TerminalElement("UDP socket close successful", 3));
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
