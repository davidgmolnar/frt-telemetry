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
        "Brake_force_sensor_ADC"
      ], colsize: 9, title: "ADCs"),
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
        "Button_ON_OFF",
        "Button_START",
        "Dash_HV",
      ], colsize: 6, title: "Dashboard"),
      BooleanPanel(
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
          "Brake_force_sensor_ADC"
        ], colsize: 9, title: "ADCs"),
        BooleanPanel(
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
      ]),
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      BooleanPanel(subscribedSignals: [
        "Dashboard_heartbeat_error",
        "HVECU_Heartbeat_error",
        "MCU_Heartbeat_error",
        "Pedal_Node_Heartbeat_error",
        "Steering_Heartbeat_error",
        "TCU_Heartbeat_error"
      ], colsize: 6, title: "Heartbeats"),
      BooleanPanel(subscribedSignals: [
        "Button_ON_OFF",
        "Button_START",
        "Dash_HV",
      ], colsize: 6, title: "Dashboard"),
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
    "Brake_force_sensor_ADC"
  ], colsize: 9, title: "ADCs"),
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
  const BooleanPanel(subscribedSignals: [
    "Dashboard_heartbeat_error",
    "HVECU_Heartbeat_error",
    "MCU_Heartbeat_error",
    "Pedal_Node_Heartbeat_error",
    "Steering_Heartbeat_error",
    "TCU_Heartbeat_error"
  ], colsize: 6, title: "Heartbeats"),
  const BooleanPanel(subscribedSignals: [
    "Button_ON_OFF",
    "Button_START",
    "Dash_HV",
  ], colsize: 6, title: "Dashboard"),
], minWidth: 300);
