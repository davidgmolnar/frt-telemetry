import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/components/dash_menu.dart';
import 'package:flutter_telemetry/helpers/session.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

Map<String, List<TabLayout>> layoutMap = {
  "CONFIG": [configBigLayout, configSmallLayout],
  "OVERVIEW": [overviewBigLayout, overviewSmallLayout],
  "TCU": [tcuBigLayout, tcuSmallLayout, tcuMobileLayout],
  "MCU": [mcuBigLayout, mcuSmallLayout, mcuMobileLayout],
  "SC": [scBigLayout, scSmallLayout],
  "BRIGHTLOOP": [brightloopBigLayout, brightloopSmallLayout, brightloopMobileLayout],
  "HV_ACCU": [hvAccuBigLayout, hvAccuSmallLayout],
  "DYNAMICS": [dynamicsBigLayout, dynamicsSmallLayout, dynamicsMobileLayout],
  "LV_SYSTEM": [lvSystemBigLayout, lvSystemSmallLayout, lvSystemMobileLayout],
  "ERRORS": [errorsBigLayout, errorsSmallLayout, errorsMobileLayout],
  "AS": [asBigLayout, asSmallLayout, asMobileLayout],
  "DATALOGGER": [dataloggerBigLayout, dataloggerSmallLayout, dataloggerMobileLayout],
  "LAP": [lapBigLayout, lapSmallLayout],
  "AS_MAP": [asmapBigLayout]
};

class MainScreen extends StatefulWidget{
  const MainScreen({
    Key? key,
    required this.toggleTheme,
  }) : super(key: key);

  final Function toggleTheme;

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  late Timer timer;

  void changeTab() {
    SchedulerBinding.instance.scheduleTask(() => saveSession(), Priority.animation);
    setState(() {});
  }

  void handleAlerts(){
    if (activeTab == "CONFIG"){
      // ilyenkor ott fut a kiértékelés
      return;
    }
    for (TelemetryAlert alert in alerts) {
      alert.risingEdge();
    }
  }

  @override
  void initState(){
    super.initState();
    timer = Timer.periodic(
        const Duration(milliseconds: 1000), (Timer t) => handleAlerts());
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            DashMenu(
              onTabChange: changeTab,
              onThemeChange: widget.toggleTheme,
            ),
            Expanded(
                child: layoutMap.containsKey(activeTab)
                    ? TabLayoutBuilder(layout: layoutMap[activeTab]!)
                    : Center(
                        child: Text("$activeTab Tab not found"),
                      )),
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
