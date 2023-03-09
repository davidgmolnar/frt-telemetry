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
      ScaleIndicator(subscribedSignal: "VIRT_AVG_STA", maxValue: 180, minValue: 0),
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
  const WaveformChart(
    subscribedSignals: ["Brake_Force_sensor"], multiplier: [1],
    title: "BFS", min: 0, max: 1500,
  ),
  const WaveformChart(
    subscribedSignals: ["Brake_pressure_front", "Brake_pressure_rear"], multiplier: [1,1],
    title: "BPS", min: 0, max: 100,
  ),
  const WaveformChart(
    subscribedSignals: ["AccX_Rear", "AccY_Rear"], multiplier: [1,1],
    title: "Accel", min: -4, max: 4,
  ),
  const WaveformChart(
    subscribedSignals: ["HV_Current"], multiplier: [1],
    title: "HV Current", min: -150, max: 200,
  ),
  const WaveformChart(
    subscribedSignals: ["VIRT_HV_POWER_OUT"], multiplier: [1],
    title: "HV Power", min: -80000, max: 90000,
  ),
  const WaveformChart(
    subscribedSignals: ["Yaw_Rate_Rear"], multiplier: [1],
    title: "Yaw Rate", min: -10, max: 10,
  ),
  const WaveformChart(
    subscribedSignals: ["VIRT_AVG_APPS", "VIRT_AVG_STA"], multiplier: [1,1],
    title: "APPS / STA Avg", min: 0, max: 180,
  ),
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
      ScaleIndicator(subscribedSignal: "VIRT_AVG_STA", maxValue: 180, minValue: 0),
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
  const WaveformChart(
    subscribedSignals: ["AccX_Rear", "AccY_Rear"], multiplier: [1,1],
    title: "Accel", min: -4, max: 4,
  ),
  Row(
    children: const [
      Flexible(
        child: WaveformChart(
          subscribedSignals: ["HV_Current"], multiplier: [1],
          title: "HV Current", min: -150, max: 200,
        ),
      ),
      Flexible(
        child: WaveformChart(
          subscribedSignals: ["VIRT_HV_POWER_OUT"], multiplier: [1],
          title: "HV Power", min: -80000, max: 90000,
        ),
      )
    ]
  ),
  Row(
    children: const [
      Flexible(
        child: WaveformChart(
          subscribedSignals: ["Yaw_Rate_Rear"], multiplier: [1],
          title: "Yaw Rate", min: -10, max: 10,
        ),
      ),
      Flexible(
        child: WaveformChart(
          subscribedSignals: ["VIRT_AVG_APPS", "VIRT_AVG_STA"], multiplier: [1,1],
          title: "APPS / STA Avg", min: 0, max: 180,
        ),
      )
    ]
  ),
];