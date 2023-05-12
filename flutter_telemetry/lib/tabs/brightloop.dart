import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout brightloopBigLayout = TabLayout(shortcutLabels: const [
  "Brightloop Charts",
  "Brightloop Status"
], layoutBreakpoints: const [
  0,
  700
], layout: [
  const Titlebar(title: "Brightloop Charts"),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Flexible(
        child: TimeSeriesChart(
            subscribedSignals: ["VDCDCOutput1Average", "VDCDCOutput2Average"],
            title: "Channel Voltages",
            min: 0,
            max: 60,),
      ),
      Flexible(
        child: TimeSeriesChart(
            subscribedSignals: ["IDCDCOutput1Average", "IDCDCOutput2Average"],
            title: "Channel Currents",
            min: -100,
            max: 300,),
      ),
    ],
  ),
  const TimeSeriesChart(
      subscribedSignals: [
        "VIRT_BRIGHTLOOP_CH1_POWER",
        "VIRT_BRIGHTLOOP_CH2_POWER",
      ],
      title: "Channel Powers",
      min: -6000,
      max: 18000,),
  const Titlebar(title: "Brightloop Status"),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const NumericPanel(subscribedSignals: [
        "VDCDCOutput1Max",
        "VDCDCOutput1Min",
        "VDCDCOutput2Max",
        "VDCDCOutput2Min",
        "IDCDCOutput1Max",
        "IDCDCOutput1Min",
        "IDCDCOutput2Max",
        "IDCDCOutput2Min",
      ], colsize: 8, title: "Channel minmax"),
      const NumericPanel(subscribedSignals: [
        "VDCDCLV1Setpoint m1",
        "VDCDCLV2Setpoint m2",
        "VDCDCHVSetpoint m9",
        "IDCDCLV1Limit m1",
        "IDCDCLV2Limit m2",
        "IDCDCHVLimit m9",
      ], colsize: 6, title: "Setpoints"),
      const NumericPanel(subscribedSignals: [
        "TDCDCBB1Measured m3",
        "TDCDCBB2Measured m3",
        "TDCDCBB3Measured m3",
        "TDCDCSR1Measured m2",
        "TDCDCSR2Measured m2",
        "VIRT_BRIGHTLOOP_LV_MAH"
      ], colsize: 6, title: "Temps and mAh"),
      Column(
        children: const [
          NumericPanel(subscribedSignals: [
            "VDCDCHVInAverage m0",
            "IDCDCHVInAverage m8",
            "IDCDCOutput1UnBalance m1",
            "VIRT_BRIGHTLOOP_OLC",
          ], colsize: 4, title: "Misc"),
          BooleanIndicator(subscribedSignal: "BDCDCUmbilicalOn"),
          BooleanIndicator(subscribedSignal: "BDCDCRegenerationOn"),
          BooleanIndicator(subscribedSignal: "BDCDCOutput1Requested"),
          BooleanIndicator(
            subscribedSignal: "BDCDCOutput2Requested",
          ),
        ],
      ),
    ],
  ),
], minWidth: 1220);

TabLayout brightloopSmallLayout = TabLayout(shortcutLabels: const [
  "Brightloop Charts",
  "Brightloop Status"
], layoutBreakpoints: const [
  0,
  1050
], layout: [
  const Titlebar(title: "Brightloop Charts"),
  const TimeSeriesChart(
      subscribedSignals: ["VDCDCOutput1Average", "VDCDCOutput2Average"],
      title: "Channel Voltages",
      min: 0,
      max: 60,),
  const TimeSeriesChart(
      subscribedSignals: ["IDCDCOutput1Average", "IDCDCOutput2Average"],
      title: "Channel Currents",
      min: -100,
      max: 300,),
  const TimeSeriesChart(
      subscribedSignals: [
        "VIRT_BRIGHTLOOP_CH1_POWER",
        "VIRT_BRIGHTLOOP_CH2_POWER",
      ],
      title: "Channel Powers",
      min: -6000,
      max: 18000,),
  const Titlebar(title: "Brightloop Status"),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      NumericPanel(subscribedSignals: [
        "VDCDCOutput1Max",
        "VDCDCOutput1Min",
        "VDCDCOutput2Max",
        "VDCDCOutput2Min",
        "IDCDCOutput1Max",
        "IDCDCOutput1Min",
        "IDCDCOutput2Max",
        "IDCDCOutput2Min",
      ], colsize: 8, title: "Channel minmax"),
      NumericPanel(subscribedSignals: [
        "VDCDCLV1Setpoint m1",
        "VDCDCLV2Setpoint m2",
        "VDCDCHVSetpoint m9",
        "IDCDCLV1Limit m1",
        "IDCDCLV2Limit m2",
        "IDCDCHVLimit m9",
      ], colsize: 6, title: "Setpoints"),
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const NumericPanel(subscribedSignals: [
        "TDCDCBB1Measured m3",
        "TDCDCBB2Measured m3",
        "TDCDCBB3Measured m3",
        "TDCDCSR1Measured m2",
        "TDCDCSR2Measured m2",
        "VIRT_BRIGHTLOOP_LV_MAH",
      ], colsize: 6, title: "Temps and mAh"),
      Column(
        children: const [
          NumericPanel(subscribedSignals: [
            "VDCDCHVInAverage m0",
            "IDCDCHVInAverage m8",
            "IDCDCOutput1UnBalance m1",
            "VIRT_BRIGHTLOOP_OLC",
          ], colsize: 4, title: "Misc"),
          BooleanIndicator(subscribedSignal: "BDCDCUmbilicalOn"),
          BooleanIndicator(subscribedSignal: "BDCDCRegenerationOn"),
          BooleanIndicator(subscribedSignal: "BDCDCOutput1Requested"),
          BooleanIndicator(
            subscribedSignal: "BDCDCOutput2Requested",
          ),
        ],
      ),
    ],
  ),
], minWidth: 600);

TabLayout brightloopMobileLayout = TabLayout(shortcutLabels: [
  "Brightloop Charts",
  "Brightloop Status"
], layoutBreakpoints: [
  0,
  1050
], layout: [
  const Titlebar(title: "Brightloop Charts"),
  const TimeSeriesChart(
      subscribedSignals: ["VDCDCOutput1Average", "VDCDCOutput2Average"],
      title: "Channel Voltages",
      min: 0,
      max: 60,),
  const TimeSeriesChart(
      subscribedSignals: ["IDCDCOutput1Average", "IDCDCOutput2Average"],
      title: "Channel Currents",
      min: -100,
      max: 300,),
  const TimeSeriesChart(
      subscribedSignals: [
        "VIRT_BRIGHTLOOP_CH1_POWER",
        "VIRT_BRIGHTLOOP_CH2_POWER",
      ],
      title: "Channel Powers",
      min: -6000,
      max: 18000,),
  const Titlebar(title: "Brightloop Status"),
  const NumericPanel(subscribedSignals: [
    "VDCDCOutput1Max",
    "VDCDCOutput1Min",
    "VDCDCOutput2Max",
    "VDCDCOutput2Min",
    "IDCDCOutput1Max",
    "IDCDCOutput1Min",
    "IDCDCOutput2Max",
    "IDCDCOutput2Min",
  ], colsize: 8, title: "Channel minmax"),
  const NumericPanel(subscribedSignals: [
    "VDCDCLV1Setpoint m1",
    "VDCDCLV2Setpoint m2",
    "VDCDCHVSetpoint m9",
    "IDCDCLV1Limit m1",
    "IDCDCLV2Limit m2",
    "IDCDCHVLimit m9",
  ], colsize: 6, title: "Setpoints"),
  const NumericPanel(subscribedSignals: [
    "TDCDCBB1Measured m3",
    "TDCDCBB2Measured m3",
    "TDCDCBB3Measured m3",
    "TDCDCSR1Measured m2",
    "TDCDCSR2Measured m2",
    "VIRT_BRIGHTLOOP_LV_MAH",
  ], colsize: 6, title: "Temps and mAh"),
  const NumericPanel(subscribedSignals: [
    "VDCDCHVInAverage m0",
    "IDCDCHVInAverage m8",
    "IDCDCOutput1UnBalance m1",
    "VIRT_BRIGHTLOOP_OLC",
  ], colsize: 4, title: "Misc"),
  Column(
    children: const [
      BooleanIndicator(subscribedSignal: "BDCDCUmbilicalOn"),
      BooleanIndicator(subscribedSignal: "BDCDCRegenerationOn"),
      BooleanIndicator(subscribedSignal: "BDCDCOutput1Requested"),
      BooleanIndicator(subscribedSignal: "BDCDCOutput2Requested")
    ]
  )
], minWidth: 300);
