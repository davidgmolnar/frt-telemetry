import 'package:flutter/material.dart';

extension ListSorted<T> on List<T> {
  List<T> sorted(int Function(T a, T b) compare) => [...this]..sort(compare); 
}

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

const double deg2rad = 0.017453;

const Color primaryColorDark = Color.fromARGB(255, 22, 108, 189);
const Color secondaryColorDark = Color(0xFF2A2D3E);
const Color bgColorDark = Color(0xFF212332);
const Color textColorDark = Color.fromARGB(255, 255, 255, 255);

const Color primaryColorBright = Color.fromARGB(255, 12, 63, 110);
const Color secondaryColorBright = Color.fromARGB(255, 137, 149, 221);
const Color bgColorBright = Color.fromARGB(255, 255, 255, 255);
const Color textColorBright = Color.fromARGB(255, 0, 0, 0);

const double numericFontSize = 14.0;
const double subTitleFontSize = 20.0;
const double titleFontSize = 30.0;
const double defaultPadding = 8.0;
const double chartLabelFontSize = 12.0;
const double hvVoltageWidth = 70.0;
const double hvTempWidth = 50.0;

const int widthPerColumnNumeric = 300;
const int widthPerColumnBoolean = 300;
const int settingsWidth = 400;
const int hvVoltageMaxDisp = 6000;

const double iconSplashRadius = 20.0;

const double dialogTitleBarHeight = 50.0;

const Map<String, List<int>> hvCellIDRemap = { // left to right
  "Temp1": [78,84,84,90,91,97,97,103,104,110,110,106,117,123,123,129,130,136,136,142,143,149,149,155],
  "Volt1": [89,84,83,78,102,97,96,91,115,110,109,104,128,123,122,117,141,136,135,130,154,149,148,143],
  "Temp2": [79,83,85,89,92,96,98,102,105,109,111,115,118,122,124,128,131,135,137,141,144,148,150,154],
  "Volt2": [88,85,82,79,101,98,95,92,114,111,108,105,127,124,121,118,140,137,134,131,153,150,147,145],
  "Temp3": [80,82,86,88,93,95,99,101,106,108,112,114,119,121,125,127,132,134,138,140,145,147,151,153],
  "Volt3": [87,86,81,80,100,99,94,93,113,112,107,106,126,125,120,119,139,138,133,132,152,151,146,145],
  "Temp4": [81,81,87,87,94,94,100,100,107,107,113,113,120,120,126,126,133,133,139,139,146,146,152,152],
  "Temp5": [74,74,68,68,61,61,55,55,48,48,42,42,35,35,29,29,22,22,16,16,9,9,3,3],
  "Volt4": [67,68,73,74,54,55,60,61,41,42,47,48,28,29,34,35,15,16,21,22,2,3,8,9],
  "Temp6": [75,73,69,67,62,60,56,54,49,47,43,41,36,34,30,28,23,21,17,15,10,8,4,2],
  "Volt5": [66,69,72,75,53,56,59,62,40,43,46,49,27,30,33,36,14,17,20,23,1,4,7,10],
  "Temp7": [76,72,70,66,63,59,57,53,50,46,44,40,37,33,31,27,24,20,18,14,11,7,5,1],
  "Volt6": [65,70,71,76,52,57,58,63,39,44,45,50,26,31,32,37,13,18,19,24,0,5,6,11],
  "Temp8": [77,71,71,65,64,58,58,52,51,45,45,39,38,32,32,26,25,19,19,13,12,6,6,0],
};

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
  "VIRT_BRIGHTLOOP_LV_MAH": "LV mAh out",
  "IDCDCOutput1UnBalance": "IO Current Unbalance",
  "VDCDCOutput1Average": "Channel 1 Voltage",
  "VDCDCOutput2Average": "Channel 2 Voltage",
  "IDCDCOutput1Average": "Channel 1 Current",
  "IDCDCOutput2Average": "Channel 2 Current",
  "Validity_Error_SC_Endline": "SC Endline Validity",
  "Timeout_Error_SC_Endline": "SC Endline Validity",
  "Timeout_Error_SSG_Status1": "SSG Timeout",
  "Timeout_Error_Xavier": "Xavier Timeout",
  "HV_ECU_SC_Endline_State": "HV ECU SC Endline",
  "Validity_Error_HV_Cell_Voltage": "HV Cell Voltage Validity",
  "Validity_Error_HV_Cell_Temp": "HV Cell Temp Validity",
  "Timeout_Error_HV_Cell_Temp": "HV Cell Temp Timeout",
  "Validity_Error_HV_Current": "HV Current Validity",
  "Validity_Error_HV_Voltage": "HV Voltage Validity",
  "Timeout_Error_HV_Current": "HV Current Timeout",
  "Xavier_CPU1_usage": "CPU1",
  "Xavier_CPU2_usage": "CPU2",
  "Xavier_CPU3_usage": "CPU3",
  "Xavier_CPU4_usage": "CPU4",
  "Xavier_CPU5_usage": "CPU5",
  "Xavier_CPU6_usage": "CPU6",
  "Xavier_CPU7_usage": "CPU7",
  "Xavier_CPU8_usage": "CPU8",
  "Xavier_RAM_usage": "RAM",
  "Xavier_headingErrorSS" : "HeadingSS Error",
  "Xavier_yawRateError": "Yaw rate Error",
  "Xavier_headingError": "Heading Error",
  "Xavier_steeringAngleError": "Steering Error",
  "Xavier_crossTrackError": "Crosstrack Error",
  "Xavier_MAX_temperature" : "Xavier Temp",
  "Xavier_n_updates_last_resample": "Updates last resample",
  "VDC_Drop_Parameter_New": "Drop New",
  "VDC_Static_Weight_Distribution": "Weight Distribution",
  "VDC_Yaw_Control_Weight_Selector": "Yaw Control Weight",
  "EPOS_Position_actual_value": "EPOS Position",
  "EPOS_Torque_actual_value": "EPOS Position",
  "VIRT_ACC_FRONT_YAW_RAD": "Yaw Front",
  "VIRT_AVG_APPS": "APPS", 
  "VIRT_AVG_STA": "STA",
  "VIRT_HV_POWER_OUT": "HV Power out",
  "VIRT_AMK1_LIMIT": "FL Torque Limit",
  "VIRT_AMK2_LIMIT": "FR Torque Limit",
  "VIRT_AMK3_LIMIT": "RL Torque Limit",
  "VIRT_AMK4_LIMIT": "RR Torque Limit",
  "VIRT_BRIGHTLOOP_OLC": "Overload count",
  "VIRT_APPS_VALID": "APPS valid",
  "VIRT_STA_VALID": "STA valid",
  "rssi" : "RSSI",
  "error": "Raspberry error",
  "last_singal_update_cnt": "Signals received",
  "VIRT_XAVIER_TARGET_ANGLE_DEG": "Xavier Target Steer"
};