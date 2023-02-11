import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/components/dash_menu.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({
    Key? key, required this.toggleTheme,
  }) : super(key: key);

  final Function toggleTheme;

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen>{
  late Timer timer;

  void changeTab(){
    setState(() {
      
    });
  }

  void handleAlerts(){ // TODO isolate
    if(activeTab == "CONFIG"){ // ilyenkor ott fut a kiértékelés TODO ez így elég bohóc
      return;
    }
    for (TelemetryAlert alert in alerts) {
      alert.risingEdge();
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000), (Timer t) => handleAlerts());
  }

  @override
  Widget build(BuildContext context){
    return Scaffold( //TODO appbar a log letöltéshez meg az aksi snapshot dialoghoz lehet össze lehet vonni a custom topbarral
      body: SafeArea(
        child: Row(
          children: [
            DashMenu(onTabChange: changeTab, onThemeChange: widget.toggleTheme,),
            Expanded(
              child: (() {
                switch(activeTab){
                  case "CONFIG": {
                    return const ConfigView();
                  }
                  case "OVERVIEW": {
                    return TabContainer(
                      smallShortcutLabels: const ["System and Sensor checks", "Dynamics and Control", "Power and MCUs", "Steering and Lap"],
                      bigShortcutLabels: const ["System and Sensor checks", "Dynamics and Control", "Power and MCUs", "Steering and Lap"],
                      smallLayoutBreakpoints: const [0, 750, 1550, 2470],
                      bigLayoutBreakpoints: const [0, 450, 1000, 1450],
                      smallLayout: overviewSmall,
                      bigLayout: overviewBig,
                      widthThreshold: 1220);
                  }
                  case "TCU": {
                    return TabContainer(
                      smallShortcutLabels: const [],
                      bigShortcutLabels: const [],
                      smallLayoutBreakpoints: const [],
                      bigLayoutBreakpoints: const [],
                      smallLayout: tcuSmall,
                      bigLayout: tcuBig,
                      widthThreshold: 1220);
                  }
                  case "MCU": {
                    return TabContainer(
                      smallShortcutLabels: const ["AMK Front Status", "AMK Rear Status", "RPM and Temp"],
                      bigShortcutLabels: const ["AMK Status", "RPM and Temp"],
                      smallLayoutBreakpoints: const [0, 780, 1560],
                      bigLayoutBreakpoints: const [0, 780],
                      smallLayout: mcuSmall,
                      bigLayout: mucBig,
                      widthThreshold: 1220);
                  }
                  case "SC": {
                    return TabContainer(
                      smallShortcutLabels: const [],
                      bigShortcutLabels: const [],
                      smallLayoutBreakpoints: const [],
                      bigLayoutBreakpoints: const [],
                      smallLayout: scSmall,
                      bigLayout: scBig,
                      widthThreshold: 1220);
                  }
                  case "BRIGHTLOOP": {
                    return TabContainer(
                      smallShortcutLabels: const ["Brightloop Charts", "Brightloop Status"],
                      bigShortcutLabels: const ["Brightloop Charts", "Brightloop Status"],
                      smallLayoutBreakpoints: const [0, 1050],
                      bigLayoutBreakpoints: const [0, 700],
                      smallLayout: brightloopSmall,
                      bigLayout: brightloopBig,
                      widthThreshold: 1220);
                  }
                  case "HV_ACCU": {
                    return TabContainer(
                      smallShortcutLabels: const [],
                      bigShortcutLabels: const [],
                      smallLayoutBreakpoints: const [],
                      bigLayoutBreakpoints: const [],
                      smallLayout: [],
                      bigLayout: [],
                      widthThreshold: 1220);
                  }
                  case "DYNAMICS": {
                    return TabContainer(
                      smallShortcutLabels: [],
                      bigShortcutLabels: [],
                      smallLayoutBreakpoints: [],
                      bigLayoutBreakpoints: [],
                      smallLayout: [],
                      bigLayout: [],
                      widthThreshold: 1220);
                  }
                  case "LV_SYSTEM": {
                    return TabContainer(
                      smallShortcutLabels: const [],
                      bigShortcutLabels: const [],
                      smallLayoutBreakpoints: const [],
                      bigLayoutBreakpoints: const [],
                      smallLayout: lvSystemSmall,
                      bigLayout: lvSystemBig,
                      widthThreshold: 1050);
                  }
                  case "ERRORS": {
                    return TabContainer(
                      smallShortcutLabels: const [],
                      bigShortcutLabels: const [],
                      smallLayoutBreakpoints: const [],
                      bigLayoutBreakpoints: const [],
                      smallLayout: errorsSmall,
                      bigLayout: errorsBig,
                      widthThreshold: 1220);
                  }
                  case "AS": {
                    return TabContainer(
                      smallShortcutLabels: [],
                      bigShortcutLabels: [],
                      smallLayoutBreakpoints: [],
                      bigLayoutBreakpoints: [],
                      smallLayout: [],
                      bigLayout: [],
                      widthThreshold: 1220);
                  }
                  case "DATALOGGER": {
                    return TabContainer(
                      smallShortcutLabels: [],
                      bigShortcutLabels: [],
                      smallLayoutBreakpoints: [],
                      bigLayoutBreakpoints: [],
                      smallLayout: [],
                      bigLayout: [],
                      widthThreshold: 1220);
                  }
                  case "LAP": {
                    return TabContainer(
                      smallShortcutLabels: [],
                      bigShortcutLabels: [],
                      smallLayoutBreakpoints: [],
                      bigLayoutBreakpoints: [],
                      smallLayout: [],
                      bigLayout: [],
                      widthThreshold: 1220);
                  }
                  default: {
                    return Center(child: Text("$activeTab Tab not found"),);
                  }
                }
              }())
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}