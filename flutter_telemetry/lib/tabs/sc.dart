import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

List<Widget> scSmall = [

];
List<Widget> scBig = [
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      NumericIndicator(subscribedSignal: "SC_ENDLINE"),
      NumericIndicator(subscribedSignal: "sc_latch_place_of_error"),
      BooleanIndicator(subscribedSignal: "sc_latch"),
    ],
  ),
  Container(
    decoration: BoxDecoration(border: Border.all(color: secondaryColor, width: 1)),
    width: 1200,
    height: 700,
    child: Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Transform.translate(
          transformHitTests: false,
          offset: const Offset(300, 250),
          child: const BooleanIndicator(subscribedSignal: "SC_BSDP_FB"),
        ),
        Transform.translate(
          offset: const Offset(300, 350),
          child: const BooleanIndicator(subscribedSignal: "SC_MCU_FB"),
        ),
        Transform.translate(
          offset: const Offset(0, 350),
          child: const BooleanIndicator(subscribedSignal: "SC_HOOP_FB"),
        ),
        Transform.translate(
          offset: const Offset(-400, 350),
          child: const BooleanIndicator(subscribedSignal: "SC_FRONT_FB"),
        ),
        Transform.translate(
          offset: const Offset(-400, 250),
          child: const BooleanIndicator(subscribedSignal: "SC_DV_FB"),
        ),
        Transform.translate(
          offset: const Offset(-0, 450),
          child: const Text("idk lesz még"),
        ),
      ],
    ),
  )
];