import 'package:flutter/material.dart';
import "package:flutter_telemetry/indicators/indicators.dart";
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout mcuBigLayout = TabLayout(shortcutLabels: const [
  "AMK Status",
  "RPM and Temp"
], layoutBreakpoints: const [
  0,
  780
], layout: [
  const Titlebar(title: "AMK Status"),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: const [
          NumericPanel(
            colsize: 6,
            title: "FL Status",
            subscribedSignals: [
              "AMK1_torque_current",
              "AMK1_magnetizing_current",
              "AMK1_error_info",
              "AMK1_temp_IGBT",
              "AMK1_temp_inverter",
              "AMK1_temp_motor",
            ],
          ),
          BooleanIndicator(subscribedSignal: "AMK1_DC_On"),
          BooleanIndicator(subscribedSignal: "AMK1_Enable"),
          BooleanIndicator(subscribedSignal: "AMK1_Error_Reset"),
          BooleanIndicator(subscribedSignal: "AMK1_Inverter_On"),
          AMKStatusIndicator(subscribedSignal: "AMK1_Status")
        ],
      ),
      Column(
        children: const [
          NumericPanel(
            colsize: 6,
            title: "FR Status",
            subscribedSignals: [
              "AMK2_torque_current",
              "AMK2_magnetizing_current",
              "AMK2_error_info",
              "AMK2_temp_IGBT",
              "AMK2_temp_inverter",
              "AMK2_temp_motor",
            ],
          ),
          BooleanIndicator(subscribedSignal: "AMK2_DC_On"),
          BooleanIndicator(subscribedSignal: "AMK2_Enable"),
          BooleanIndicator(subscribedSignal: "AMK2_Error_Reset"),
          BooleanIndicator(subscribedSignal: "AMK2_Inverter_On"),
          AMKStatusIndicator(subscribedSignal: "AMK2_Status")
        ],
      ),
      Column(
        children: const [
          NumericPanel(
            colsize: 6,
            title: "RL Status",
            subscribedSignals: [
              "AMK3_torque_current",
              "AMK3_magnetizing_current",
              "AMK3_error_info",
              "AMK3_temp_IGBT",
              "AMK3_temp_inverter",
              "AMK3_temp_motor",
            ],
          ),
          BooleanIndicator(subscribedSignal: "AMK3_DC_On"),
          BooleanIndicator(subscribedSignal: "AMK3_Enable"),
          BooleanIndicator(subscribedSignal: "AMK3_Error_Reset"),
          BooleanIndicator(subscribedSignal: "AMK3_Inverter_On"),
          AMKStatusIndicator(subscribedSignal: "AMK3_Status")
        ],
      ),
      Column(
        children: const [
          NumericPanel(
            colsize: 6,
            title: "RR Status",
            subscribedSignals: [
              "AMK4_torque_current",
              "AMK4_magnetizing_current",
              "AMK4_error_info",
              "AMK4_temp_IGBT",
              "AMK4_temp_inverter",
              "AMK4_temp_motor",
            ],
          ),
          BooleanIndicator(subscribedSignal: "AMK4_DC_On"),
          BooleanIndicator(subscribedSignal: "AMK4_Enable"),
          BooleanIndicator(subscribedSignal: "AMK4_Error_Reset"),
          BooleanIndicator(subscribedSignal: "AMK4_Inverter_On"),
          AMKStatusIndicator(subscribedSignal: "AMK4_Status")
        ],
      ),
    ],
  ),
  const Titlebar(title: "RPM and Temp"),
  const TimeSeriesChart(
    subscribedSignals: [
      "AMK1_actual_velocity",
      "AMK2_actual_velocity",
      "AMK3_actual_velocity",
      "AMK4_actual_velocity",
    ],
    title: "AMK RPM",
    min: 0,
    max: 25000,
    //multiplier: [1,1,1,1]
  ),
  const TimeSeriesChart(
    subscribedSignals: [
      "AMK1_temp_inverter",
      "AMK2_temp_inverter",
      "AMK3_temp_inverter",
      "AMK4_temp_inverter",
    ],
    title: "AMK Inverter temp",
    min: 0,
    max: 80,
    //multiplier: [1,1,1,1]
  ),
], minWidth: 1220);

TabLayout mcuSmallLayout = TabLayout(shortcutLabels: const [
  "AMK Front Status",
  "AMK Rear Status",
  "RPM and Temp"
], layoutBreakpoints: const [
  0,
  780,
  1560
], layout: [
  const Titlebar(title: "AMK Front Status"),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: const [
          NumericPanel(
            colsize: 6,
            title: "FL Status",
            subscribedSignals: [
              "AMK1_torque_current",
              "AMK1_magnetizing_current",
              "AMK1_error_info",
              "AMK1_temp_IGBT",
              "AMK1_temp_inverter",
              "AMK1_temp_motor",
            ],
          ),
          BooleanIndicator(subscribedSignal: "AMK1_DC_On"),
          BooleanIndicator(subscribedSignal: "AMK1_Enable"),
          BooleanIndicator(subscribedSignal: "AMK1_Error_Reset"),
          BooleanIndicator(subscribedSignal: "AMK1_Inverter_On"),
          AMKStatusIndicator(subscribedSignal: "AMK1_Status")
        ],
      ),
      Column(
        children: const [
          NumericPanel(
            colsize: 6,
            title: "FR Status",
            subscribedSignals: [
              "AMK2_torque_current",
              "AMK2_magnetizing_current",
              "AMK2_error_info",
              "AMK2_temp_IGBT",
              "AMK2_temp_inverter",
              "AMK2_temp_motor",
            ],
          ),
          BooleanIndicator(subscribedSignal: "AMK2_DC_On"),
          BooleanIndicator(subscribedSignal: "AMK2_Enable"),
          BooleanIndicator(subscribedSignal: "AMK2_Error_Reset"),
          BooleanIndicator(subscribedSignal: "AMK2_Inverter_On"),
          AMKStatusIndicator(subscribedSignal: "AMK2_Status")
        ],
      ),
    ],
  ),
  const Titlebar(title: "AMK Rear Status"),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Column(
        children: const [
          NumericPanel(
            colsize: 6,
            title: "RL Status",
            subscribedSignals: [
              "AMK3_torque_current",
              "AMK3_magnetizing_current",
              "AMK3_error_info",
              "AMK3_temp_IGBT",
              "AMK3_temp_inverter",
              "AMK3_temp_motor",
            ],
          ),
          BooleanIndicator(subscribedSignal: "AMK3_DC_On"),
          BooleanIndicator(subscribedSignal: "AMK3_Enable"),
          BooleanIndicator(subscribedSignal: "AMK3_Error_Reset"),
          BooleanIndicator(subscribedSignal: "AMK3_Inverter_On"),
          AMKStatusIndicator(subscribedSignal: "AMK3_Status")
        ],
      ),
      Column(
        children: const [
          NumericPanel(
            colsize: 6,
            title: "RR Status",
            subscribedSignals: [
              "AMK4_torque_current",
              "AMK4_magnetizing_current",
              "AMK4_error_info",
              "AMK4_temp_IGBT",
              "AMK4_temp_inverter",
              "AMK4_temp_motor",
            ],
          ),
          BooleanIndicator(subscribedSignal: "AMK4_DC_On"),
          BooleanIndicator(subscribedSignal: "AMK4_Enable"),
          BooleanIndicator(subscribedSignal: "AMK4_Error_Reset"),
          BooleanIndicator(subscribedSignal: "AMK4_Inverter_On"),
          AMKStatusIndicator(subscribedSignal: "AMK4_Status")
        ],
      ),
    ],
  ),
  const Titlebar(title: "RPM and Temp"),
  const WaveformChart(
      subscribedSignals: [
        "AMK1_actual_velocity",
        "AMK2_actual_velocity",
        "AMK3_actual_velocity",
        "AMK4_actual_velocity",
      ],
      title: "AMK RPM",
      min: 0,
      max: 25000,
      multiplier: [1, 1, 1, 1]),
  const WaveformChart(
      subscribedSignals: [
        "AMK1_temp_inverter",
        "AMK2_temp_inverter",
        "AMK3_temp_inverter",
        "AMK4_temp_inverter",
      ],
      title: "AMK Inverter temp",
      min: 0,
      max: 80,
      multiplier: [1, 1, 1, 1]),
], minWidth: 750);

TabLayout mcuMobileLayout = TabLayout(shortcutLabels: const [
  "AMK Front Status",
  "AMK Rear Status",
  "RPM and Temp"
], layoutBreakpoints: const [
  0,
  1000,
  2000
], layout: [
  Titlebar(title: "AMK Front Status"),
  Column(
    children: [
      NumericPanel(subscribedSignals: [
        "AMK1_torque_current",
        "AMK1_magnetizing_current",
        "AMK1_error_info",
        "AMK1_temp_IGBT",
        "AMK1_temp_inverter",
        "AMK1_temp_motor",
      ], colsize: 6, title: "FL Status"),
      BooleanIndicator(subscribedSignal: "AMK1_DC_On"),
      BooleanIndicator(subscribedSignal: "AMK1_Enable"),
      BooleanIndicator(subscribedSignal: "AMK1_Error_Reset"),
      BooleanIndicator(subscribedSignal: "AMK1_Inverter_On"),
      AMKStatusIndicator(subscribedSignal: "AMK1_Status")
    ],
  ),
  Column(
    children: [
      NumericPanel(subscribedSignals: [
        "AMK2_torque_current",
        "AMK2_magnetizing_current",
        "AMK2_error_info",
        "AMK2_temp_IGBT",
        "AMK2_temp_inverter",
        "AMK2_temp_motor",
      ], colsize: 6, title: "FR Status"),
      BooleanIndicator(subscribedSignal: "AMK2_DC_On"),
      BooleanIndicator(subscribedSignal: "AMK2_Enable"),
      BooleanIndicator(subscribedSignal: "AMK2_Error_Reset"),
      BooleanIndicator(subscribedSignal: "AMK2_Inverter_On"),
      AMKStatusIndicator(subscribedSignal: "AMK2_Status")
    ],
  ),
  Titlebar(title: "AMK Rear Status"),
  Column(
    children: [
      NumericPanel(subscribedSignals: [
        "AMK3_torque_current",
        "AMK3_magnetizing_current",
        "AMK3_error_info",
        "AMK3_temp_IGBT",
        "AMK3_temp_inverter",
        "AMK3_temp_motor",
      ], colsize: 6, title: "RL Status"),
      BooleanIndicator(subscribedSignal: "AMK3_DC_On"),
      BooleanIndicator(subscribedSignal: "AMK3_Enable"),
      BooleanIndicator(subscribedSignal: "AMK3_Error_Reset"),
      BooleanIndicator(subscribedSignal: "AMK3_Inverter_On"),
      AMKStatusIndicator(subscribedSignal: "AMK3_Status")
    ],
  ),
  Column(
    children: [
      NumericPanel(subscribedSignals: [
        "AMK4_torque_current",
        "AMK4_magnetizing_current",
        "AMK4_error_info",
        "AMK4_temp_IGBT",
        "AMK4_temp_inverter",
        "AMK4_temp_motor",
      ], colsize: 6, title: "RR Status"),
      BooleanIndicator(subscribedSignal: "AMK4_DC_On"),
      BooleanIndicator(subscribedSignal: "AMK4_Enable"),
      BooleanIndicator(subscribedSignal: "AMK4_Error_Reset"),
      BooleanIndicator(subscribedSignal: "AMK4_Inverter_On"),
      AMKStatusIndicator(subscribedSignal: "AMK4_Status")
    ],
  ),
  Titlebar(title: "RPM and Temp"),
  const WaveformChart(
      subscribedSignals: [
        "AMK1_actual_velocity",
        "AMK2_actual_velocity",
        "AMK3_actual_velocity",
        "AMK4_actual_velocity",
      ],
      title: "AMK RPM",
      min: 0,
      max: 25000,
      multiplier: [1, 1, 1, 1]),
  const WaveformChart(
      subscribedSignals: [
        "AMK1_temp_inverter",
        "AMK2_temp_inverter",
        "AMK3_temp_inverter",
        "AMK4_temp_inverter",
      ],
      title: "AMK Inverter temp",
      min: 0,
      max: 80,
      multiplier: [1, 1, 1, 1]),
], minWidth: 300);
