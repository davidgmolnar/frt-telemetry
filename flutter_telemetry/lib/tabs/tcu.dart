import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout tcuBigLayout = TabLayout(shortcutLabels: const [
  "VDC Status",
  "Charts"
], layoutBreakpoints: const [
  0,
  900
], layout: [
  const Titlebar(
    title: "VDC Status",
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      NumericPanel(
        title: "AMK data",
        colsize: 4,
        subscribedSignals: [
          "AMK1_Torque_Limit_Positive",
          "AMK1_Torque_Limit_Negative",
          "AMK1_Target_Velocity",
          "VDC_Fz_FL",
          "AMK2_Torque_Limit_Positive",
          "AMK2_Torque_Limit_Negative",
          "AMK2_Target_Velocity",
          "VDC_Fz_FR",
          "AMK3_TorqueLimitPositive",
          "AMK3_TorqueLimitNegative",
          "AMK3_Target_Velocity",
          "VDC_Fz_RL",
          "AMK4_TorqueLimitPositive",
          "AMK4_TorqueLimitNegative",
          "AMK4_Target_Velocity",
          "VDC_Fz_RR",
        ],
      )
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      BooleanPanel(subscribedSignals: [
        "VDC_Powerlimiter_Hardcore_On",
        "VDC_Powerlimiter_Throttle_On",
        "VDC_Powerlimiter_Torque_On",
        "VDC_Powerlimiter_Efficiency_On",
        "VDC_Slip_Control_ON",
        "VDC_Traction_Control_On",
        "VDC_Safety_Mode",
      ], colsize: 7, title: "VDC Status"),
      NumericPanel(subscribedSignals: [
        "VDC_Lateral_Balance",
        "VDC_Throttle_Breakpoint",
        "VDC_Static_Weight_Distribution",
        "VDC_Brake_Force_Max",
        "VDC_Braking_Torque_Multiplier",
        "VDC_Driving_Torque_Multiplier",
        "VDC_Yaw_Control_P",
        "VDC_Yaw_Control_Balance",
        "VDC_RPM_Max",
        "VDC_Power_Max",
        "VDC_Max_Motor_Torque",
        "VDC_Powlim_Approx",
        "VDC_Launch_Control_Mu",
        "VDC_Drop_Parameter_New",
        "VDC_Drop_Parameter",
        "VDC_Efficiency_Tune",
        "VDC_TC_Threshold",
        "TCU_CPU_Usage_Max",
        "VDC_Target_SoC",
        "VDC_Laps",
        "v_x"
      ], colsize: 7, title: "TCU Logic"),
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const NumericPanel(subscribedSignals: [
        "VDC_Optimal_Slip",
        "VDC_Slip_Control_P",
        "VDC_Slip_Control_I",
        "VDC_Slip_Control_D",
        "VDC_M_Yaw",
        "VDC_M_Yaw_Limit",
        "VDC_Yaw_Control_Weight_Selector"
      ], colsize: 7, title: "Slip"),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          NumericPanel(subscribedSignals: [
            "EPOS_Statusword",
            "EPOS_Position_actual_value",
            "EPOS_Torque_actual_value"
          ], colsize: 3, title: "EPOS"),
          StringIndicator(
              subscribedSignal: "VDC_MCU_State", decoder: vdcStateDecoder),
          StringIndicator(
              subscribedSignal: "VDC_EPOS_State", decoder: vdcStateDecoder),
        ],
      )
    ],
  ),
  const Titlebar(
    title: "Charts",
  ),
  const WaveformChart(
    subscribedSignals: [
      "VIRT_AMK1_LIMIT",
      "VIRT_AMK2_LIMIT",
      "VIRT_AMK3_LIMIT",
      "VIRT_AMK4_LIMIT"
    ],
    multiplier: [1, 1, 1, 1],
    title: "Torque Limits",
    min: 0,
    max: 25000,
  ),
  Row(children: const [
    Flexible(
      child: WaveformChart(
        subscribedSignals: ["VDC_Torque_Demand"],
        multiplier: [1],
        title: "Torque demand",
        min: 0,
        max: 300,
      ),
    ),
    Flexible(
      child: WaveformChart(
        subscribedSignals: ["Xavier_Target_Wheel_Angle"],
        multiplier: [180 / pi],
        title: "Target steer °",
        min: -90,
        max: 90,
      ),
    )
  ]),
], minWidth: 1200);

TabLayout tcuSmallLayout = TabLayout(shortcutLabels: const [
  "VDC Status",
  "Charts"
], layoutBreakpoints: const [
  0,
  1300
], layout: [
  const Titlebar(
    title: "VDC Status",
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      NumericPanel(
        title: "AMK data",
        colsize: 8,
        subscribedSignals: [
          "AMK1_Torque_Limit_Positive",
          "AMK1_Torque_Limit_Negative",
          "AMK1_Target_Velocity",
          "VDC_Fz_FL",
          "AMK3_TorqueLimitPositive",
          "AMK3_TorqueLimitNegative",
          "AMK3_Target_Velocity",
          "VDC_Fz_RL",
          "AMK2_Torque_Limit_Positive",
          "AMK2_Torque_Limit_Negative",
          "AMK2_Target_Velocity",
          "VDC_Fz_FR",
          "AMK4_TorqueLimitPositive",
          "AMK4_TorqueLimitNegative",
          "AMK4_Target_Velocity",
          "VDC_Fz_RR",
        ],
      )
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Column(
        children: const [
          BooleanPanel(subscribedSignals: [
            "VDC_Powerlimiter_Hardcore_On",
            "VDC_Powerlimiter_Throttle_On",
            "VDC_Powerlimiter_Torque_On",
            "VDC_Powerlimiter_Efficiency_On",
            "VDC_Slip_Control_ON",
            "VDC_Traction_Control_On",
            "VDC_Safety_Mode",
          ], colsize: 7, title: "VDC Status"),
          StringIndicator(
              subscribedSignal: "VDC_MCU_State", decoder: vdcStateDecoder),
          StringIndicator(
              subscribedSignal: "VDC_EPOS_State", decoder: vdcStateDecoder),
        ],
      ),
      const NumericPanel(subscribedSignals: [
        "VDC_Optimal_Slip",
        "VDC_Slip_Control_P",
        "VDC_Slip_Control_I",
        "VDC_Slip_Control_D",
        "VDC_M_Yaw",
        "VDC_M_Yaw_Limit",
        "VDC_Yaw_Control_Weight_Selector",
        "EPOS_Statusword",
        "EPOS_Position_actual_value",
        "EPOS_Torque_actual_value"
      ], colsize: 10, title: "Slip and EPOS"),
    ],
  ),
  const NumericPanel(subscribedSignals: [
    "VDC_Lateral_Balance",
    "VDC_Throttle_Breakpoint",
    "VDC_Static_Weight_Distribution",
    "VDC_Brake_Force_Max",
    "VDC_Braking_Torque_Multiplier",
    "VDC_Driving_Torque_Multiplier",
    "VDC_Yaw_Control_P",
    "VDC_Yaw_Control_Balance",
    "VDC_RPM_Max",
    "VDC_Power_Max",
    "VDC_Max_Motor_Torque",
    "VDC_Powlim_Approx",
    "VDC_Launch_Control_Mu",
    "VDC_Drop_Parameter_New",
    "VDC_Drop_Parameter",
    "VDC_Efficiency_Tune",
    "VDC_TC_Threshold",
    "TCU_CPU_Usage_Max",
    "VDC_Target_SoC",
    "VDC_Laps",
    "v_x"
  ], colsize: 11, title: "TCU Logic"),
  const Titlebar(
    title: "Charts",
  ),
  const WaveformChart(
    subscribedSignals: [
      "VIRT_AMK1_LIMIT",
      "VIRT_AMK2_LIMIT",
      "VIRT_AMK3_LIMIT",
      "VIRT_AMK4_LIMIT"
    ],
    multiplier: [1, 1, 1, 1],
    title: "Torque Limits",
    min: 0,
    max: 25000,
  ),
  const WaveformChart(
    subscribedSignals: ["VDC_Torque_Demand"],
    multiplier: [1],
    title: "Torque demand",
    min: 0,
    max: 300,
  ),
  const WaveformChart(
    subscribedSignals: ["Xavier_Target_Wheel_Angle"],
    multiplier: [180 / pi],
    title: "Target steer °",
    min: -90,
    max: 90,
  ),
], minWidth: 660);

TabLayout tcuMobileLayout = TabLayout(shortcutLabels: [
  "VDC Status",
  "Charts"
], layoutBreakpoints: [
  0,
  2350
], layout: [
  const Titlebar(title: "VDC Status"),
  Column(
    children: [
      const NumericPanel(
        title: "AMK data",
        colsize: 16,
        subscribedSignals: [
          "AMK1_Torque_Limit_Positive",
          "AMK1_Torque_Limit_Negative",
          "AMK1_Target_Velocity",
          "VDC_Fz_FL",
          "AMK3_TorqueLimitPositive",
          "AMK3_TorqueLimitNegative",
          "AMK3_Target_Velocity",
          "VDC_Fz_RL",
          "AMK2_Torque_Limit_Positive",
          "AMK2_Torque_Limit_Negative",
          "AMK2_Target_Velocity",
          "VDC_Fz_FR",
          "AMK4_TorqueLimitPositive",
          "AMK4_TorqueLimitNegative",
          "AMK4_Target_Velocity",
          "VDC_Fz_RR",
        ],
      ),
      const BooleanPanel(subscribedSignals: [
        "VDC_Powerlimiter_Hardcore_On",
        "VDC_Powerlimiter_Throttle_On",
        "VDC_Powerlimiter_Torque_On",
        "VDC_Powerlimiter_Efficiency_On",
        "VDC_Slip_Control_ON",
        "VDC_Traction_Control_On",
        "VDC_Safety_Mode",
      ], colsize: 14, title: "VDC Status"),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          StringIndicator(
              subscribedSignal: "VDC_MCU_State", decoder: vdcStateDecoder),
          StringIndicator(
              subscribedSignal: "VDC_EPOS_State", decoder: vdcStateDecoder),
        ],
      ),
      const NumericPanel(subscribedSignals: [
        "VDC_Optimal_Slip",
        "VDC_Slip_Control_P",
        "VDC_Slip_Control_I",
        "VDC_Slip_Control_D",
        "VDC_M_Yaw",
        "VDC_M_Yaw_Limit",
        "VDC_Yaw_Control_Weight_Selector",
        "EPOS_Statusword",
        "EPOS_Position_actual_value",
        "EPOS_Torque_actual_value"
      ], colsize: 10, title: "Slip and EPOS"),
      const NumericPanel(subscribedSignals: [
        "VDC_Lateral_Balance",
        "VDC_Throttle_Breakpoint",
        "VDC_Static_Weight_Distribution",
        "VDC_Brake_Force_Max",
        "VDC_Braking_Torque_Multiplier",
        "VDC_Driving_Torque_Multiplier",
        "VDC_Yaw_Control_P",
        "VDC_Yaw_Control_Balance",
        "VDC_RPM_Max",
        "VDC_Power_Max",
        "VDC_Max_Motor_Torque",
        "VDC_Powlim_Approx",
        "VDC_Launch_Control_Mu",
        "VDC_Drop_Parameter_New",
        "VDC_Drop_Parameter",
        "VDC_Efficiency_Tune",
        "VDC_TC_Threshold",
        "TCU_CPU_Usage_Max",
        "VDC_Target_SoC",
        "VDC_Laps",
        "v_x"
      ], colsize: 22, title: "TCU Logic"),
    ],
  ),
  const Titlebar(
    title: "Charts",
  ),
  const WaveformChart(
    subscribedSignals: [
      "VIRT_AMK1_LIMIT",
      "VIRT_AMK2_LIMIT",
      "VIRT_AMK3_LIMIT",
      "VIRT_AMK4_LIMIT"
    ],
    multiplier: [1, 1, 1, 1],
    title: "Torque Limits",
    min: 0,
    max: 25000,
  ),
  const WaveformChart(
    subscribedSignals: ["VDC_Torque_Demand"],
    multiplier: [1],
    title: "Torque demand",
    min: 0,
    max: 300,
  ),
  const WaveformChart(
    subscribedSignals: ["Xavier_Target_Wheel_Angle"],
    multiplier: [180 / pi],
    title: "Target steer °",
    min: -90,
    max: 90,
  ),
], minWidth: 300);
