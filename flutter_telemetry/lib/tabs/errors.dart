import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout errorsBigLayout = TabLayout(
  shortcutLabels: [],
  layoutBreakpoints: [],
  layout: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        BooleanPanel(
          subscribedSignals: [
            "APPS_plausiblity",
            "Validity_Error_APPS1",
            "Validity_Error_APPS2",
            "STA_plausiblity",
            "Validity_Error_STA1",
            "Validity_Error_STA2",
            "Validity_Error_BFS",
            "Validity_Error_BPS_front",
            "Validity_Error_BPS_rear",
            "Validity_Error_AccX_Front",
            "Validity_Error_AccX_Rear",
            "Validity_Error_AccY_Front",
            "Validity_Error_AccY_Rear",
            "Validity_Error_Yaw_Rate_Front",
            "Validity_Error_Yaw_Rate_Rear",
            "Validity_Error_DV_Target_Speed",
            "Validity_Error_DV_Target_Angle",
          ],
          colsize: 9, title: "Sensor Validity"
        ),
        BooleanPanel(
          subscribedSignals: [
            "Timeout_Error_BFS",
            "Timeout_Error_BPS_Front",
            "Timeout_Error_BFS_Rear",
            "Timeout_Error_APPS1",
            "Timeout_Error_APPS2",
            "Timeout_Error_AccX_Front",
            "Timeout_Error_AccX_Rear",
            "Timeout_Error_AccY_Front",
            "Timeout_Error_AccY_Rear",
          ],
          colsize: 9, title: "Sensor Timeouts"
        ),
        BooleanPanel(
          subscribedSignals: [
            "Validity_Error_Button1",
            "Validity_Error_Button2",
            "Validity_Error_Rotary1",
            "Validity_Error_Rotary2",
            "Validity_Error_Rotary3",
            "Validity_Error_Rotary4",
            "Validity_Error_Rotary5",
            "Validity_Error_Button2",
            "Validity_Error_Button4",
            "Timeout_Error_Rotary1",
            "Timeout_Error_Rotary2",
            "Timeout_Error_Rotary3",
            "Timeout_Error_Rotary4",
            "Timeout_Error_Rotary5",
          ],
          colsize: 7, title: "Steering"
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        BooleanPanel(
          subscribedSignals: [
            "BDCDCBB1OtpError",
            "BDCDCBB2OtpError",
            "BDCDCBB3OtpError",
            "BDCDCHVError",
            "BDCDCHVOcpError",
            "BDCDCCANError",
            "BDCDCFlashSubzoneError",
            "BDCDCLVUvpAlimAuxError",
            "BDCDCLVUvpInError",
            "BDCDCLVOvpInError",
            "BDCDCOutput1OvpError",
            "BDCDCOutput2OvpError",
            "BDCDCSR1OtpError",
            "BDCDCSR2OtpError",
          ],
          colsize: 7, title: "Brightloop"
        ),
        BooleanPanel(
          subscribedSignals: [
            "Error_STAMP_TSAL",
            "PC_Error",
            "AMS_Status",
            "IMD_Status",
            "Validity_Error_HV_Current",
            "Validity_Error_HV_Voltage",
            "Timeout_Error_HV_Current",
            "HV_ECU_SC_Endline_State",
            "HV_Cell_OV",
            "HV_Cell_UV",
            "HV_Cell_OT",
            "Validity_Error_HV_Cell_Voltage",
            "Validity_Error_HV_Cell_Temp",
            "Timeout_Error_HV_Cell_Temp",
          ],
          colsize: 7, title: "HV Errors"
        ),
        BooleanPanel(
          subscribedSignals: [
            "Validity_Error_SC_Endline",
            "Timeout_Error_SC_Endline",
            "Timeout_Error_SSG_Status1",
            "Timeout_Error_Xavier",
          ],
          colsize: 4, title: "System"
        ),
        NumericPanel(
          subscribedSignals: [
            "AMK1_error_info",
            "AMK2_error_info",
            "AMK3_error_info",
            "AMK4_error_info",
          ],
          colsize: 4, title: "AMK Errors"
        ),
      ],
    )
  ],
  minWidth: 1220
);

TabLayout errorsSmallLayout = TabLayout(
  shortcutLabels: [],
  layoutBreakpoints: [],
  layout: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        BooleanPanel(
          subscribedSignals: [
            "APPS_plausiblity",
            "Validity_Error_APPS1",
            "Validity_Error_APPS2",
            "STA_plausiblity",
            "Validity_Error_STA1",
            "Validity_Error_STA2",
            "Validity_Error_BFS",
            "Validity_Error_BPS_front",
            "Validity_Error_BPS_rear",
            "Validity_Error_AccX_Front",
            "Validity_Error_AccX_Rear",
            "Validity_Error_AccY_Front",
            "Validity_Error_AccY_Rear",
            "Validity_Error_Yaw_Rate_Front",
            "Validity_Error_Yaw_Rate_Rear",
            "Validity_Error_DV_Target_Speed",
            "Validity_Error_DV_Target_Angle",
          ],
          colsize: 9, title: "Sensor Validity"
        ),
        BooleanPanel(
          subscribedSignals: [
            "Validity_Error_Button1",
            "Validity_Error_Button2",
            "Validity_Error_Rotary1",
            "Validity_Error_Rotary2",
            "Validity_Error_Rotary3",
            "Validity_Error_Rotary4",
            "Validity_Error_Rotary5",
            "Validity_Error_Button2",
            "Validity_Error_Button4",
            "Timeout_Error_Rotary1",
            "Timeout_Error_Rotary2",
            "Timeout_Error_Rotary3",
            "Timeout_Error_Rotary4",
            "Timeout_Error_Rotary5",
          ],
          colsize: 7, title: "Steering"
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        BooleanPanel(
          subscribedSignals: [
            "BDCDCBB1OtpError",
            "BDCDCBB2OtpError",
            "BDCDCBB3OtpError",
            "BDCDCHVError",
            "BDCDCHVOcpError",
            "BDCDCCANError",
            "BDCDCFlashSubzoneError",
            "BDCDCLVUvpAlimAuxError",
            "BDCDCLVUvpInError",
            "BDCDCLVOvpInError",
            "BDCDCOutput1OvpError",
            "BDCDCOutput2OvpError",
            "BDCDCSR1OtpError",
            "BDCDCSR2OtpError",
          ],
          colsize: 7, title: "Brightloop"
        ),
        BooleanPanel(
          subscribedSignals: [
            "Error_STAMP_TSAL",
            "PC_Error",
            "AMS_Status",
            "IMD_Status",
            "Validity_Error_HV_Current",
            "Validity_Error_HV_Voltage",
            "Timeout_Error_HV_Current",
            "HV_ECU_SC_Endline_State",
            "HV_Cell_OV",
            "HV_Cell_UV",
            "HV_Cell_OT",
            "Validity_Error_HV_Cell_Voltage",
            "Validity_Error_HV_Cell_Temp",
            "Timeout_Error_HV_Cell_Temp",
          ],
          colsize: 7, title: "HV Errors"
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        BooleanPanel(
          subscribedSignals: [
            "Timeout_Error_BFS",
            "Timeout_Error_BPS_Front",
            "Timeout_Error_BFS_Rear",
            "Timeout_Error_APPS1",
            "Timeout_Error_APPS2",
            "Timeout_Error_AccX_Front",
            "Timeout_Error_AccX_Rear",
            "Timeout_Error_AccY_Front",
            "Timeout_Error_AccY_Rear",
          ],
          colsize: 9, title: "Sensor Timeouts"
        ),
        BooleanPanel(
          subscribedSignals: [
            "Validity_Error_SC_Endline",
            "Timeout_Error_SC_Endline",
            "Timeout_Error_SSG_Status1",
            "Timeout_Error_Xavier",
          ],
          colsize: 4, title: "System"
        ),
        NumericPanel(
          subscribedSignals: [
            "AMK1_error_info",
            "AMK2_error_info",
            "AMK3_error_info",
            "AMK4_error_info",
          ],
          colsize: 4, title: "AMK Errors"
        ),
      ],
    ),
  ],
  minWidth: 760
);