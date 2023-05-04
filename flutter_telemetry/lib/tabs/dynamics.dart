import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout dynamicsBigLayout =
    TabLayout(shortcutLabels: const [], layoutBreakpoints: const [], layout: [
  const Titlebar(title: "Dynamics Measurements"),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      NumericPanel(subscribedSignals: [
        "Acc_Front_AccX",
        "AccX_Rear",
        "Acc_Front_AccY",
        "AccY_Rear",
        "Acc_Front_RollRate",
        "Vectornav_yaw_rate_rear_value",
        "VIRT_ACC_FRONT_YAW_RAD",
        "Yaw_Rate_Rear"
      ], colsize: 4, title: "Dynamics"),
      ScaleIndicator(
          subscribedSignal: "VIRT_AVG_APPS", maxValue: 100, minValue: 0),
      ScaleIndicator(
          subscribedSignal: "VIRT_AVG_STA", maxValue: 180, minValue: 0),
      BooleanPanel(subscribedSignals: [
        "APPS_plausiblity",
        "STA_plausiblity",
        "VIRT_APPS_VALID",
        "VIRT_STA_VALID"
      ], colsize: 4, title: "Pedal Node")
    ],
  ),
  const Titlebar(title: "Charts"),
  Row(children: const [
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["Brake_Force_sensor"],
        title: "BFS",
        min: 0,
        max: 1500,
      ),
    ),
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["Brake_pressure_front", "Brake_pressure_rear"],
        title: "BPS",
        min: 0,
        max: 100,
      ),
    )
  ]),
  const TimeSeriesChart(
    subscribedSignals: ["AccX_Rear", "AccY_Rear"],
    title: "Accel",
    min: -4,
    max: 4,
  ),
  Row(children: const [
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["HV_Current"],
        title: "HV Current",
        min: -150,
        max: 200,
      ),
    ),
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["VIRT_HV_POWER_OUT"],
        title: "HV Power",
        min: -80000,
        max: 90000,
      ),
    )
  ]),
  Row(children: const [
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["Yaw_Rate_Rear"],
        title: "Yaw Rate",
        min: -10,
        max: 10,
      ),
    ),
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["VIRT_AVG_APPS", "VIRT_AVG_STA"],
        title: "APPS / STA Avg",
        min: 0,
        max: 180,
      ),
    )
  ]),
], minWidth: 1000);

TabLayout dynamicsSmallLayout =
    TabLayout(shortcutLabels: const [], layoutBreakpoints: const [], layout: [
  const Titlebar(title: "Dynamics Measurements"),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      const NumericPanel(subscribedSignals: [
        "Acc_Front_AccX",
        "AccX_Rear",
        "Acc_Front_AccY",
        "AccY_Rear",
        "Acc_Front_RollRate",
        "Vectornav_yaw_rate_rear_value",
        "VIRT_ACC_FRONT_YAW_RAD",
        "Yaw_Rate_Rear"
      ], colsize: 8, title: "Dynamics"),
      Column(
        children: [
          const BooleanPanel(subscribedSignals: [
            "APPS_plausiblity",
            "STA_plausiblity",
            "VIRT_APPS_VALID",
            "VIRT_STA_VALID"
          ], colsize: 4, title: "Pedal Node"),
          Row(
            children: const [
              ScaleIndicator(
                  subscribedSignal: "VIRT_AVG_APPS",
                  maxValue: 100,
                  minValue: 0),
              ScaleIndicator(
                  subscribedSignal: "VIRT_AVG_STA", maxValue: 180, minValue: 0),
            ],
          ),
        ],
      )
    ],
  ),
  const Titlebar(title: "Charts"),
  const TimeSeriesChart(
    subscribedSignals: ["Brake_Force_sensor"],
    title: "BFS",
    min: 0,
    max: 1500,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["Brake_pressure_front", "Brake_pressure_rear"],
    title: "BPS",
    min: 0,
    max: 100,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["AccX_Rear", "AccY_Rear"],
    title: "Accel",
    min: -4,
    max: 4,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["HV_Current"],
    title: "HV Current",
    min: -150,
    max: 200,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["VIRT_HV_POWER_OUT"],
    title: "HV Power",
    min: -80000,
    max: 90000,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["Yaw_Rate_Rear"],
    title: "Yaw Rate",
    min: -10,
    max: 10,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["VIRT_AVG_APPS", "VIRT_AVG_STA"],
    title: "APPS / STA Avg",
    min: 0,
    max: 180,
  ),
], minWidth: 450);

TabLayout dynamicsMobileLayout =
    TabLayout(layoutBreakpoints: const [], shortcutLabels: const [], layout: [
  const Titlebar(title: "Dynamics Measurements"),
  const NumericPanel(subscribedSignals: [
    "Acc_Front_AccX",
    "AccX_Rear",
    "Acc_Front_AccY",
    "AccY_Rear",
    "Acc_Front_RollRate",
    "Vectornav_yaw_rate_rear_value",
    "VIRT_ACC_FRONT_YAW_RAD",
    "Yaw_Rate_Rear"
  ], colsize: 8, title: "Dynamics"),
  const BooleanPanel(subscribedSignals: [
    "APPS_plausiblity",
    "STA_plausiblity",
    "VIRT_APPS_VALID",
    "VIRT_STA_VALID"
  ], colsize: 4, title: "Pedal Node"),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      ScaleIndicator(
          subscribedSignal: "VIRT_AVG_APPS", maxValue: 100, minValue: 0),
      ScaleIndicator(
          subscribedSignal: "VIRT_AVG_STA", maxValue: 180, minValue: 0),
    ],
  ),
  const TimeSeriesChart(
    subscribedSignals: ["Brake_Force_sensor"],
    title: "BFS",
    min: 0,
    max: 1500,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["Brake_pressure_front", "Brake_pressure_rear"],
    title: "BPS",
    min: 0,
    max: 100,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["AccX_Rear", "AccY_Rear"],
    title: "Accel",
    min: -4,
    max: 4,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["HV_Current"],
    title: "HV Current",
    min: -150,
    max: 200,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["VIRT_HV_POWER_OUT"],
    title: "HV Power",
    min: -80000,
    max: 90000,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["Yaw_Rate_Rear"],
    title: "Yaw Rate",
    min: -10,
    max: 10,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["VIRT_AVG_APPS", "VIRT_AVG_STA"],
    title: "APPS / STA Avg",
    min: 0,
    max: 180,
  ),
], minWidth: 300);
