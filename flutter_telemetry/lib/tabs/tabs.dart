import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_telemetry/globals.dart';

export 'config_view.dart';
export 'overview.dart';
export 'tcu.dart';
export 'mcu.dart';
export 'sc.dart';

class TabContainer extends StatefulWidget{
  const TabContainer({
    super.key,
    required this.shortcutLabels,
    required this.smallLayoutBreakpoints,
    required this.bigLayoutBreakpoints,
    required this.smallLayout,
    required this.bigLayout,
    required this.widthThreshold
  });

  final List<String> shortcutLabels;
  final List<double> smallLayoutBreakpoints;
  final List<double> bigLayoutBreakpoints;
  final List<Widget> smallLayout;
  final List<Widget> bigLayout;
  final int widthThreshold;

  @override
  State<StatefulWidget> createState() {
    return TabContainerState();
  }
}

class TabContainerState extends State<TabContainer>{
  bool isSmallScreen = false;
  late Timer timer;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS'][0]), (Timer t) => updateLayout());
  }

  void updateLayout(){
    if(context.size!.width < widget.widthThreshold && !isSmallScreen){
      setState(() {
        isSmallScreen = true;
      });
    }
    else if(context.size!.width > widget.widthThreshold && isSmallScreen){
      setState(() {
        isSmallScreen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event) {
        if (event is RawKeyDownEvent){
          int idx = int.parse(event.logicalKey.keyLabel);
          if(idx < widget.shortcutLabels.length){
            _controller.animateTo(isSmallScreen ? widget.smallLayoutBreakpoints[idx] : widget.bigLayoutBreakpoints[idx],
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          toolbarHeight: 50,
          elevation: 0,
          actions: widget.shortcutLabels.map((label) => 
            TextButton(
              onPressed: () {
                int idx = widget.shortcutLabels.indexOf(label);
                _controller.animateTo(isSmallScreen ? widget.smallLayoutBreakpoints[idx] : widget.bigLayoutBreakpoints[idx],
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut
                );
              },
              child: Text(label, style: TextStyle(color: primaryColor)))
          ).toList(),
        ),
        body: ListView(  // TODO ListView.builder
          controller: _controller,
          children: isSmallScreen ? widget.smallLayout : widget.bigLayout,
        )
      )
    );
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}