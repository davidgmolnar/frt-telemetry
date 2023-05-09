import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/as_map.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout asmapBigLayout = TabLayout(
    layoutBreakpoints: [],
    shortcutLabels: [],
    minWidth: 1220,
    layout: [
      const Titlebar(title: "As Map"),
      TrackMap(subscribedSignals: const [], title: "Track Map") // mi a subscibed signal?
    ]);
