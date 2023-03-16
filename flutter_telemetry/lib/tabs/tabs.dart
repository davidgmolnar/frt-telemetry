import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';

export 'config_view.dart';
export 'overview.dart';
export 'tcu.dart';
export 'mcu.dart';
export 'sc.dart';
export 'brightloop.dart';
export 'lvsystem.dart';
export 'errors.dart';
export 'hvaccu.dart';
export 'as.dart';
export 'dynamics.dart';
export 'lap.dart';
export 'datalogger.dart';

class TabLayout{ // TODO ebből épüljön fel a tab
  const TabLayout(this.shortcutLabels, this.layoutBreakpoints, this.layout, this.minWidth);

  final String shortcutLabels;
  final List<double> layoutBreakpoints;
  final List<Widget> layout;
  final int minWidth;
}

class TabLayoutBuilder extends StatelessWidget{
  TabLayoutBuilder({super.key, required this.layout});

  final List<TabLayout> layout;

  final ScrollController _controller = ScrollController();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        _focus.requestFocus();
        TabLayout activeLayout = layout.sorted((a, b) {return a.minWidth.compareTo(b.minWidth);},).firstWhere((element) => constraints.maxWidth > element.minWidth);  // vagy < xd
        return RawKeyboardListener(
          autofocus: true,
          focusNode: _focus,
          child: Container(),
        );
      },
    );
  }
  
}

class TabContainer extends StatelessWidget{
  TabContainer({
    super.key,
    required this.smallShortcutLabels,
    required this.bigShortcutLabels,
    required this.smallLayoutBreakpoints,
    required this.bigLayoutBreakpoints,
    required this.smallLayout,
    required this.bigLayout,
    required this.widthThreshold
  });

  final List<String> smallShortcutLabels;
  final List<String> bigShortcutLabels;
  final List<double> smallLayoutBreakpoints;
  final List<double> bigLayoutBreakpoints;
  final List<Widget> smallLayout;
  final List<Widget> bigLayout;
  final int widthThreshold;

  final ScrollController _controller = ScrollController();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _focus.requestFocus();
        return RawKeyboardListener(
          autofocus: true,
          focusNode: _focus,
          onKey: (event) {
            if (event is RawKeyDownEvent){
              int? idx = int.tryParse(event.logicalKey.keyLabel);
              if(idx == null){
                return;
              }
              if(constraints.maxWidth < widthThreshold){
                if(idx < smallShortcutLabels.length){
                  _controller.animateTo(smallLayoutBreakpoints[idx],
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut
                  );
                }
              }
              else{
                if(idx < bigShortcutLabels.length){
                  _controller.animateTo(bigLayoutBreakpoints[idx],
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut
                  );
                }
              }
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: secondaryColor,
              toolbarHeight: 50,
              elevation: 0,
              actions: constraints.maxWidth < widthThreshold ? 
                smallShortcutLabels.map((label) => 
                  TextButton(
                    onPressed: () {
                      int idx = smallShortcutLabels.indexOf(label);
                      _controller.animateTo(smallLayoutBreakpoints[idx],
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut
                      );
                    },
                    child: Text(label, style: TextStyle(color: primaryColor)))
                ).toList()
                :
                bigShortcutLabels.map((label) => 
                  TextButton(
                    onPressed: () {
                      int idx = bigShortcutLabels.indexOf(label);
                      _controller.animateTo(bigLayoutBreakpoints[idx],
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut
                      );
                    },
                    child: Text(label, style: TextStyle(color: primaryColor)))
                ).toList()
            ),
            body: 
              ListView(
                controller: _controller,
                children: constraints.maxWidth < widthThreshold ? smallLayout : bigLayout,
              )
          )
        );
      }
    );
  }
}