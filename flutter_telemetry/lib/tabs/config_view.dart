import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/dialogs/dbc_selector_dialog.dart';
import 'package:flutter_telemetry/dialogs/dialog.dart';
import 'package:flutter_telemetry/dialogs/serial_selector.dart';
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
          children: [
            const SettingsContainer(),
            const ConnectionHandler(),
            const NumericPanel(
              subscribedSignals: [
                "rssi",
                "last_singal_update_cnt"
              ], colsize: 2, title: "Telemetry Status"
            ),
            const StringIndicator(subscribedSignal: "error", decoder: raspberryErrorDecoder),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextButton(
                onPressed: () async {
                  showDialog<Widget>(
                    barrierDismissible: false,
                    context: tabContext,
                    builder: (BuildContext context) => const DialogBase(title: "DBC Menu", dialog: DBCSelectorDialog(), minWidth: 700)
                  );
                },
                child: Text("DBC Menu", style: TextStyle(fontSize: subTitleFontSize, color: primaryColor),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextButton(
                onPressed: () async {
                  showDialog<Widget>(
                    barrierDismissible: false,
                    context: tabContext,
                    builder: (BuildContext context) => const DialogBase(title: "Serial Menu", dialog: SerialPortSelectorDialog(), minWidth: 600)
                  );
                },
                child: Text("Serial Menu", style: TextStyle(fontSize: subTitleFontSize, color: primaryColor),),
              ),
            ),
            const LogStartStopButton()
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
          children: [
            const SettingsContainer(),
            const ConnectionHandler(),
            const NumericPanel(
              subscribedSignals: [
                "rssi",
                "last_singal_update_cnt"
              ], colsize: 2, title: "Telemetry Status"
            ),
            const StringIndicator(subscribedSignal: "error", decoder: raspberryErrorDecoder),
            Padding(
              padding: const EdgeInsets.all(defaultPadding * 2),
              child: TextButton(
                onPressed: () async {
                  showDialog<Widget>(
                    barrierDismissible: false,
                    context: tabContext,
                    builder: (BuildContext context) => const DialogBase(title: "DBC Menu", dialog: DBCSelectorDialog(), minWidth: 700)
                  );
                },
                child: Text("DBC Menu", style: TextStyle(fontSize: subTitleFontSize, color: primaryColor),),
              ),
            ),
            const LogStartStopButton()
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
              if(!isconnected){
                await startListener();
              }
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

class LogStartStopButton extends StatefulWidget {
  const LogStartStopButton({super.key});

  @override
  State<LogStartStopButton> createState() => _LogStartStopButtonState();
}

class _LogStartStopButtonState extends State<LogStartStopButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: TextButton(
        onPressed: (() async {
          doLog = !doLog;
          if(!doLog){
            await logBufferFlushAsync();
          }
          setState(() {});
        }),
        child: Text(doLog? "Stop log" : "Start log", style: TextStyle(color: primaryColor, fontSize: subTitleFontSize),),
      ),
    );
  }
}