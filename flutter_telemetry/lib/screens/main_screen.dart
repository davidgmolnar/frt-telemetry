import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/tabs/config_view.dart';
import 'package:flutter_telemetry/components/dash_menu.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({
    Key? key,
  }) : super(key: key);

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
  void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context){
    return Scaffold( //TODO appbar a log letöltéshez meg az aksi snapshot dialoghoz
      body: SafeArea(
        child: Row(
          children: [
            DashMenu(onTabChange: changeTab,), //TODO becsukva csak ikonok legyenek
            const Expanded(
              child: ConfigView()
            ),
          ],
        ),
      ),
    );
  }
}