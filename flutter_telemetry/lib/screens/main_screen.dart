import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/components/dash_menu.dart';
import 'package:flutter_telemetry/helpers/session.dart';
import 'package:flutter_telemetry/tabs/tablayout_parser.dart';
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
  "AS_MAP": [asmapBigLayout],
  "CUSTOM": [TabLayoutParser.failedToParseTab]
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

  void changeTab() async {
    SchedulerBinding.instance.scheduleTask(() => saveSession(), Priority.animation);
    if(activeTab == 'CUSTOM'){
      layoutMap['CUSTOM'] = [await TabLayoutParser.load('custom.json')];
    }
    setState(() {});
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
    super.dispose();
  }
}
