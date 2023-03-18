import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_telemetry/components/dash_bottom_nav.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/session.dart';
import 'package:window_manager/window_manager.dart';

class DashMenu extends StatefulWidget{
  const DashMenu({
    super.key,
    required this.onTabChange,
    required this.onThemeChange,
  });
  
  final Function onTabChange;
  final Function onThemeChange;

  @override
  State<StatefulWidget> createState() {
    return DashMenuState();
  }
}

class DashMenuState extends State<DashMenu>{
  bool isOpened = true;
  bool goingToOpen = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: goingToOpen ? 160 : 60,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linearToEaseOut,
      onEnd: () {
        isOpened = goingToOpen;
        setState(() {
          
        });
      },
      child: Drawer(
        backgroundColor: secondaryColor,
        child: ListView(
          children: [
            AnimatedContainer(
              height: goingToOpen ? 0 : 30,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linearToEaseOut,
            ),
            Container(
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
            TabSelector(tab: "SC", iconData: Icons.power_settings_new, title: "SC", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "BRIGHTLOOP", iconData: Icons.compare_arrows, title: "Brightloop", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "HV_ACCU", iconData: Icons.electric_bolt_outlined, title: "HV Accu", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "DYNAMICS", iconData: Icons.multiline_chart, title: "Dynamics", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "LV_SYSTEM", iconData: Icons.power, title: "LV System", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "ERRORS", iconData: Icons.error_outline, title: "Errors", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "AS", iconData: Icons.contactless_outlined, title: "AS", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "DATALOGGER", iconData: Icons.receipt_rounded, title: "Datalogger", tabChange: widget.onTabChange, isWide: isOpened,),
            TabSelector(tab: "LAP", iconData: Icons.circle_outlined, title: "Lap", tabChange: widget.onTabChange, isWide: isOpened,),

            !isOpened ? SizedBox(
              height: 4 * (iconSplashRadius + 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashBottomNavButton(
                    iconData: Icons.close,
                    onPressed: () async {
                      // TODO dialog
                      SchedulerBinding.instance.scheduleTask(() => saveSession(), Priority.animation).then((_) => exit(0));
                    }
                  ),
                  DashBottomNavButton(
                    iconData: textColor == textColorBright ? Icons.sunny : Icons.dark_mode,
                    onPressed: () {widget.onThemeChange();}
                  ),
                  DashBottomNavButton(
                    iconData: !isFullScreen ? Icons.fullscreen_rounded : Icons.fullscreen_exit_outlined,
                    onPressed: () {
                      isFullScreen = !isFullScreen; windowManager.setFullScreen(isFullScreen);
                      setState(() {});
                    }
                  ),
                  DashBottomNavButton(
                    iconData: isOpened ? Icons.keyboard_arrow_left_rounded : Icons.keyboard_arrow_right_rounded,
                    onPressed: () {
                      goingToOpen ? {goingToOpen = false, isOpened = false} : goingToOpen = true;
                      setState(() {});
                    },
                  ),
                ],
              ),
            )
            :
            SizedBox(
              height: iconSplashRadius + 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashBottomNavButton(
                    iconData: Icons.close,
                    onPressed: () async {
                      // TODO dialog
                      SchedulerBinding.instance.scheduleTask(() => saveSession(), Priority.animation).then((_) => exit(0));
                    }
                  ),
                  DashBottomNavButton(
                    iconData: textColor == textColorBright ? Icons.sunny : Icons.dark_mode,
                    onPressed: () {widget.onThemeChange();}
                  ),
                  DashBottomNavButton(
                    iconData: !isFullScreen ? Icons.fullscreen_rounded : Icons.fullscreen_exit_outlined,
                    onPressed: () {
                      isFullScreen = !isFullScreen; windowManager.setFullScreen(isFullScreen);
                      setState(() {});
                    }
                  ),
                  DashBottomNavButton(
                    iconData: isOpened ? Icons.keyboard_arrow_left_rounded : Icons.keyboard_arrow_right_rounded,
                    onPressed: () {
                      goingToOpen ? {goingToOpen = false, isOpened = false} : goingToOpen = true;
                      setState(() {});
                    },
                  ),
                ],
              ),
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
              child: Icon(iconData, color: primaryColor),
            ),
            if(isWide)
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Text(title, style: TextStyle(fontSize: 15, color: primaryColor),),
              ),
          ]
        ),
      ),
    );
  }
}
