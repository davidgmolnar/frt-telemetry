import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

class TCUTab extends StatefulWidget{
  const TCUTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return TCUTabState();
  }
}

class TCUTabState extends State<TCUTab>{
	late Timer timer;
  double threshold = 1220;
  bool isSmall = false;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS'][0]), (Timer t) => updateLayout());
    }

  void updateLayout(){
    if(context.size!.width < threshold && !isSmall){
      setState(() {
        isSmall = true;
      });
    }
    else if(context.size!.width > threshold && isSmall){
      setState(() {
        isSmall = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor,
            toolbarHeight: 50,
            elevation: 0,
            actions: [],
          ),
          body: isSmall ?
            // Small layout
            Container(color: Colors.red,)
            : // Big layout
            ListView(
              controller: _controller,
              children: const [
                WaveformChart(subscribedSignals: ["STA1_position", "v_x", "PPS1"], title: "Title"),
                WaveformChart(subscribedSignals: ["STA1_position", "PPS1", "v_x"], title: "Title"),
                WaveformChart(subscribedSignals: ["v_x", "STA1_position", "PPS1"], title: "Title")
              ],
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