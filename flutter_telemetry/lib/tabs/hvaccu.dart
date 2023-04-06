import 'package:flutter/material.dart';
import 'package:flutter_telemetry/dialogs/accu_snapshot_dialog.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout hvAccuBigLayout = TabLayout(
  shortcutLabels: const [],
  layoutBreakpoints: const [],
  layout: [
    const SizedBox(height: 5,),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const HVAccu(),
        Column(
          children: [
            const BooleanPanel(
              subscribedSignals: [
                "AIR_minus_state",
                "AIR_plus_state",
                "AMS_Relay_State",
                "AMS_Status",
                "Error_STAMP_TSAL",
                "HV_Cell_OT",
                "HV_Cell_OV",
                "HV_Cell_UV",
                "HV_DetStatus",
                "IMD_Relay_State",
                "IMD_Status",
                "PC_Error",
                "TSAL_GREEN",
                "TS_Over_Voltage",
                "TS_Overcurrent",
                "HV_DetStatus2"
              ],
              colsize: 16,
              title: "HV Status"
            ),
            TextButton(
              /*onPressed: () => showDialog<Widget>(
                barrierDismissible: false,
                context: tabContext,
                builder: (BuildContext context) => const AccuSnapshotDialog()
              ),*/
              onPressed: () async {
                handleAccuSnapshotSave();
              },
              child: const Text("Accu Snapshot")
            )
          ],
        ),
        Column(
          children: const [
            NumericPanel(
              subscribedSignals: [
                "HV_Current",
                "HV_Voltage_After_AIRs",
                "HV_Voltage_Before_AIRs",
                "State_of_Charge",
                "HV_Cell_Temp_MAX",
                "HV_Cell_Voltage_MIN",
              ],
              colsize: 6,
              title: "HV Meas"
            ),
            HVColorMap()
          ],
        )
      ],
    )
  ],
  minWidth: 1290
);

TabLayout hvAccuSmallLayout = TabLayout(
  shortcutLabels: const ["HV Accu", "HV Status"],
  layoutBreakpoints: const [0, 770],
  layout: [
    const Titlebar(title: "HV Accu"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        HVAccu(),
      ],
    ),
    const Titlebar(title: "HV Status"),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: const [
            BooleanPanel(
              subscribedSignals: [
                "AIR_minus_state",
                "AIR_plus_state",
                "AMS_Relay_State",
                "AMS_Status",
                "Error_STAMP_TSAL",
                "HV_Cell_OT",
                "HV_Cell_OV",
                "HV_Cell_UV",
                "HV_DetStatus",
                "IMD_Relay_State",
                "IMD_Status",
                "PC_Error",
                "TSAL_GREEN",
                "TS_Over_Voltage",
                "TS_Overcurrent",
                "HV_DetStatus2"
              ],
              colsize: 16,
              title: "HV Status"
            ),
          ],
        ),
        Column(
          children: const [
            NumericPanel(
              subscribedSignals: [
                "HV_Current",
                "HV_Voltage_After_AIRs",
                "HV_Voltage_Before_AIRs",
                "State_of_Charge",
                "HV_Cell_Temp_MAX",
                "HV_Cell_Voltage_MIN",
              ],
              colsize: 6,
              title: "HV Meas"
            ),
            HVColorMap()
          ],
        )
      ],
    )
  ],
  minWidth: 840
);