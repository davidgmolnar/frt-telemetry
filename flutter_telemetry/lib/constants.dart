import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

const int udpPort = 8990;

const primaryColorDark = Color.fromARGB(255, 16, 96, 170);
const secondaryColorDark = Color(0xFF2A2D3E);
const bgColorDark = Color(0xFF212332);
const textColorDark = Color.fromARGB(255, 255, 255, 255);

const primaryColorBright = Color.fromARGB(255, 20, 89, 153);
const secondaryColorBright = Color.fromARGB(255, 169, 182, 255);
const bgColorBright = Color.fromARGB(255, 255, 255, 255);
const textColorBright = Color.fromARGB(255, 0, 0, 0);

const numericFontSize = 14.0;
const defaultPadding = 8.0;

const widthPerColumnNumeric = 300;
const widthPerColumnBoolean = 300;
const settingsWidth = 400;

// Name remaps
const Map<String,String> labelRemap = {  // _ by default space lesz
  "Brake_force_validity": "BFS validity",
  "Brake_pressure_front_validity": "BPS front validity",
  "Brake_pressure_rear_validity": "BPS rear validity",
  "APPS1_position": 'APPS1',
  "APPS2_posiition": 'APPS2',
  "STA1_position": 'STA1',
  "STA2_position": 'STA2',
  "Brake_pressure_rear_ADC": 'BPS R',
  "Brake_pressure_front_ADC": 'BPS F',
  "Brake_Force_sensor": 'BFS',
  "Vectornav_yaw_rate_rear_value": 'Vectornav yaw rear',
  "v_x": "Dynamics Vx",
  "v_y": "Dynamics Vy",
  "VDC_v_x": "VDC Vx",
  "VDC_Braking_Torque_Multiplier": "VDC Braking Torque M",
  "VDC_Driving_Torque_Multiplier": "VDC Driving Torque M",
  "VDC_Yaw_Control_Balance": "VDC Yaw Control B",
  "AMK1_Torque_Limit_Positive": "FL Torque Limit +",
  "AMK2_Torque_Limit_Positive": "FR Torque Limit +",
  "AMK3_TorqueLimitPositive": "RL Torque Limit +",
  "AMK4_TorqueLimitPositive": "RR Torque Limit +",
  "AMK1_Torque_Limit_Negative": "FL Torque Limit -",
  "AMK2_Torque_Limit_Negative": "FR Torque Limit -",
  "AMK3_TorqueLimitNegative": "RL Torque Limit -",
  "AMK4_TorqueLimitNegative": "RR Torque Limit -",
  "AMK1_Target_Velocity": "FL Target Velocty",
  "AMK2_Target_Velocity": "FR Target Velocty",
  "AMK3_Target_Velocity": "RL Target Velocty",
  "AMK4_Target_Velocity": "RR Target Velocty",
  "VDC_Fz_FL": "FL Fz",
  "VDC_Fz_FR": "FR Fz",
  "VDC_Fz_RL": "RL Fz",
  "VDC_Fz_RR": "RR Fz",
};