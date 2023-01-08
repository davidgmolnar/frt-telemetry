import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 9, 67, 121);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const refreshTimeMS = 100;
const highrefreshTimeMS = 10;
const signalValuesToKeep = 128;  // ez kb az utsó 20 mp
const chartSignalValuesToKeep = 128;  // ez kb az utsó 20 mp
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
  "VDC_Yaw_Control_Balance": "VDC Yaw Control B"
};