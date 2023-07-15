import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout lapBigLayout = const TabLayout(shortcutLabels: [], layoutBreakpoints: [], layout: [LapDisplay(isSmallScreen: false)], minWidth: 1220);
TabLayout lapSmallLayout = const TabLayout(shortcutLabels: [], layoutBreakpoints: [], layout: [LapDisplay(isSmallScreen: true)], minWidth: 700);