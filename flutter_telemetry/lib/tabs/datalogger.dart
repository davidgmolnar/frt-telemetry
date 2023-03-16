import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

List<Widget> dataloggerSmall = [
  const NumericPanel(
    subscribedSignals: [
      "ASMS_in",
      "Driving_state_active",
      "DV_SDC_relay_fb",
      "SDC_endline",
      "EBS_is_active",
      "EBS2_set_active",
      "EBS2_feedback",
      "EBS1_feedback",
      "SDC_in",
      "nSet_driving_state",
      "nEBS_set_active",
      "nEBS_is_triggered",
      "nBrake_engage",
      "Watchdog",
      "Shutdown_close",
      "SDC_out",
      "SDC_is_ready",
      "to_SDC_relay",
      "to_EBS2_power_amplifier",
      "to_EBS1_power_amplifier",
      "nSet_finish_state"
    ],
    colsize: 7, title: "Nonpogrammable Logic"
  ),
  const NumericPanel(
    subscribedSignals: [
      "Speed_target",
      "Speed_actual",
      "Motor_moment_target",
      "Motor_moment_actual",
      "Brake_hydr_target",
      "Brake_hydr_actual",
      "Steering_angle_target",
      "Steering_angle_actual",
      "Yaw_rate",
      "Acceleration_longitudinal",
      "Acceleration_lateral",
      "Cones_count_all",
      "Cones_count_actual",
      "AS_state",
      "AMI_state",
      "Steering_state",
      "Service_brake_state",
      "Lap_counter",
      "EBS_state"
    ],
    colsize: 7, title: "DV Status"
  ),
  const NumericPanel(
    subscribedSignals: [
      "Current",
      "MsgCnt",
      "Status_Logging",
      "Status_Ready",
      "Status_Triggered_Current",
      "Status_Triggered_Voltage",
      "Voltage",
      "BP4_Hydraulic_Brake_P_Rear",
      "BP2_Hydraulic_Brake_P_Front",
      "BP2_EBS_Pressure_Rear",
      "BP1_EBS_Pressure_Front",
    ],
    colsize: 4, title: "Misc"
  )
];

List<Widget> dataloggerBig = [
  const NumericPanel(
    subscribedSignals: [
      "ASMS_in",
      "Driving_state_active",
      "DV_SDC_relay_fb",
      "SDC_endline",
      "EBS_is_active",
      "EBS2_set_active",
      "EBS2_feedback",
      "EBS1_feedback",
      "SDC_in",
      "nSet_driving_state",
      "nEBS_set_active",
      "nEBS_is_triggered",
      "nBrake_engage",
      "Watchdog",
      "Shutdown_close",
      "SDC_out",
      "SDC_is_ready",
      "to_SDC_relay",
      "to_EBS2_power_amplifier",
      "to_EBS1_power_amplifier",
      "nSet_finish_state"
    ],
    colsize: 6, title: "Nonpogrammable Logic"
  ),
  const NumericPanel(
    subscribedSignals: [
      "Speed_target",
      "Speed_actual",
      "Motor_moment_target",
      "Motor_moment_actual",
      "Brake_hydr_target",
      "Brake_hydr_actual",
      "Steering_angle_target",
      "Steering_angle_actual",
      "Yaw_rate",
      "Acceleration_longitudinal",
      "Acceleration_lateral",
      "Cones_count_all",
      "Cones_count_actual",
      "AS_state",
      "AMI_state",
      "Steering_state",
      "Service_brake_state",
      "Lap_counter",
      "EBS_state"
    ],
    colsize: 5, title: "DV Status"
  ),
  const NumericPanel(
    subscribedSignals: [
      "Current",
      "MsgCnt",
      "Status_Logging",
      "Status_Ready",
      "Status_Triggered_Current",
      "Status_Triggered_Voltage",
      "Voltage",
      "BP4_Hydraulic_Brake_P_Rear",
      "BP2_Hydraulic_Brake_P_Front",
      "BP2_EBS_Pressure_Rear",
      "BP1_EBS_Pressure_Front",
    ],
    colsize: 3, title: "Misc"
  )
];