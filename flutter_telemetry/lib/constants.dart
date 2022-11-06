import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 9, 67, 121);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const refreshTimeMS = 50;
const signalValuesToKeep = 1024;  // ez kb az utsó 20 mp
const numericFontSize = 14.0;
const screenFlex = 17;

List<double> _double_list = [0.0];

Map<String, List<dynamic>> signalMap = {
  "Bosch_yaw_rate": [0.0],
  "Vectornav_yaw_rate_rear_value": [0.0],
  "Xavier_orientation": [0.0],
};