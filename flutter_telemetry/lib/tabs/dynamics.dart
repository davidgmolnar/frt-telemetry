import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout dynamicsBigLayout =
    TabLayout(shortcutLabels: const [], layoutBreakpoints: const [], layout: [
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      NumericPanel(subscribedSignals: [
        "AccX_Bosch",
        "AccY_Bosch",
        "YawRate_Bosch",
        "RollRate_Bosch"
      ], colsize: 4, title: "Bosch"),
      NumericPanel(subscribedSignals: [
        "AccX_Vectornav",
        "AccY_Vectornav",
        "AccZ_Vectornav",
        "AngularRate_X",
        "AngularRate_Y",
        "Yaw_Rate_Vectornav",
        "v_x_FM",
        "v_y_FM",
        "INS_v_x",
        "INS_v_y"
      ], colsize: 5, title: "Vectornav"),
      NumericPanel(subscribedSignals: [
        "PN_IMU_Acc_X",
        "PN_IMU_Acc_Y",
        "PN_IMU_Acc_Z",
        "PN_IMU_Yaw",
        "PN_IMU_Pitch",
        "PN_IMU_Roll",
      ], colsize: 6, title: "Pedal Node"),
    ],
  ),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Flexible(
        child: TimeSeriesChart(
          subscribedSignals: ["AccX_Bosch", "AccX_Vectornav"],
          title: "Accel X",
          min: -4,
          max: 4,
        ),
      ),
      Flexible(
        child: TimeSeriesChart(
          subscribedSignals: ["AccY_Bosch", "AccY_Vectornav"],
          title: "Accel Y",
          min: -4,
          max: 4
        )
      ),
      NumericPanel(
        subscribedSignals: [
          "v_x",
          "v_y"
        ],
        colsize: 6,
        title: "Dynamics"
      )
    ],
  ),
  Row(children: const [
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["v_x", "v_x_FM"],
        title: "V X [m/s]",
        min: 0,
        max: 50,
      ),
    ),
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["v_y", "v_y_FM"],
        title: "V Y [m/s]",
        min: 0,
        max: 50,
      ),
    )
  ]),
  Row(children: const [
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["Brake_Force_sensor"],
        title: "BFS [N]",
        min: 0,
        max: 1500,
      ),
    ),
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["Brake_pressure_front", "Brake_pressure_rear"],
        title: "BPS bar",
        min: 0,
        max: 100,
      ),
    )
  ]),
  Row(children: const [
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["HV_Current"],
        title: "HV Current [A]",
        min: -150,
        max: 200,
      ),
    ),
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["VIRT_HV_POWER_OUT"],
        title: "HV Power [W]",
        min: -80000,
        max: 90000,
      ),
    )
  ]),
  Row(children: const [
    Flexible(
      child: TimeSeriesChart(
        subscribedSignals: ["YawRate_Bosch", "Yaw_Rate_Vectornav"],
        title: "Yaw Rate [rad/s]",
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
], minWidth: 1200);

TabLayout dynamicsSmallLayout =
    TabLayout(shortcutLabels: const [], layoutBreakpoints: const [], layout: [
  const NumericPanel(subscribedSignals: [
    "AccX_Vectornav",
    "AccY_Vectornav",
    "AccZ_Vectornav",
    "AngularRate_X",
    "AngularRate_Y",
    "Yaw_Rate_Vectornav",
    "v_x_FM",
    "v_y_FM",
    "INS_v_x",
    "INS_v_y"
  ], colsize: 5, title: "Vectornav"),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      NumericPanel(subscribedSignals: [
        "AccX_Bosch",
        "AccY_Bosch",
        "YawRate_Bosch",
        "RollRate_Bosch"
      ], colsize: 4, title: "Bosch"),
      NumericPanel(subscribedSignals: [
        "PN_IMU_Acc_X",
        "PN_IMU_Acc_Y",
        "PN_IMU_Acc_Z",
        "PN_IMU_Yaw",
        "PN_IMU_Pitch",
        "PN_IMU_Roll",
      ], colsize: 6, title: "Pedal Node"),
    ],
  ),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Flexible(
        child: TimeSeriesChart(
          subscribedSignals: ["Brake_Force_sensor"],
          title: "BFS [N]",
          min: 0,
          max: 1500,
        ),
      ),
      NumericPanel(
        subscribedSignals: [
          "v_x",
          "v_y"
        ],
        colsize: 6,
        title: "Dynamics"
      )
    ],
  ),
  const TimeSeriesChart(
    subscribedSignals: ["v_x", "v_x_FM"],
    title: "V X  [m/s]",
    min: 0,
    max: 50,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["v_y", "v_y_FM"],
    title: "V Y [m/s]",
    min: 0,
    max: 50,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["Brake_pressure_front", "Brake_pressure_rear"],
    title: "BPS [bar]",
    min: 0,
    max: 100,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["AccX_Bosch", "AccX_Vectornav"],
    title: "Accel X",
    min: -4,
    max: 4,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["AccY_Bosch", "AccY_Vectornav"],
    title: "Accel Y",
    min: -4,
    max: 4
  ),
  const TimeSeriesChart(
    subscribedSignals: ["HV_Current"],
    title: "HV Current [A]",
    min: -150,
    max: 200,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["VIRT_HV_POWER_OUT"],
    title: "HV Power [W]",
    min: -80000,
    max: 90000,
  ),
  const TimeSeriesChart(
    subscribedSignals: ["YawRate_Bosch", "Yaw_Rate_Vectornav"],
    title: "Yaw Rate [rad/s]",
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
    const TabLayout(layoutBreakpoints: [], shortcutLabels: [], layout: [
  Titlebar(title: "Dynamics Measurements"),
  NumericPanel(subscribedSignals: [
    "AccX_Bosch",
    "AccY_Bosch",
    "YawRate_Bosch",
    "RollRate_Bosch"
  ], colsize: 4, title: "Bosch"),
  NumericPanel(subscribedSignals: [
    "AccX_Vectornav",
    "AccY_Vectornav",
    "AccZ_Vectornav",
    "AngularRate_X",
    "AngularRate_Y",
    "Yaw_Rate_Vectornav",
    "v_x_FM",
    "v_y_FM",
    "INS_v_x",
    "INS_v_y"
  ], colsize: 10, title: "Vectornav"),
  NumericPanel(subscribedSignals: [
    "PN_IMU_Acc_X",
    "PN_IMU_Acc_Y",
    "PN_IMU_Acc_Z",
    "PN_IMU_Yaw",
    "PN_IMU_Pitch",
    "PN_IMU_Roll",
  ], colsize: 6, title: "Pedal Node"),
  Titlebar(title: "Charts"),
  TimeSeriesChart(
    subscribedSignals: ["Brake_Force_sensor"],
    title: "BFS [N]",
    min: 0,
    max: 1500,
  ),
  TimeSeriesChart(
    subscribedSignals: ["Brake_pressure_front", "Brake_pressure_rear"],
    title: "BPS [bar]",
    min: 0,
    max: 100,
  ),
  TimeSeriesChart(
    subscribedSignals: ["AccX_Bosch", "AccX_Bosch"],
    title: "Accel",
    min: -4,
    max: 4,
  ),
  TimeSeriesChart(
    subscribedSignals: ["HV_Current"],
    title: "HV Current [A]",
    min: -150,
    max: 200,
  ),
  TimeSeriesChart(
    subscribedSignals: ["VIRT_HV_POWER_OUT"],
    title: "HV Power [W]",
    min: -80000,
    max: 90000,
  ),
  TimeSeriesChart(
    subscribedSignals: ["YawRate_Bosch", "Yaw_Rate_Vectornav"],
    title: "Yaw Rate [rad/s]",
    min: -10,
    max: 10,
  ),
  TimeSeriesChart(
    subscribedSignals: ["VIRT_AVG_APPS", "VIRT_AVG_STA"],
    title: "APPS / STA Avg",
    min: 0,
    max: 180,
  ),
], minWidth: 300);
