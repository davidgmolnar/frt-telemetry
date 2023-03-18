import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/components/dash_menu.dart';
import 'package:flutter_telemetry/helpers/session.dart';
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
    SchedulerBinding.instance.scheduleTask(() => saveSession(), Priority.animation);
    setState(() {
      
    });
  }

  void handleAlerts(){
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
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            DashMenu(onTabChange: changeTab, onThemeChange: widget.toggleTheme,),
            Expanded(
              child: (() {
                switch(activeTab){
                  case "CONFIG": {
                    return TabContainer(
                      smallShortcutLabels: const [],
                      bigShortcutLabels: const [],
                      smallLayoutBreakpoints: const [],
                      bigLayoutBreakpoints: const [],
                      smallLayout: configSmall,
                      bigLayout: configBig,
                      widthThreshold: 1100);
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
                      smallShortcutLabels: const ["VDC Status", "Charts"],
                      bigShortcutLabels: const ["VDC Status", "Charts"],
                      smallLayoutBreakpoints: const [0, 900],
                      bigLayoutBreakpoints: const [0, 900],
                      smallLayout: tcuSmall,
                      bigLayout: tcuBig,
                      widthThreshold: 1200);
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
                      smallShortcutLabels: const ["HV Accu", "HV Status"],
                      bigShortcutLabels: const [],
                      smallLayoutBreakpoints: const [0, 770],
                      bigLayoutBreakpoints: const [],
                      smallLayout: hvAccuSmall,
                      bigLayout: hvAccuBig,
                      widthThreshold: 1300);
                  }
                  case "DYNAMICS": {
                    return TabLayoutBuilder(
                      layout: [
                        dynamicsBigLayout,
                        dynamicsSmallLayout
                      ],
                    );
                  }
                  case "LV_SYSTEM": {
                    return TabLayoutBuilder(
                      layout: [
                        lvSystemBigLayout,
                        lvSystemSmallLayout
                      ],
                    );
                  }
                  case "ERRORS": {
                    return TabLayoutBuilder(
                      layout: [
                        errorsBigLayout,
                        errorsSmallLayout
                      ]
                    );
                  }
                  case "AS": {
                    return TabLayoutBuilder(
                      layout: [
                        asBigLayout,
                        asSmallLayout
                      ]
                    );
                  }
                  case "DATALOGGER": {
                    return TabLayoutBuilder(
                      layout: [
                        dataloggerBigLayout,
                        dataloggerSmallLayout
                      ]
                    );
                  }
                  case "LAP": {
                    return TabLayoutBuilder(
                      layout: [
                        lapBigLayout,
                        lapSmallLayout
                      ]
                    );
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