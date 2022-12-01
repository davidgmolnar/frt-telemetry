import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 9, 67, 121);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const refreshTimeMS = 100;
const highrefreshTimeMS = 10;
const signalValuesToKeep = 128;  // ez kb az utsó 20 mp
const chartSignalValuesToKeep = 128;  // ez kb az utsó 20 mp
const numericFontSize = 14.0;
const screenFlex = 17;
const widthPerColumnNumeric = 400;
const widthPerColumnBoolean = 300;
const defaultPadding = 5.0;

List<double> _double_list = [0.0];

Map<String, List<dynamic>> signalMap = {
  "Bosch_yaw_rate": [],
  "Vectornav_yaw_rate_rear_value": [],
  "Xavier_orientation": [],
};

Map<String, List<DateTime>> signalsToChart = {
  "Bosch_yaw_rate": [],
  "Vectornav_yaw_rate_rear_value": [],
  "Xavier_orientation": [],
};