import 'package:flutter_telemetry/indicators/as_map.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout asmapBigLayout = const TabLayout(
    layoutBreakpoints: [],
    shortcutLabels: [],
    minWidth: 1220,
    layout: [
      Titlebar(title: "As Map"),
      TrackMap(
          subscribedSignals: [], title: "Track Map") // mi a subscibed signal?
    ]);
