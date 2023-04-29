import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout scBigLayout =
    TabLayout(shortcutLabels: const [], layoutBreakpoints: const [], layout: [
  /*Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        NumericIndicator(subscribedSignal: "SC_ENDLINE"),
        NumericIndicator(subscribedSignal: "sc_latch_place_of_error"),
        BooleanIndicator(subscribedSignal: "sc_latch"),
      ],
    ),
    Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: secondaryColor, width: 1))),
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
    )*/
  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: const [
      NumericPanel(
          subscribedSignals: ["SC_ENDLINE", "sc_latch_place_of_error"],
          colsize: 2,
          title: "SC"),
      BooleanIndicator(subscribedSignal: "sc_latch"),
      BooleanIndicator(subscribedSignal: "SC_BSPD_FB"),
      BooleanIndicator(subscribedSignal: "SC_DV_FB"),
      BooleanIndicator(subscribedSignal: "SC_DV_RELAY_FB"),
      BooleanIndicator(subscribedSignal: "SC_EBS_FB"),
      BooleanIndicator(subscribedSignal: "SC_FRONT_FB"),
      BooleanIndicator(subscribedSignal: "SC_HOOP_FB"),
      BooleanIndicator(subscribedSignal: "SC_MCU_FB"),
    ],
  )
], minWidth: 1220);

TabLayout scSmallLayout =
    TabLayout(shortcutLabels: const [], layoutBreakpoints: const [], layout: [
  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: const [
      NumericPanel(
          subscribedSignals: ["SC_ENDLINE", "sc_latch_place_of_error"],
          colsize: 2,
          title: "SC"),
      BooleanIndicator(subscribedSignal: "sc_latch"),
      BooleanIndicator(subscribedSignal: "SC_BSPD_FB"),
      BooleanIndicator(subscribedSignal: "SC_DV_FB"),
      BooleanIndicator(subscribedSignal: "SC_DV_RELAY_FB"),
      BooleanIndicator(subscribedSignal: "SC_EBS_FB"),
      BooleanIndicator(subscribedSignal: "SC_FRONT_FB"),
      BooleanIndicator(subscribedSignal: "SC_HOOP_FB"),
      BooleanIndicator(subscribedSignal: "SC_MCU_FB"),
    ],
  )
], minWidth: widthPerColumnNumeric);
