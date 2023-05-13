import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

TabLayout lvSystemBigLayout =
    TabLayout(shortcutLabels: [], layoutBreakpoints: [], layout: [
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      FourStateLed(
        subscribedSignal: "Xavier_LED",
        paddingFactor: 2,
      ),
      FourStateLed(
        subscribedSignal: "TS_OFF_LED",
        paddingFactor: 2,
      ),
      FourStateLed(
        subscribedSignal: "TCU_LED",
        paddingFactor: 2,
      ),
      FourStateLed(
        subscribedSignal: "MCU_LED",
        paddingFactor: 2,
      ),
      FourStateLed(
        subscribedSignal: "IMD_LED",
        paddingFactor: 2,
      ),
      FourStateLed(
        subscribedSignal: "AMS_LED",
        paddingFactor: 2,
      ),
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      NumericPanel(subscribedSignals: [
        "EEPROM_APPS1_MAX",
        "EEPROM_APPS1_MIN",
        "EEPROM_APPS2_MAX",
        "EEPROM_APPS2_MIN",
        "EEPROM_STA1_MAX",
        "EEPROM_STA1_MIN",
        "EEPROM_STA2_MAX",
        "EEPROM_STA2_MIN",
      ], colsize: 8, title: "EEPROMS"),
      NumericPanel(subscribedSignals: [
        "APPS1_ADC",
        "APPS2_ADC",
        "PPS1_ADC",
        "PPS2_ADC",
        "STA1_ADC",
        "STA2_ADC",
        "Brake_pressure_front_ADC",
        "Brake_pressure_rear_ADC",
      ], colsize: 8, title: "ADCs"),
      BooleanPanel(subscribedSignals: [
        "Dashboard_heartbeat_error",
        "HVECU_Heartbeat_error",
        "MCU_Heartbeat_error",
        "Pedal_Node_Heartbeat_error",
        "Steering_Heartbeat_error",
        "TCU_Heartbeat_error"
      ], colsize: 6, title: "Heartbeats")
    ],
  ),
  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      BooleanPanel(subscribedSignals: [
        "Button_OFF",
        "Button_ON",
        "Button_START",
        "Dash_BLANK",
        "Dash_MODE",
        "Dash_XLAT"
      ], colsize: 6, title: "Dashboard"),
      BooleanPanel(subscribedSignals: [
        "APPS1_validity",
        "APPS2_validity",
        "STA1_validity",
        "STA2_validity",
        "Brake_force_validity",
        "Brake_pressure_front_validity",
        "Brake_pressure_rear_validity",
      ], colsize: 7, title: "Sensors"),
      BooleanPanel(subscribedSignals: [
        "MCU_EF_State",
        "MCU_RF_State",
        "MCU_FRONT_SUPPLY",
        "MCU_REAR_SUPPLY",
        "Brake_Light"
      ], colsize: 5, title: "Misc leds"),
      NumericPanel(
          subscribedSignals: ["SC_ENDLINE", "BFS_Offset"],
          colsize: 2,
          title: "Misc numeric"),
    ],
  ),
], minWidth: 1050);

TabLayout lvSystemSmallLayout =
    TabLayout(shortcutLabels: [], layoutBreakpoints: [], layout: [
  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
    FourStateLed(
      subscribedSignal: "Xavier_LED",
      paddingFactor: 2,
    ),
    FourStateLed(
      subscribedSignal: "TS_OFF_LED",
      paddingFactor: 2,
    ),
    FourStateLed(
      subscribedSignal: "TCU_LED",
      paddingFactor: 2,
    ),
    FourStateLed(
      subscribedSignal: "MCU_LED",
      paddingFactor: 2,
    ),
    FourStateLed(
      subscribedSignal: "IMD_LED",
      paddingFactor: 2,
    ),
    FourStateLed(
      subscribedSignal: "AMS_LED",
      paddingFactor: 2,
    ),
  ]),
  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        NumericPanel(subscribedSignals: [
          "EEPROM_APPS1_MAX",
          "EEPROM_APPS1_MIN",
          "EEPROM_APPS2_MAX",
          "EEPROM_APPS2_MIN",
          "EEPROM_STA1_MAX",
          "EEPROM_STA1_MIN",
          "EEPROM_STA2_MAX",
          "EEPROM_STA2_MIN",
        ], colsize: 8, title: "EEPROMS"),
        NumericPanel(subscribedSignals: [
          "APPS1_ADC",
          "APPS2_ADC",
          "PPS1_ADC",
          "PPS2_ADC",
          "STA1_ADC",
          "STA2_ADC",
          "Brake_pressure_front_ADC",
          "Brake_pressure_rear_ADC",
        ], colsize: 8, title: "ADCs"),
        BooleanPanel(subscribedSignals: [
          "APPS1_validity",
          "APPS2_validity",
          "STA1_validity",
          "STA2_validity",
          "Brake_force_validity",
          "Brake_pressure_front_validity",
          "Brake_pressure_rear_validity",
        ], colsize: 7, title: "Sensors"),
      ]),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const BooleanPanel(subscribedSignals: [
        "Dashboard_heartbeat_error",
        "HVECU_Heartbeat_error",
        "MCU_Heartbeat_error",
        "Pedal_Node_Heartbeat_error",
        "Steering_Heartbeat_error",
        "TCU_Heartbeat_error"
      ], colsize: 6, title: "Heartbeats"),
      const BooleanPanel(subscribedSignals: [
        "Button_OFF",
        "Button_ON",
        "Button_START",
        "Dash_BLANK",
        "Dash_MODE",
        "Dash_XLAT"
      ], colsize: 6, title: "Dashboard"),
      Column(
        children: const [
          BooleanPanel(subscribedSignals: [
            "MCU_EF_State",
            "MCU_RF_State",
            "MCU_FRONT_SUPPLY",
            "MCU_REAR_SUPPLY",
            "Brake_Light"
          ], colsize: 5, title: "Misc"),
          NumericIndicator(subscribedSignal: "SC_ENDLINE"),
          NumericIndicator(subscribedSignal: "BFS_Offset"),
        ],
      ),
    ],
  ),
], minWidth: 750);

TabLayout lvSystemMobileLayout =
    TabLayout(shortcutLabels: [], layoutBreakpoints: [], layout: [
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      FourStateLed(
        subscribedSignal: "Xavier_LED",
        paddingFactor: 2,
      ),
      FourStateLed(
        subscribedSignal: "TS_OFF_LED",
        paddingFactor: 2,
      )
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      FourStateLed(
        subscribedSignal: "TCU_LED",
        paddingFactor: 2,
      ),
      FourStateLed(
        subscribedSignal: "MCU_LED",
        paddingFactor: 2,
      )
    ],
  ),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      FourStateLed(
        subscribedSignal: "IMD_LED",
        paddingFactor: 2,
      ),
      FourStateLed(
        subscribedSignal: "AMS_LED",
        paddingFactor: 2,
      )
    ],
  ),
  const NumericPanel(subscribedSignals: [
    "EEPROM_APPS1_MAX",
    "EEPROM_APPS1_MIN",
    "EEPROM_APPS2_MAX",
    "EEPROM_APPS2_MIN",
    "EEPROM_STA1_MAX",
    "EEPROM_STA1_MIN",
    "EEPROM_STA2_MAX",
    "EEPROM_STA2_MIN",
  ], colsize: 8, title: "EEPROMS"),
  const NumericPanel(subscribedSignals: [
    "APPS1_ADC",
    "APPS2_ADC",
    "PPS1_ADC",
    "PPS2_ADC",
    "STA1_ADC",
    "STA2_ADC",
    "Brake_pressure_front_ADC",
    "Brake_pressure_rear_ADC",
  ], colsize: 8, title: "ADCs"),
  const BooleanPanel(subscribedSignals: [
    "APPS1_validity",
    "APPS2_validity",
    "STA1_validity",
    "STA2_validity",
    "Brake_force_validity",
    "Brake_pressure_front_validity",
    "Brake_pressure_rear_validity",
  ], colsize: 7, title: "Sensors"),
  const BooleanPanel(subscribedSignals: [
    "Dashboard_heartbeat_error",
    "HVECU_Heartbeat_error",
    "MCU_Heartbeat_error",
    "Pedal_Node_Heartbeat_error",
    "Steering_Heartbeat_error",
    "TCU_Heartbeat_error"
  ], colsize: 6, title: "Heartbeats"),
  const BooleanPanel(subscribedSignals: [
    "Button_OFF",
    "Button_ON",
    "Button_START",
    "Dash_BLANK",
    "Dash_MODE",
    "Dash_XLAT"
  ], colsize: 6, title: "Dashboard"),
  const BooleanPanel(subscribedSignals: [
    "MCU_EF_State",
    "MCU_RF_State",
    "MCU_FRONT_SUPPLY",
    "MCU_REAR_SUPPLY",
    "Brake_Light"
  ], colsize: 5, title: "Misc"),
  const NumericIndicator(subscribedSignal: "SC_ENDLINE"),
  const NumericIndicator(subscribedSignal: "BFS_Offset")
], minWidth: 300);
