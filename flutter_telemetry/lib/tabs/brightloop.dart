import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

List<Widget> brightloopSmall = [
  const Titlebar(title: "Brightloop Charts"),
  const WaveformChart(
    subscribedSignals: [
      "VDCDCOutput1Average",
      "VDCDCOutput2Average"
    ],
    title: "Channel Voltages", min: 0, max: 60, multiplier: [1,1]
  ),
  const WaveformChart(
    subscribedSignals: [
      "IDCDCOutput1Average",
      "IDCDCOutput2Average"
    ],
    title: "Channel Currents", min: -100, max: 300, multiplier: [1,1]
  ),
  const WaveformChart(
    subscribedSignals: [
      "VIRT_BRIGHTLOOP_CH1_POWER",
      "VIRT_BRIGHTLOOP_CH2_POWER",
    ],
    title: "Channel Powers", min: -6000, max: 18000, multiplier: [1,1]
  ),
  const Titlebar(title: "Brightloop Status"),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      NumericPanel(
        subscribedSignals: [
          "VDCDCOutput1Max",
          "VDCDCOutput1Min",
          "VDCDCOutput2Max",
          "VDCDCOutput2Min",
          "IDCDCOutput1Max",
          "IDCDCOutput1Min",
          "IDCDCOutput2Max",
          "IDCDCOutput2Min",
        ],
        colsize: 8, title: "Channel minmax"
      ),
      NumericPanel(
        subscribedSignals: [
          "VDCDCLV1Setpoint",
          "VDCDCLV2Setpoint",
          "VDCDCHVSetpoint",
          "IDCDCLV1Limit",
          "IDCDCLV2Limit",
          "IDCDCHVLimit",
        ],
        colsize: 6, title: "Setpoints"
      ),
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const NumericPanel(
        subscribedSignals: [
          "TDCDCBB1Measured",
          "TDCDCBB2Measured",
          "TDCDCBB3Measured",
          "TDCDCSR1Measured",
          "TDCDCSR2Measured",
          "VIRT_BRIGHTLOOP_LV_MAH",
        ],
        colsize: 6, title: "Temps and mAh"
      ),
      Column(
        children: const [
          NumericPanel(
            subscribedSignals: [
              "VDCDCHVInAverage",
              "IDCDCHVInAverage",
              "IDCDCOutput1UnBalance",
              "VIRT_BRIGHTLOOP_OLC",
            ],
            colsize: 4, title: "Misc"
          ),
          BooleanIndicator(subscribedSignal: "BDCDCUmbilicalOn"),
          BooleanIndicator(subscribedSignal: "BDCDCRegenerationOn"),
          BooleanIndicator(subscribedSignal: "BDCDCOutput1Requested"),
          BooleanIndicator(subscribedSignal: "BDCDCOutput2Requested",),
        ],
      ),
    ],
  ),
];

List<Widget> brightloopBig = [
  const Titlebar(title: "Brightloop Charts"),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Flexible(
        child: WaveformChart(
          subscribedSignals: [
            "VDCDCOutput1Average",
            "VDCDCOutput2Average"
          ],
          title: "Channel Voltages", min: 0, max: 60, multiplier: [1,1]
        ),
      ),
      Flexible(
        child: WaveformChart(
          subscribedSignals: [
            "IDCDCOutput1Average",
            "IDCDCOutput2Average"
          ],
          title: "Channel Currents", min: -100, max: 300, multiplier: [1,1]
        ),
      ),
    ],
  ),
  const WaveformChart(
    subscribedSignals: [
      "VIRT_BRIGHTLOOP_CH1_POWER",
      "VIRT_BRIGHTLOOP_CH2_POWER",
    ],
    title: "Channel Powers", min: -6000, max: 18000, multiplier: [1,1]
  ),
  const Titlebar(title: "Brightloop Status"),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const NumericPanel(
        subscribedSignals: [
          "VDCDCOutput1Max",
          "VDCDCOutput1Min",
          "VDCDCOutput2Max",
          "VDCDCOutput2Min",
          "IDCDCOutput1Max",
          "IDCDCOutput1Min",
          "IDCDCOutput2Max",
          "IDCDCOutput2Min",
        ],
        colsize: 8, title: "Channel minmax"
      ),
      const NumericPanel(
        subscribedSignals: [
          "VDCDCLV1Setpoint",
          "VDCDCLV2Setpoint",
          "VDCDCHVSetpoint",
          "IDCDCLV1Limit",
          "IDCDCLV2Limit",
          "IDCDCHVLimit",
        ],
        colsize: 6, title: "Setpoints"
      ),
      const NumericPanel(
        subscribedSignals: [
          "TDCDCBB1Measured",
          "TDCDCBB2Measured",
          "TDCDCBB3Measured",
          "TDCDCSR1Measured",
          "TDCDCSR2Measured",
          "VIRT_BRIGHTLOOP_LV_MAH",
        ],
        colsize: 6, title: "Temps and mAh"
      ),
      Column(
        children: const [
          NumericPanel(
            subscribedSignals: [
              "VDCDCHVInAverage",
              "IDCDCHVInAverage",
              "IDCDCOutput1UnBalance",
              "VIRT_BRIGHTLOOP_OLC",
            ],
            colsize: 4, title: "Misc"
          ),
          BooleanIndicator(subscribedSignal: "BDCDCUmbilicalOn"),
          BooleanIndicator(subscribedSignal: "BDCDCRegenerationOn"),
          BooleanIndicator(subscribedSignal: "BDCDCOutput1Requested"),
          BooleanIndicator(subscribedSignal: "BDCDCOutput2Requested",),
        ],
      ),
    ],
  ),
];