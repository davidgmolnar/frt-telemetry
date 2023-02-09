import 'package:flutter/material.dart';
import "package:flutter_telemetry/indicators/indicators.dart";

List<Widget> mcuSmall = [

];

List<Widget> mucBig = [
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: const [
          NumericPanel(
            colsize: 6,
            title: "FL Status",
            subscribedSignals: [
              "AMK1_torque_current",
              "AMK1_magnetizing_current",
              "AMK1_error_info",
              "AMK1_temp_IGBT",
              "AMK1_temp_inverter",
              "AMK1_temp_motor",
            ],
          ),
          BooleanIndicator(subscribedSignal: "AMK1_DC_On"),
          BooleanIndicator(subscribedSignal: "AMK1_Enable"),
          BooleanIndicator(subscribedSignal: "AMK1_Error_Reset"),
          BooleanIndicator(subscribedSignal: "AMK1_Inverter_On"),
          AMKStatusIndicator(subscribedSignal: "AMK1_Status")
        ],
      )
    ],
  )
];