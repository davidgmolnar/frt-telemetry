import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout asBigLayout = TabLayout(
  shortcutLabels: const ["AS Status", "AS Signals"],
  layoutBreakpoints: const [0, 600],
  layout: [
    const Titlebar(title: "AS Status"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ScaleIndicator(subscribedSignal: "Xavier_CPU1_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(subscribedSignal: "Xavier_CPU2_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(subscribedSignal: "Xavier_CPU3_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(subscribedSignal: "Xavier_CPU4_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(subscribedSignal: "Xavier_CPU5_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(subscribedSignal: "Xavier_CPU6_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(subscribedSignal: "Xavier_CPU7_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(subscribedSignal: "Xavier_CPU8_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(subscribedSignal: "Xavier_RAM_usage", maxValue: 100, minValue: 0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            BooleanIndicator(subscribedSignal: "ASMS"),
            BooleanIndicator(subscribedSignal: "ON_Car_State"),
            BooleanIndicator(subscribedSignal: "OFF_Car_State"),
            BooleanIndicator(subscribedSignal: "RTDS_Car_State"),
            BooleanIndicator(subscribedSignal: "START_Car_State"),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            FourStateLed(subscribedSignal: "ASB_ERROR_LED", paddingFactor: 1),
            FourStateLed(subscribedSignal: "INSPECTION_LED", paddingFactor: 1),
            FourStateLed(subscribedSignal: "SKIDPAD_LED", paddingFactor: 1),
            FourStateLed(subscribedSignal: "TRACKDRIVE_LED", paddingFactor: 1),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            StringIndicator(subscribedSignal: "ASSI_state", decoder: assiStateDecoder),
            StringIndicator(subscribedSignal: "AS_State", decoder: asStateDecoder),
            StringIndicator(subscribedSignal: "AS_Mission_selected", decoder: missionSelectDecoder),
            StringIndicator(subscribedSignal: "Initial_Checkup_state", decoder: initialCheckupStateDecoder),
          ],
        ),
      ],
    ),
    Row(
      children: const [
        Flexible(
          child: WaveformChart(
            subscribedSignals: ["Xavier_Target_speed"], multiplier: [3.6],
            title: "Target speed km/h", min: 0, max: 120,
          ),
        ),
        Flexible(
          child: WaveformChart(
            subscribedSignals: ["Xavier_Target_Wheel_Angle"], multiplier: [180/pi],
            title: "Target steer °", min: -90, max: 90,
          ),
        )
      ]
    ),
    const Titlebar(title: "AS Signals"),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const NumericPanel(
          subscribedSignals: [
            "Xavier_Power",
            "Xavier_MAX_temperature",
            "Xavier_target_laps",
            "Xavier_current_laps",
          ],
          colsize: 4,
          title: "Xavier data"
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            BooleanIndicator(subscribedSignal: "Driving_State_Active"),
            BooleanIndicator(subscribedSignal: "nEBS_SET_ACTIVE"),
            BooleanIndicator(subscribedSignal: "DV_SDC_READY"),
            BooleanIndicator(subscribedSignal: "Xavier_missionFinished"),
            BooleanIndicator(subscribedSignal: "Xavier_loopClosed"),
          ],
        ),
        Column(
          children: const [
            NumericPanel(
              subscribedSignals: [
                "Xavier_runtime",
                "Xavier_eff_n_particles",
                "Xavier_n_updates_last_resample"
              ],
              colsize: 3,
              title: "Xavier Logic"
            ),
            BooleanIndicator(subscribedSignal: "BAG_START")
          ],
        )
      ],
    ),
    Row(
      children: const [
        Flexible(
          child: WaveformChart(
            subscribedSignals: ["Xavier_headingErrorSS", "Xavier_yawRateError"], multiplier: [1,1],
            title: "HeadingSS-Yaw", min: -26, max: 26,
          ),
        ),
        Flexible(
          child: WaveformChart(
            subscribedSignals: ["Xavier_headingError", "Xavier_steeringAngleError", "Xavier_crossTrackError"], multiplier: [1,1,1],
            title: "Heading-Steering", min: -4, max: 4,
          ),
        )
      ]
    ),
  ],
  minWidth: 1170,
);

TabLayout asSmallLayout = TabLayout(
  shortcutLabels: const ["AS Status", "AS Signals"],
  layoutBreakpoints: const [0, 1000],
  layout: [
    const Titlebar(title: "AS Status"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        ScaleIndicator(subscribedSignal: "Xavier_CPU1_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(subscribedSignal: "Xavier_CPU2_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(subscribedSignal: "Xavier_CPU3_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(subscribedSignal: "Xavier_CPU4_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(subscribedSignal: "Xavier_CPU5_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(subscribedSignal: "Xavier_CPU6_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(subscribedSignal: "Xavier_CPU7_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(subscribedSignal: "Xavier_CPU8_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(subscribedSignal: "Xavier_RAM_usage", maxValue: 100, minValue: 0),
      ],
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            BooleanIndicator(subscribedSignal: "ASMS"),
            BooleanIndicator(subscribedSignal: "ON_Car_State"),
            BooleanIndicator(subscribedSignal: "OFF_Car_State"),
            BooleanIndicator(subscribedSignal: "RTDS_Car_State"),
            BooleanIndicator(subscribedSignal: "START_Car_State"),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            FourStateLed(subscribedSignal: "ASB_ERROR_LED", paddingFactor: 1),
            FourStateLed(subscribedSignal: "INSPECTION_LED", paddingFactor: 1),
            FourStateLed(subscribedSignal: "SKIDPAD_LED", paddingFactor: 1),
            FourStateLed(subscribedSignal: "TRACKDRIVE_LED", paddingFactor: 1),
          ]
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            StringIndicator(subscribedSignal: "ASSI_state", decoder: assiStateDecoder),
            StringIndicator(subscribedSignal: "AS_State", decoder: asStateDecoder),
            StringIndicator(subscribedSignal: "AS_Mission_selected", decoder: missionSelectDecoder),
            StringIndicator(subscribedSignal: "Initial_Checkup_state", decoder: initialCheckupStateDecoder),
          ]
        ),
      ],
    ),
    const WaveformChart(
      subscribedSignals: ["Xavier_Target_speed"], multiplier: [3.6],
      title: "Target speed km/h", min: 0, max: 120,
    ),
    const WaveformChart(
      subscribedSignals: ["Xavier_Target_Wheel_Angle"], multiplier: [180/pi],
      title: "Target steer °", min: -90, max: 90,
    ),
    const Titlebar(title: "AS Signals"),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        NumericPanel(
          subscribedSignals: [
            "Xavier_Power",
            "Xavier_MAX_temperature",
            "Xavier_target_laps",
            "Xavier_current_laps",
            "Xavier_runtime",
            "Xavier_eff_n_particles",
            "Xavier_n_updates_last_resample"
          ],
          colsize: 7,
          title: "Xavier data"
        ),
        BooleanPanel(
          subscribedSignals: [
            "Driving_State_Active",
            "nEBS_SET_ACTIVE",
            "DV_SDC_READY",
            "Xavier_missionFinished",
            "Xavier_loopClosed",
            "BAG_START"
          ],
          colsize: 6,
          title: "Xavier Status"
        ),
      ],
    ),
    const WaveformChart(
      subscribedSignals: ["Xavier_headingErrorSS", "Xavier_yawRateError"], multiplier: [1,1],
      title: "HeadingSS-Yaw", min: -26, max: 26,
    ),
    const WaveformChart(
      subscribedSignals: ["Xavier_headingError", "Xavier_steeringAngleError", "Xavier_crossTrackError"], multiplier: [1,1,1],
      title: "Heading-Steering", min: -4, max: 4,
    ),
  ],
  minWidth: 600,
);