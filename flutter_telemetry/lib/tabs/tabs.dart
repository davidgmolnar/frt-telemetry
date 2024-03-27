import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
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
export 'asmap.dart';

class TabLayout {
  const TabLayout(
      {required this.shortcutLabels,
      required this.layoutBreakpoints,
      required this.layout,
      required this.minWidth});

  final List<String> shortcutLabels;
  final List<double> layoutBreakpoints;
  final List<Widget> layout;
  final int minWidth;
}

TabLayout getDefaultTab(BuildContext context) {
  return TabLayout(shortcutLabels: [], layoutBreakpoints: [], layout: [
    SizedBox(
      height: MediaQuery.of(context).size.height,
      child: const Center(
        child: Text(
          "No layout found for this screen size",
          style: TextStyle(fontSize: subTitleFontSize),
        ),
      ),
    )
  ], minWidth: 0);
}

class TabLayoutBuilder extends StatelessWidget {
  TabLayoutBuilder({super.key, required this.layout});

  final List<TabLayout> layout;

  final ScrollController _controller = ScrollController();
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    tabContext = context;
    return LayoutBuilder(
      builder: (context, constraints) {
        _focus.requestFocus();
        TabLayout activeLayout = layout.sorted(
          (a, b) {
            return a.minWidth.compareTo(b.minWidth);
          },
        ).lastWhere((element) => constraints.maxWidth > element.minWidth,
            orElse: () {
          return getDefaultTab(context);
        });
        return KeyboardListener(
          autofocus: true,
          focusNode: _focus,
          onKeyEvent: (event) {
            int? idx = int.tryParse(event.logicalKey.keyLabel);
            if (idx == null) {
              return;
            }
            if (idx < activeLayout.shortcutLabels.length) {
              _controller.animateTo(activeLayout.layoutBreakpoints[idx],
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            }
          },
          child: Scaffold(
              appBar: AppBar(
                  backgroundColor: secondaryColor,
                  toolbarHeight: 50,
                  elevation: 0,
                  actions: activeLayout.shortcutLabels
                      .map((label) => TextButton(
                          onPressed: () {
                            int idx =
                                activeLayout.shortcutLabels.indexOf(label);
                            _controller.animateTo(
                                activeLayout.layoutBreakpoints[idx],
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                          child: Text(label,
                              style: TextStyle(color: primaryColor))))
                      .toList()),
              body: ListView(
                key: UniqueKey(),
                controller: _controller,
                cacheExtent: settings["scrollCache"]!.value.toDouble(),
                children: activeLayout.layout,
              )),
        );
      },
    );
  }
}