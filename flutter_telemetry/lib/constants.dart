import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

const int udpPort = 8990;
const double deg2rad = 0.017453;

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
  "AMK1_torque_current": "FL It",
  "AMK2_torque_current": "FR It",
  "AMK3_torque_current": "RL It",
  "AMK4_torque_current": "RR It",
  "AMK1_magnetizing_current": "FL Im", 
  "AMK2_magnetizing_current": "FR Im", 
  "AMK3_magnetizing_current": "RL Im", 
  "AMK4_magnetizing_current": "RR Im", 
  "AMK1_error_info": "FL Error Info", 
  "AMK2_error_info": "FR Error Info", 
  "AMK3_error_info": "RL Error Info", 
  "AMK4_error_info": "RR Error Info", 
  "AMK1_temp_IGBT": "FL Temp IGBT", 
  "AMK2_temp_IGBT": "FR Temp IGBT", 
  "AMK3_temp_IGBT": "RL Temp IGBT", 
  "AMK4_temp_IGBT": "RR Temp IGBT", 
  "AMK1_temp_inverter": "FL Temp Inverter", 
  "AMK2_temp_inverter": "FR Temp Inverter", 
  "AMK3_temp_inverter": "RL Temp Inverter", 
  "AMK4_temp_inverter": "RR Temp Inverter", 
  "AMK1_temp_motor": "FL Temp Motor", 
  "AMK2_temp_motor": "FR Temp Motor", 
  "AMK3_temp_motor": "RL Temp Motor", 
  "AMK4_temp_motor": "RR Temp Motor", 
  "AMK1_DC_On": "FL DC On", 
  "AMK2_DC_On": "FR DC On", 
  "AMK3_DC_On": "RL DC On", 
  "AMK4_DC_On": "RR DC On", 
  "AMK1_Enable": "FL Enable", 
  "AMK2_Enable": "FR Enable", 
  "AMK3_Enable": "RL Enable", 
  "AMK4_Enable": "RR Enable", 
  "AMK1_Error_Reset": "FL Error Reset", 
  "AMK2_Error_Reset": "FR Error Reset", 
  "AMK3_Error_Reset": "RL Error Reset", 
  "AMK4_Error_Reset": "RR Error Reset", 
  "AMK1_Inverter_On": "FL Inverter On", 
  "AMK2_Inverter_On": "FR Inverter On", 
  "AMK3_Inverter_On": "RL Inverter On", 
  "AMK4_Inverter_On": "RR Inverter On", 
  "AMK1_actual_velocity": "FL RPM", 
  "AMK2_actual_velocity": "FR RPM", 
  "AMK3_actual_velocity": "RL RPM", 
  "AMK4_actual_velocity": "RR RPM", 
  "VIRT_BRIGHTLOOP_CH1_POWER": "Channel 1 Power out",
  "VIRT_BRIGHTLOOP_CH2_POWER": "Channel 2 Power out",
  "VIRT_BRIGHTLOOP_LV_MAH": "LV mAh",
  "IDCDCOutput1UnBalance": "IO Current Unbalance",
  "VDCDCOutput1Average": "Channel 1 Voltage",
  "VDCDCOutput2Average": "Channel 2 Voltage",
  "IDCDCOutput1Average": "Channel 1 Current",
  "IDCDCOutput2Average": "Channel 1 Current",
};