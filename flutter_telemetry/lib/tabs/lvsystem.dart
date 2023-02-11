import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

List<Widget> lvSystemSmall = [
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      FourStateLed(subscribedSignal: "AMS_LED"),
      FourStateLed(subscribedSignal: "HV_LED"),
      FourStateLed(subscribedSignal: "ASB_ERROR_LED"),
      FourStateLed(subscribedSignal: "TS_OFF_LED"),
      FourStateLed(subscribedSignal: "IMD_LED"),
    ]
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      FourStateLed(subscribedSignal: "TCU_LED"),
      FourStateLed(subscribedSignal: "MCU1_LED"),
      FourStateLed(subscribedSignal: "MCU2_LED"),
      FourStateLed(subscribedSignal: "MCU3_LED"),
      FourStateLed(subscribedSignal: "MCU4_LED"),
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      NumericPanel(
        subscribedSignals: [
          "EEPROM_APPS1_MAX",
          "EEPROM_APPS1_MIN",
          "EEPROM_APPS2_MAX",
          "EEPROM_APPS2_MIN",
          "EEPROM_STA1_MAX",
          "EEPROM_STA1_MIN",
          "EEPROM_STA2_MAX",
          "EEPROM_STA2_MIN",
        ],
        colsize: 8, title: "EEPROMS"
      ),
      NumericPanel(
        subscribedSignals: [
          "APPS1_ADC",
          "APPS2_ADC",
          "PPS1_ADC",
          "PPS2_ADC",
          "STA1_ADC",
          "STA2_ADC",
          "Brake_pressure_front_ADC",
          "Brake_pressure_rear_ADC",
        ],
        colsize: 8, title: "ADCs"
      ),
      BooleanPanel(
        subscribedSignals: [
          "APPS1_validity",
          "APPS2_validity",
          "STA1_validity",
          "STA2_validity",
          "Brake_force_validity",
          "Brake_pressure_front_validity",
          "Brake_pressure_rear_validity",
        ],
        colsize: 7,
        title: "Sensors"
      ),
    ]
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      BooleanPanel(
        subscribedSignals: [
          "Dashboard_heartbeat_error",
          "HVECU_Heartbeat_error",
          "MCU_Heartbeat_error",
          "Pedal_Node_Heartbeat_error",
          "Steering_Heartbeat_error",
          "TCU_Heartbeat_error"
        ],
        colsize: 6,
        title: "Heartbeats"
      ),
      BooleanPanel(
        subscribedSignals: [
          "Button_OFF",
          "Button_ON",
          "Button_START",
          "Dash_BLANK",
          "Dash_MODE",
          "Dash_XLAT"
        ],
        colsize: 6, title: "Dashboard"
      ),
      BooleanPanel(
        subscribedSignals: [
          "MCU_EF_State",
          "MCU_RF_State",
          "MCU_FRONT_SUPPLY",
          "MCU_REAR_SUPPLY",
          "Brake_Light"
        ],
        colsize: 5, title: "Misc leds"
      ),
      NumericPanel(
        subscribedSignals: [
          "SC_ENDLINE",
          "BFS_Offset"
        ],
        colsize: 2, title: "Misc numeric"
      ),
    ],
  ),
];

List<Widget> lvSystemBig = [
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      FourStateLed(subscribedSignal: "AMS_LED"),
      FourStateLed(subscribedSignal: "HV_LED"),
      FourStateLed(subscribedSignal: "ASB_ERROR_LED"),
      FourStateLed(subscribedSignal: "TS_OFF_LED"),
      FourStateLed(subscribedSignal: "IMD_LED"),
      FourStateLed(subscribedSignal: "TCU_LED"),
      FourStateLed(subscribedSignal: "MCU1_LED"),
      FourStateLed(subscribedSignal: "MCU2_LED"),
      FourStateLed(subscribedSignal: "MCU3_LED"),
      FourStateLed(subscribedSignal: "MCU4_LED"),
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      NumericPanel(
        subscribedSignals: [
          "EEPROM_APPS1_MAX",
          "EEPROM_APPS1_MIN",
          "EEPROM_APPS2_MAX",
          "EEPROM_APPS2_MIN",
          "EEPROM_STA1_MAX",
          "EEPROM_STA1_MIN",
          "EEPROM_STA2_MAX",
          "EEPROM_STA2_MIN",
        ],
        colsize: 8, title: "EEPROMS"
      ),
      NumericPanel(
        subscribedSignals: [
          "APPS1_ADC",
          "APPS2_ADC",
          "PPS1_ADC",
          "PPS2_ADC",
          "STA1_ADC",
          "STA2_ADC",
          "Brake_pressure_front_ADC",
          "Brake_pressure_rear_ADC",
        ],
        colsize: 8, title: "ADCs"
      ),
      BooleanPanel(
        subscribedSignals: [
          "APPS1_validity",
          "APPS2_validity",
          "STA1_validity",
          "STA2_validity",
          "Brake_force_validity",
          "Brake_pressure_front_validity",
          "Brake_pressure_rear_validity",
        ],
        colsize: 7,
        title: "Sensors"
      ),
      BooleanPanel(
        subscribedSignals: [
          "Dashboard_heartbeat_error",
          "HVECU_Heartbeat_error",
          "MCU_Heartbeat_error",
          "Pedal_Node_Heartbeat_error",
          "Steering_Heartbeat_error",
          "TCU_Heartbeat_error"
        ],
        colsize: 6,
        title: "Heartbeats"
      )
    ],
  ),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      BooleanPanel(
        subscribedSignals: [
          "Button_OFF",
          "Button_ON",
          "Button_START",
          "Dash_BLANK",
          "Dash_MODE",
          "Dash_XLAT"
        ],
        colsize: 6, title: "Dashboard"
      ),
      BooleanPanel(
        subscribedSignals: [
          "MCU_EF_State",
          "MCU_RF_State",
          "MCU_FRONT_SUPPLY",
          "MCU_REAR_SUPPLY",
          "Brake_Light"
        ],
        colsize: 5, title: "Misc leds"
      ),
      NumericPanel(
        subscribedSignals: [
          "SC_ENDLINE",
          "BFS_Offset"
        ],
        colsize: 2, title: "Misc numeric"
      ),
    ],
  ),
];