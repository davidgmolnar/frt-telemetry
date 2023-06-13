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
        const ScaleIndicator(
            subscribedSignal: "Xavier_CPU1_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(
            subscribedSignal: "Xavier_CPU2_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(
            subscribedSignal: "Xavier_CPU3_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(
            subscribedSignal: "Xavier_CPU4_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(
            subscribedSignal: "Xavier_CPU5_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(
            subscribedSignal: "Xavier_CPU6_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(
            subscribedSignal: "Xavier_CPU7_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(
            subscribedSignal: "Xavier_CPU8_usage", maxValue: 100, minValue: 0),
        const ScaleIndicator(
            subscribedSignal: "Xavier_RAM_usage", maxValue: 100, minValue: 0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            BooleanIndicator(subscribedSignal: "ASMS", isInverted: true,),
            FourStateLed(subscribedSignal: "Xavier_LED", paddingFactor: 1),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            StringIndicator(
                subscribedSignal: "ASSI_state", decoder: assiStateDecoder),
            StringIndicator(
                subscribedSignal: "AS_State", decoder: asStateDecoder),
            StringIndicator(
                subscribedSignal: "AS_Mission_selected",
                decoder: missionSelectDecoder),
            StringIndicator(
                subscribedSignal: "Initial_Checkup_state",
                decoder: initialCheckupStateDecoder),
          ],
        ),
      ],
    ),
    Row(children: const [
      Flexible(
        child: TimeSeriesChart(
          subscribedSignals: ["Xavier_Target_speed"],
          title: "Target speed m/s",
          min: 0,
          max: 65,
        ),
      ),
      Flexible(
        child: TimeSeriesChart(
          subscribedSignals: ["VIRT_XAVIER_TARGET_ANGLE_DEG"],
          title: "Target steer °",
          min: -90,
          max: 90,
        ),
      )
    ]),
    const Titlebar(title: "AS Signals"),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const NumericPanel(subscribedSignals: [
          "Xavier_Power",
          "Xavier_MAX_temperature",
          "Xavier_target_laps",
          "Xavier_current_laps",
        ], colsize: 4, title: "Xavier data"),
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
            NumericPanel(subscribedSignals: [
              "Xavier_runtime",
              "Xavier_eff_n_particles",
              "Xavier_n_updates_last_resample"
            ], colsize: 3, title: "Xavier Logic"),
            BooleanIndicator(subscribedSignal: "BAG_START")
          ],
        )
      ],
    ),
    Row(children: const [
      Flexible(
        child: TimeSeriesChart(
          subscribedSignals: ["Xavier_headingErrorSS", "Xavier_yawRateError"],
          title: "HeadingSS-Yaw",
          min: -26,
          max: 26,
        ),
      ),
      Flexible(
        child: TimeSeriesChart(
          subscribedSignals: [
            "Xavier_headingError",
            "Xavier_steeringAngleError",
            "Xavier_crossTrackError"
          ],
          title: "Heading-Steering",
          min: -4,
          max: 4,
        ),
      )
    ]),
  ],
  minWidth: 1170,
);

TabLayout asSmallLayout = TabLayout(
  shortcutLabels: const ["AS Status", "AS Signals"],
  layoutBreakpoints: const [0, 1100],
  layout: [
    const Titlebar(title: "AS Status"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        ScaleIndicator(
            subscribedSignal: "Xavier_CPU1_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(
            subscribedSignal: "Xavier_CPU2_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(
            subscribedSignal: "Xavier_CPU3_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(
            subscribedSignal: "Xavier_CPU4_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(
            subscribedSignal: "Xavier_CPU5_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(
            subscribedSignal: "Xavier_CPU6_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(
            subscribedSignal: "Xavier_CPU7_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(
            subscribedSignal: "Xavier_CPU8_usage", maxValue: 100, minValue: 0),
        ScaleIndicator(
            subscribedSignal: "Xavier_RAM_usage", maxValue: 100, minValue: 0),
      ],
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            BooleanIndicator(subscribedSignal: "ASMS", isInverted: true,),
            FourStateLed(subscribedSignal: "Xavier_LED", paddingFactor: 1),
          ],
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          StringIndicator(
              subscribedSignal: "ASSI_state", decoder: assiStateDecoder),
          StringIndicator(
              subscribedSignal: "AS_State", decoder: asStateDecoder),
          StringIndicator(
              subscribedSignal: "AS_Mission_selected",
              decoder: missionSelectDecoder),
          StringIndicator(
              subscribedSignal: "Initial_Checkup_state",
              decoder: initialCheckupStateDecoder),
        ]),
      ],
    ),
    const TimeSeriesChart(
      subscribedSignals: ["Xavier_Target_speed"],
      title: "Target speed m/s",
      min: 0,
      max: 65,
    ),
    const TimeSeriesChart(
      subscribedSignals: ["VIRT_XAVIER_TARGET_ANGLE_DEG"],
      title: "Target steer °",
      min: -90,
      max: 90,
    ),
    const Titlebar(title: "AS Signals"),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        NumericPanel(subscribedSignals: [
          "Xavier_Power",
          "Xavier_MAX_temperature",
          "Xavier_target_laps",
          "Xavier_current_laps",
          "Xavier_runtime",
          "Xavier_eff_n_particles",
          "Xavier_n_updates_last_resample"
        ], colsize: 7, title: "Xavier data"),
        BooleanPanel(subscribedSignals: [
          "Driving_State_Active",
          "nEBS_SET_ACTIVE",
          "DV_SDC_READY",
          "Xavier_missionFinished",
          "Xavier_loopClosed",
          "BAG_START"
        ], colsize: 6, title: "Xavier Status"),
      ],
    ),
    const TimeSeriesChart(
      subscribedSignals: ["Xavier_headingErrorSS", "Xavier_yawRateError"],
      title: "HeadingSS-Yaw",
      min: -26,
      max: 26,
    ),
    const TimeSeriesChart(
      subscribedSignals: [
        "Xavier_headingError",
        "Xavier_steeringAngleError",
        "Xavier_crossTrackError"
      ],
      title: "Heading-Steering",
      min: -4,
      max: 4,
    ),
  ],
  minWidth: 600,
);

TabLayout asMobileLayout = TabLayout(layoutBreakpoints: [
  0,
  1450
], shortcutLabels: [
  "AS Status",
  "AS Signals"
], layout: [
  const Titlebar(title: "AS Status"),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      ScaleIndicator(
          subscribedSignal: "Xavier_CPU1_usage",
          maxValue: 100,
          minValue: 0),
      ScaleIndicator(
          subscribedSignal: "Xavier_CPU2_usage",
          maxValue: 100,
          minValue: 0),
      ScaleIndicator(
          subscribedSignal: "Xavier_CPU3_usage",
          maxValue: 100,
          minValue: 0),
      ScaleIndicator(
          subscribedSignal: "Xavier_CPU4_usage",
          maxValue: 100,
          minValue: 0),
      ScaleIndicator(
          subscribedSignal: "Xavier_CPU5_usage",
          maxValue: 100,
          minValue: 0),
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      ScaleIndicator(
          subscribedSignal: "Xavier_CPU6_usage",
          maxValue: 100,
          minValue: 0),
      ScaleIndicator(
          subscribedSignal: "Xavier_CPU7_usage",
          maxValue: 100,
          minValue: 0),
      ScaleIndicator(
          subscribedSignal: "Xavier_CPU8_usage",
          maxValue: 100,
          minValue: 0),
      ScaleIndicator(
          subscribedSignal: "Xavier_RAM_usage",
          maxValue: 100,
          minValue: 0),
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Column(
        children: const [
          BooleanIndicator(subscribedSignal: "ASMS", isInverted: true,),
            FourStateLed(subscribedSignal: "Xavier_LED", paddingFactor: 1),
        ],
      ),
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            StringIndicator(
                subscribedSignal: "ASSI_state",
                decoder: assiStateDecoder),
            StringIndicator(
                subscribedSignal: "AS_State", decoder: asStateDecoder),
            StringIndicator(
                subscribedSignal: "AS_Mission_selected",
                decoder: missionSelectDecoder),
            StringIndicator(
                subscribedSignal: "Initial_Checkup_state",
                decoder: initialCheckupStateDecoder),
          ]),
    ],
  ),
  const TimeSeriesChart(
    subscribedSignals: ["Xavier_Target_speed"],
    title: "Target speed m/s",
    min: 0,
    max: 65,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["VIRT_XAVIER_TARGET_ANGLE_DEG"],
    title: "Target steer °",
    min: -90,
    max: 90,
  ),
  const Titlebar(title: "AS Signals"),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Column(
        children: const [
          NumericPanel(subscribedSignals: [
            "Xavier_Power",
            "Xavier_MAX_temperature",
            "Xavier_target_laps",
            "Xavier_current_laps",
            "Xavier_runtime",
            "Xavier_eff_n_particles",
            "Xavier_n_updates_last_resample"
          ], colsize: 7, title: "Xavier data"),
          BooleanPanel(subscribedSignals: [
            "Driving_State_Active",
            "nEBS_SET_ACTIVE",
            "DV_SDC_READY",
            "Xavier_missionFinished",
            "Xavier_loopClosed",
            "BAG_START"
          ], colsize: 6, title: "Xavier Status"),
        ],
      )
    ],
  ),
  const TimeSeriesChart(
    subscribedSignals: ["Xavier_headingErrorSS", "Xavier_yawRateError"],
    title: "HeadingSS-Yaw",
    min: -26,
    max: 26,
  ),
  const TimeSeriesChart(
    subscribedSignals: [
      "Xavier_headingError",
      "Xavier_steeringAngleError",
      "Xavier_crossTrackError"
    ],
    title: "Heading-Steering",
    min: -4,
    max: 4,
  )
], minWidth: 300);
