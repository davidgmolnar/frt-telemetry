import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';

class DashMenu extends StatefulWidget{
  const DashMenu({
    super.key,
    required this.onTabChange,
  });
  
  final Function onTabChange;

  @override
  State<StatefulWidget> createState() {
    return DashMenuState();
  }
}

class DashMenuState extends State<DashMenu>{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Drawer(
        backgroundColor: secondaryColor,
        child: ListView(
          children: [
            DrawerHeader(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              child: Image.asset("assets/images/frt_logo_small.jpg",
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              title: const Text("Connect", textAlign: TextAlign.center,),
              onTap: () {
                startListener();
              },
            ),
            TabSelector(tab: "CONFIG", iconData: Icons.settings, title: "Config", tabChange: widget.onTabChange),
            TabSelector(tab: "OVERVIEW", iconData: Icons.center_focus_weak, title: "Overview", tabChange: widget.onTabChange),
            TabSelector(tab: "ACCU", iconData: Icons.power, title: "Accu", tabChange: widget.onTabChange),
            TabSelector(tab: "CONFIG", iconData: Icons.settings, title: "Config", tabChange: widget.onTabChange),
            TabSelector(tab: "CONFIG", iconData: Icons.settings, title: "Config", tabChange: widget.onTabChange),
            TabSelector(tab: "CONFIG", iconData: Icons.settings, title: "Config", tabChange: widget.onTabChange),
            TabSelector(tab: "CONFIG", iconData: Icons.settings, title: "Config", tabChange: widget.onTabChange),
            TabSelector(tab: "CONFIG", iconData: Icons.settings, title: "Config", tabChange: widget.onTabChange),
          ],
        )
      ),
    );
    
  }
}

class TabSelector extends StatelessWidget {
  const TabSelector({
    super.key,
    required this.tab,
    required this.iconData,
    required this.title,
    required this.tabChange,
    //required this.isWide
  });

  final String tab;
  final IconData iconData;
  final String title;
  final Function tabChange;
  //final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tab == activeTab ? bgColor : secondaryColor,
      child: TextButton(
        onPressed: () {
          activeTab = tab;
          tabChange();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Icon(iconData),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(title, style: const TextStyle(fontSize: 15),),
            ),
          ]
        ),
      ),
    );
  }
}
