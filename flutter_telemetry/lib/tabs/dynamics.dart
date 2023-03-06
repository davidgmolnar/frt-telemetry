import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

List<Widget> dynamicsSmall = [
  const Titlebar(title: "Dynamics Measurements"),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      NumericPanel(
        subscribedSignals: [
          "Acc_Front_AccX",
          "AccX_Rear",
          "Acc_Front_AccY",
          "AccY_Rear",
          "Acc_Front_RollRate",
          "Vectornav_yaw_rate_rear_value",
          "VIRT_ACC_FRONT_YAW_RAD",
          "Yaw_Rate_Rear"
        ],
        colsize: 4, title: "Dynamics"
      ),
      ScaleIndicator(subscribedSignal: "VIRT_AVG_APPS", maxValue: 100, minValue: 0),
      ScaleIndicator(subscribedSignal: "VIRT_AVG_APPS", maxValue: 180, minValue: 0),
      BooleanPanel(
        subscribedSignals: [
          "APPS_plausiblity",
          "STA_plausiblity",
          "VIRT_APPS_VALID",
          "VIRT_STA_VALID"
        ],
        colsize: 4, title: "Pedal Node"
      )
    ],
  ),
  const Titlebar(title: "Charts"),
];

List<Widget> dynamicsBig = [
  const Titlebar(title: "Dynamics Measurements"),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      NumericPanel(
        subscribedSignals: [
          "Acc_Front_AccX",
          "AccX_Rear",
          "Acc_Front_AccY",
          "AccY_Rear",
          "Acc_Front_RollRate",
          "Vectornav_yaw_rate_rear_value",
          "VIRT_ACC_FRONT_YAW_RAD",
          "Yaw_Rate_Rear"
        ],
        colsize: 4, title: "Dynamics"
      ),
      ScaleIndicator(subscribedSignal: "VIRT_AVG_APPS", maxValue: 100, minValue: 0),
      ScaleIndicator(subscribedSignal: "VIRT_AVG_APPS", maxValue: 180, minValue: 0),
      BooleanPanel(
        subscribedSignals: [
          "APPS_plausiblity",
          "STA_plausiblity",
          "VIRT_APPS_VALID",
          "VIRT_STA_VALID"
        ],
        colsize: 4, title: "Pedal Node"
      )
    ],
  ),
  const Titlebar(title: "Charts"),
    Row(
    children: const [
      Flexible(
        child: WaveformChart(
          subscribedSignals: ["Brake_Force_sensor"], multiplier: [1],
          title: "BFS", min: 0, max: 1500,
        ),
      ),
      Flexible(
        child: WaveformChart(
          subscribedSignals: ["Brake_pressure_front", "Brake_pressure_rear"], multiplier: [1,1],
          title: "BPS", min: 0, max: 100,
        ),
      )
    ]
  ),
];