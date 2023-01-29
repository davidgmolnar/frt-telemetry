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
                    return const OverviewTab();
                  }
                  case "TCU": {
                    return const TCUTab();
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