import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';


TabLayout configBigLayout = TabLayout(
  shortcutLabels: const [],
  layoutBreakpoints: const [],
  layout: [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: const [
            TerminalDisplay(),
            AlertContainer()
          ],
        ),
        Column(
          children: const [
            SettingsContainer(),
            ConnectionHandler(),
            NumericPanel(
              subscribedSignals: [
                "rssi",
              ], colsize: 1, title: "Telemetry Status"
            ),
            StringIndicator(subscribedSignal: "error", decoder: raspberryErrorDecoder)
          ],
        )
      ],
    ),
  ],
  minWidth: 1100
);

TabLayout configSmallLayout = TabLayout(
  shortcutLabels: const [],
  layoutBreakpoints: const [],
  layout: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: const [
            SettingsContainer(),
            ConnectionHandler(),
            NumericPanel(
              subscribedSignals: [
                "rssi",
              ], colsize: 1, title: "Telemetry Status"
            ),
            StringIndicator(subscribedSignal: "error", decoder: raspberryErrorDecoder)
          ],
        )
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        TerminalDisplay()
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        AlertContainer()
      ],
    )
  ],
  minWidth: 700
);

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
