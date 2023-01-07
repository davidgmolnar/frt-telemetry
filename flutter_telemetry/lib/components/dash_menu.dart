import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

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
  bool isOpened = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isOpened ? 160 : 60,
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
            TabSelector(tab: "CONFIG", iconData: Icons.settings, title: "Config", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "OVERVIEW", iconData: Icons.center_focus_weak, title: "Overview", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "TCU", iconData: Icons.speed, title: "TCU", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "MCU", iconData: Icons.water_drop, title: "MCU", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "SC", iconData: FontAwesome5.power_off, title: "SC", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "BRIGHTLOOP", iconData: Icons.compare_arrows, title: "Brightloop", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "HV_ACCU", iconData: Icons.electric_bolt_outlined, title: "HV Accu", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "DYNAMICS", iconData: Icons.multiline_chart, title: "Dynamics", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "LV_SYSTEM", iconData: Icons.power, title: "LV System", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "ERRORS", iconData: Icons.error_outline, title: "Errors", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "AS", iconData: Icons.contactless_outlined, title: "AS", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "DATALOGGER", iconData: Icons.receipt_rounded, title: "Datalogger", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "LAP", iconData: Icons.circle_outlined, title: "Lap", tabChange: widget.onTabChange, isWide: isOpened,),

            IconButton(
              icon: isOpened ? const Icon(Icons.keyboard_arrow_left) : const Icon(Icons.keyboard_arrow_right),
              splashRadius: 20,
              onPressed: () {
                if(isOpened){
                  isOpened = false;
                }
                else{
                  isOpened = true;
                }
                setState(() {
                  
                });
              },

            )
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
    required this.isWide
  });

  final String tab;
  final IconData iconData;
  final String title;
  final Function tabChange;
  final bool isWide;

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
            if(isWide)
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
