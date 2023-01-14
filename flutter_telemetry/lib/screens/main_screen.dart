import 'package:flutter/material.dart';
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

  void changeTab(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold( //TODO appbar a log letöltéshez meg az aksi snapshot dialoghoz
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
                  default: {
                    return const Center(child: Text("Tab not found"),);
                  }
                }
              }())
            )
          ],
        ),
      ),
    );
  }
}