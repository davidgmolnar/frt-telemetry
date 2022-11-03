import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 19, 123, 221);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const refreshTimeMS = 50;
const signalValuesToKeep = 2048;
const numericFontSize = 15.0;

List<double> _double_list = [0.0];

Map<String, List<dynamic>> signalMap = {
  "Bosch_yaw_rate": _double_list,
  "Vectornav_yaw_rate_rear_value": _double_list,
  "Xavier_orientation": _double_list,
};