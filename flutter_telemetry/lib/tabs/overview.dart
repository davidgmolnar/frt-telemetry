import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/decoders.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/indicators/string_indicator.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout overviewBigLayout = TabLayout(
  shortcutLabels: const ["System and Sensor checks", "Dynamics and Control", "Power and MCUs", "Steering and Lap"],
  layoutBreakpoints: const [0, 450, 1000, 1450],
  layout: [
    const Titlebar(title: "System and Sensor checks"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BooleanPanel(
          subscribedSignals: [
            "APPS1_validity",
            "APPS2_validity",
            "APPS_plausiblity",
            "STA1_validity",
            "STA2_validity",
            "STA_plausiblity",
            "Brake_force_validity",
            "Brake_pressure_front_validity",
            "Brake_pressure_rear_validity",
          ],
          reverseIndexes: [true, true, true, true, true, true, true, true, true],
          colsize: 9,
          title: "Sensor Status"
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [
              ScaleIndicator(subscribedSignal: "APPS1_position", maxValue: 100, minValue: 0),
              ScaleIndicator(subscribedSignal: "APPS2_posiition", maxValue: 100, minValue: 0),
              ScaleIndicator(subscribedSignal: "STA1_position", maxValue: 180, minValue: 0),
              ScaleIndicator(subscribedSignal: "STA2_position", maxValue: 180, minValue: 0),
              ScaleIndicator(subscribedSignal: "PPS1", maxValue: 10, minValue: 0),
              ScaleIndicator(subscribedSignal: "PPS2", maxValue: 10, minValue: 0),
              ScaleIndicator(subscribedSignal: "Brake_pressure_rear", maxValue: 1400, minValue: 0),
              ScaleIndicator(subscribedSignal: "Brake_pressure_front", maxValue: 1400, minValue: 0),
              ScaleIndicator(subscribedSignal: "Brake_Force_sensor", maxValue: 1500, minValue: 0),
            ],),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
              FourStateLed(
                subscribedSignal: "AMS_LED",
                paddingFactor: 2,
              ),
              FourStateLed(
                subscribedSignal: "IMD_LED",
                paddingFactor: 2,
              ),
              FourStateLed(
                subscribedSignal: "MCU_LED",
                paddingFactor: 2,
              ),
              FourStateLed(
                subscribedSignal: "TCU_LED",
                paddingFactor: 2,
              ),
              FourStateLed(
                subscribedSignal: "TS_OFF_LED",
                paddingFactor: 2,
              ),
              FourStateLed(
                subscribedSignal: "Xavier_LED",
                paddingFactor: 2,
              ),
            ]),
          ]
        ),
        Column(
          children: const [
            BooleanPanel(
              subscribedSignals: [
                "SC_ENDLINE_SSG",
                "SC_HVECU_TSMS_FB",
                "SC_RES_FB",
                "SC_MCU_FB",
                "SC_FRONT_FB",
                "SC_BSPD_FB",
                "SC_HOOP_FB",
                "SC_START"
              ],
              reverseIndexes: [true, true, true, true, true, true, true, true],
              colsize: 8,
              title: "SC leds"
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            StringIndicator(subscribedSignal: "ASSI_state", decoder: assiStateDecoder),
            StringIndicator(subscribedSignal: "AS_Mission_selected", decoder: missionSelectDecoder),
            //StringIndicator(subscribedSignal: "AS_State", decoder: asStateDecoder),
            StringIndicator(subscribedSignal: "Car_state", decoder: carStateDecoder),
            BooleanIndicator(subscribedSignal: "ASMS", isInverted: true,),
            BooleanIndicator(subscribedSignal: "RES_GO_Signal"),
          ],
        )
      ],
    ),
    const Titlebar(title: "Dynamics and Control"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: const [
            RotaryIndicator(subscribedSignal: "v_x", numofStates: 51, granularity: 5, offset: 0,),
            Plot2D(subscribedSignals: ["AccX_Bosch", "AccY_Bosch"], title: "Accel Front", maxValue: 4),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            NumericPanel(
              subscribedSignals: [
                "AccX_Bosch",
                "AccY_Bosch",
                "YawRate_Bosch",
                "RollRate_Bosch",
              ],
              colsize: 4, title: "Bosch"
            ),
            NumericPanel(
              subscribedSignals: [
                "PN_IMU_Acc_X",
                "PN_IMU_Acc_Y",
                "PN_IMU_Yaw",
                "v_x",
              ], colsize: 5, title: "PN")
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            NumericPanel(
              subscribedSignals: [
                "VDC_Torque_Demand",
                "VDC_Power_Max",
                "VDC_Braking_Torque_Multiplier",
                "VDC_Yaw_Control_P",
                "VDC_Driving_Torque_Multiplier",
                "VDC_Yaw_Control_Balance",
                "VIRT_AMK1_LIMIT",
                "VIRT_AMK2_LIMIT",
                "VIRT_AMK3_LIMIT",
                "VIRT_AMK4_LIMIT",
              ],
              colsize: 10, title: "Control"
            ),
            BooleanIndicator(subscribedSignal: "VDC_DV_mode")
          ],
        ),
      ],
    ),
    const Titlebar(title: "Power and MCUs"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NumericPanel(
          subscribedSignals: [
            "AMK1_error_info",
            "AMK1_temp_IGBT",
            "AMK1_temp_inverter",
            "AMK1_temp_motor",
            "AMK1_actual_velocity",
            "AMK3_error_info",
            "AMK3_temp_IGBT",
            "AMK3_temp_inverter",
            "AMK3_temp_motor",
            "AMK3_actual_velocity",
            "AMK2_error_info",
            "AMK2_temp_IGBT",
            "AMK2_temp_inverter",
            "AMK2_temp_motor",
            "AMK2_actual_velocity",
            "AMK4_error_info",
            "AMK4_temp_IGBT",
            "AMK4_temp_inverter",
            "AMK4_temp_motor",
            "AMK4_actual_velocity",
          ],
          colsize: 10,
          title: "MCUs"
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            NumericPanel(
              subscribedSignals: [
                "HV_Cell_Voltage_MIN",
                "HV_Cell_Temp_MAX",
                "HV_Current",
                "State_of_Charge",
                "VIRT_HV_POWER_OUT",
                "VIRT_HV_CELL_VOLTAGE_MAX"
              ],
              colsize: 6,
              title: "HV Status"
            ),
            BooleanIndicator(subscribedSignal: "HV_DetStatus"),
            BooleanIndicator(subscribedSignal: "HV_ECU_SC_Endline_State"),
            BooleanIndicator(subscribedSignal: "HV_Cell_OT"),
          ],
        ),
        const BooleanPanel(
          subscribedSignals: [
            "BDCDCBB1OtpError",
            "BDCDCBB2OtpError",
            "BDCDCBB3OtpError",
            "BDCDCHVError",
            "BDCDCLVOvpInError",
            "BDCDCLVUvpInError",
            "BDCDCOutput1OvpError",
            "BDCDCOutput2OvpError",
            "BDCDCSR1OtpError",
            "BDCDCSR2OtpError",
          ],
          colsize: 10,
          title: "Brightloop status",
        ),
      ],
    ),
    const Titlebar(title: "Steering and Lap"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 700,
          width: 900,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Transform.translate(
                offset: Offset.fromDirection(-0.70 * pi ,500),
                child:
                  const RotaryIndicator(
                    granularity: 1,
                    numofStates: 12,
                    subscribedSignal: "Rotary1",
                    offset: 1,
                  ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(-0.75 * pi ,260),
                child:
                  const RotaryIndicator(
                    granularity: 1,
                    numofStates: 12,
                    subscribedSignal: "Rotary3",
                    offset: 1,
                  ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(-0.5 * pi ,10),
                child:
                  const RotaryIndicator(
                    granularity: 1,
                    numofStates: 12,
                    subscribedSignal: "Rotary5",
                    offset: 1,
                  ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(-0.25 * pi ,260),
                child:
                  const RotaryIndicator(
                    granularity: 1,
                    numofStates: 12,
                    subscribedSignal: "Rotary4",
                    offset: 1,
                  ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(-0.3 * pi ,500),
                child:
                  const RotaryIndicator(
                    granularity: 1,
                    numofStates: 12,
                    subscribedSignal: "Rotary2",
                    offset: 1,
                  ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(-0.5 * pi ,-50),
                child:
                  const BooleanPanel(
                    subscribedSignals: [
                      "Button1",
                      "Button2",
                      "Button3",
                      "Button4",
                    ],
                    colsize: 4,
                    title: "Buttons"
                  ),
              ),
            ],
          ),
        ),
        const NumericPanel(
          subscribedSignals: [
            "Laps",
            "LapMeter",
            "Laptime",
          ],
          colsize: 3,
          title: "Lap"
        ),
      ],
    )
  ],
  minWidth: 1220
);

TabLayout overviewSmallLayout = TabLayout(
  shortcutLabels: const ["System and Sensor checks", "Dynamics and Control", "Power and MCUs", "Steering and Lap"],
  layoutBreakpoints: const [0, 750, 1550, 2470],
  layout: [
    const Titlebar(title: "System and Sensor checks"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BooleanPanel(
          subscribedSignals: [
            "APPS1_validity",
            "APPS2_validity",
            "APPS_plausiblity",
            "STA1_validity",
            "STA2_validity",
            "STA_plausiblity",
            "Brake_force_validity",
            "Brake_pressure_front_validity",
            "Brake_pressure_rear_validity",
          ],
          reverseIndexes: [true, true, true, true, true, true, true, true, true],
          colsize: 9,
          title: "Sensor Status"
        ),
        Column(
          children: const [
            BooleanPanel(
              subscribedSignals: [
                "SC_ENDLINE_SSG",
                "SC_HVECU_TSMS_FB",
                "SC_RES_FB",
                "SC_MCU_FB",
                "SC_FRONT_FB",
                "SC_BSPD_FB",
                "SC_HOOP_FB",
                "SC_START"
              ],
              reverseIndexes: [true, true, true, true, true, true, true, true],
              colsize: 8,
              title: "SC leds"
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            StringIndicator(subscribedSignal: "ASSI_state", decoder: assiStateDecoder),
            StringIndicator(subscribedSignal: "AS_Mission_selected", decoder: missionSelectDecoder),
            //StringIndicator(subscribedSignal: "AS_State", decoder: asStateDecoder),
            StringIndicator(subscribedSignal: "Car_state", decoder: carStateDecoder),
            BooleanIndicator(subscribedSignal: "ASMS", isInverted: true,),
            BooleanIndicator(subscribedSignal: "RES_GO_Signal"),
          ],
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            ScaleIndicator(subscribedSignal: "APPS1_position", maxValue: 100, minValue: 0),
            ScaleIndicator(subscribedSignal: "APPS2_posiition", maxValue: 100, minValue: 0),
            ScaleIndicator(subscribedSignal: "STA1_position", maxValue: 180, minValue: 0),
            ScaleIndicator(subscribedSignal: "STA2_position", maxValue: 180, minValue: 0),
            ScaleIndicator(subscribedSignal: "PPS1", maxValue: 10, minValue: 0),
            ScaleIndicator(subscribedSignal: "PPS2", maxValue: 10, minValue: 0),
            ScaleIndicator(subscribedSignal: "Brake_pressure_rear", maxValue: 1400, minValue: 0),
            ScaleIndicator(subscribedSignal: "Brake_pressure_front", maxValue: 1400, minValue: 0),
            ScaleIndicator(subscribedSignal: "Brake_Force_sensor", maxValue: 1500, minValue: 0),
          ],
        ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
            FourStateLed(
              subscribedSignal: "AMS_LED",
              paddingFactor: 2,
            ),
            FourStateLed(
              subscribedSignal: "IMD_LED",
              paddingFactor: 2,
            ),
            FourStateLed(
              subscribedSignal: "MCU_LED",
              paddingFactor: 2,
            ),
            FourStateLed(
              subscribedSignal: "TCU_LED",
              paddingFactor: 2,
            ),
            FourStateLed(
              subscribedSignal: "TS_OFF_LED",
              paddingFactor: 2,
            ),
            FourStateLed(
              subscribedSignal: "Xavier_LED",
              paddingFactor: 2,
            ),
          ]),
      ]
    ),
    const Titlebar(title: "Dynamics and Control"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: const [
            RotaryIndicator(subscribedSignal: "v_x", numofStates: 51, granularity: 5, offset: 0,),
            Plot2D(subscribedSignals: ["AccX_Bosch", "AccY_Bosch"], title: "Accel Front", maxValue: 4),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            NumericPanel(
              subscribedSignals: [
                "AccX_Bosch",
                "AccY_Bosch",
                "YawRate_Bosch",
                "RollRate_Bosch",
              ],
              colsize: 4, title: "Bosch"
            ),
            NumericPanel(
              subscribedSignals: [
                "PN_IMU_Acc_X",
                "PN_IMU_Acc_Y",
                "PN_IMU_Yaw",
                "v_x",
              ], colsize: 5, title: "PN")
          ],
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            NumericPanel(
              subscribedSignals: [
                "VDC_Torque_Demand",
                "VDC_Power_Max",
                "VDC_Braking_Torque_Multiplier",
                "VDC_Yaw_Control_P",
                "VDC_Driving_Torque_Multiplier",
                "VDC_Yaw_Control_Balance",
                "VIRT_AMK1_LIMIT",
                "VIRT_AMK2_LIMIT",
                "VIRT_AMK3_LIMIT",
                "VIRT_AMK4_LIMIT",
              ],
              colsize: 10, title: "Control"
            ),
            BooleanIndicator(subscribedSignal: "VDC_DV_mode"),
          ],
        ),
      ],
    ),
    const Titlebar(title: "Power and MCUs"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        NumericPanel(
          subscribedSignals: [
            "AMK1_error_info",
            "AMK1_temp_IGBT",
            "AMK1_temp_inverter",
            "AMK1_temp_motor",
            "AMK1_actual_velocity",
            "AMK3_error_info",
            "AMK3_temp_IGBT",
            "AMK3_temp_inverter",
            "AMK3_temp_motor",
            "AMK3_actual_velocity",
            "AMK2_error_info",
            "AMK2_temp_IGBT",
            "AMK2_temp_inverter",
            "AMK2_temp_motor",
            "AMK2_actual_velocity",
            "AMK4_error_info",
            "AMK4_temp_IGBT",
            "AMK4_temp_inverter",
            "AMK4_temp_motor",
            "AMK4_actual_velocity",
          ],
          colsize: 10,
          title: "MCUs"
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            NumericPanel(
              subscribedSignals: [
                "HV_Cell_Voltage_MIN",
                "HV_Cell_Temp_MAX",
                "HV_Current",
                "State_of_Charge",
                "VIRT_HV_POWER_OUT",
                "VIRT_HV_CELL_VOLTAGE_MAX"
              ],
              colsize: 6,
              title: "HV Status"
            ),
            BooleanIndicator(subscribedSignal: "HV_DetStatus"),
            BooleanIndicator(subscribedSignal: "HV_ECU_SC_Endline_State"),
            BooleanIndicator(subscribedSignal: "HV_Cell_OT"),
          ],
        ),
        const BooleanPanel(
          subscribedSignals: [
            "BDCDCBB1OtpError",
            "BDCDCBB2OtpError",
            "BDCDCBB3OtpError",
            "BDCDCHVError",
            "BDCDCLVOvpInError",
            "BDCDCLVUvpInError",
            "BDCDCOutput1OvpError",
            "BDCDCOutput2OvpError",
            "BDCDCSR1OtpError",
            "BDCDCSR2OtpError",
          ],
          colsize: 10,
          title: "Brightloop status",
        ),
      ],
    ),
    const Titlebar(title: "Steering and Lap"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 600,
          width: 650,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Transform.translate(
                offset: Offset.fromDirection(-0.7 * pi ,500),
                child:
                  const RotaryIndicator(
                    granularity: 1,
                    numofStates: 12,
                    subscribedSignal: "Rotary1",
                    offset: 1,
                  ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(-0.75 * pi ,260),
                child:
                  const RotaryIndicator(
                    granularity: 1,
                    numofStates: 12,
                    subscribedSignal: "Rotary3",
                    offset: 1,
                  ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(-0.5 * pi ,10),
                child:
                  const RotaryIndicator(
                    granularity: 1,
                    numofStates: 12,
                    subscribedSignal: "Rotary5",
                    offset: 1,
                  ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(-0.25 * pi ,260),
                child:
                  const RotaryIndicator(
                    granularity: 1,
                    numofStates: 12,
                    subscribedSignal: "Rotary4",
                    offset: 1,
                  ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(-0.30 * pi ,500),
                child:
                  const RotaryIndicator(
                    granularity: 1,
                    numofStates: 12,
                    subscribedSignal: "Rotary2",
                    offset: 1,
                  ),
              ),
            ],
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        NumericPanel(
          subscribedSignals: [
            "Laps",
            "LapMeter",
            "Laptime",
          ],
          colsize: 3,
          title: "Lap"
        ),
        BooleanPanel(
          subscribedSignals: [
            "Button1",
            "Button2",
            "Button3",
            "Button4",
          ],
          colsize: 4,
          title: "Buttons"
        ),
      ],
    ),
  ],
  minWidth: 670
);