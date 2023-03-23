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
                    return TabLayoutBuilder(
                      layout: [
                        configBigLayout,
                        configSmallLayout
                      ],
                    );
                  }
                  case "OVERVIEW": {
                    return TabLayoutBuilder(
                      layout: [
                        overviewBigLayout,
                        overviewSmallLayout
                      ],
                    );
                  }
                  case "TCU": {
                    return TabLayoutBuilder(
                      layout: [
                        tcuBigLayout,
                        tcuSmallLayout
                      ],
                    );
                  }
                  case "MCU": {
                    return TabLayoutBuilder(
                      layout: [
                        mcuBigLayout,
                        mcuSmallLayout
                      ],
                    );
                  }
                  case "SC": {
                    return TabLayoutBuilder(
                      layout: [
                        scBigLayout,
                        scSmallLayout
                      ],
                    );
                  }
                  case "BRIGHTLOOP": {
                    return TabLayoutBuilder(
                      layout: [
                        brightloopBigLayout,
                        brightloopSmallLayout
                      ],
                    );
                  }
                  case "HV_ACCU": {
                    return TabLayoutBuilder(
                      layout: [
                        hvAccuBigLayout,
                        hvAccuSmallLayout
                      ],
                    );
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