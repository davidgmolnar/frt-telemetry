import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

class OverviewTab extends StatefulWidget{
    const OverviewTab({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OverviewTabState();
  }
}

class OverviewTabState extends State<OverviewTab>{
	late Timer timer;
  double threshold = 1220;
  bool isSmall = false;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS'][0]), (Timer t) => updateLayout());
    }

  void updateLayout(){
    if(context.size!.width < threshold && !isSmall){
      setState(() {
        isSmall = true;
      });
    }
    else if(context.size!.width > threshold && isSmall){
      setState(() {
        isSmall = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!isSmall){
      return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent){
            if(event.logicalKey.keyLabel == '0'){
              _controller.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            }
            else if(event.logicalKey.keyLabel == '1'){
              _controller.animateTo(450, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            }
            else if(event.logicalKey.keyLabel == '2'){
              _controller.animateTo(1000, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            }
            else if(event.logicalKey.keyLabel == '3'){
              _controller.animateTo(1450, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor,
            toolbarHeight: 50,
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () {
                  _controller.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                },
                child: Text("System and Sensor checks", style: TextStyle(color: primaryColor),),
              ),
              TextButton(
                onPressed: () {
                  _controller.animateTo(450, duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
                },
                child: Text("Dynamics and Control", style: TextStyle(color: primaryColor),),
              ),
              TextButton(
                onPressed: () {
                  _controller.animateTo(1000, duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
                },
                child: Text("Power and MCUs", style: TextStyle(color: primaryColor),),
              ),
              TextButton(
                onPressed: () {
                  _controller.animateTo(1450, duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
                },
                child: Text("Steering and Lap", style: TextStyle(color: primaryColor),),
              ),
            ],
            ),
          body: ListView(
            controller: _controller,
            children: [
              const Titlebar(title: "System and Sensor checks"),
              Row(
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
                    colsize: 9,
                    title: "Sensor leds"
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
                        ScaleIndicator(subscribedSignal: "Brake_pressure_rear_ADC", maxValue: 700, minValue: 0),
                        ScaleIndicator(subscribedSignal: "Brake_pressure_front_ADC", maxValue: 700, minValue: 0),
                        ScaleIndicator(subscribedSignal: "Brake_Force_sensor", maxValue: 1500, minValue: 0),
                      ],),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: const [
                              FourStateLed(subscribedSignal: "AMS_LED"),
                              FourStateLed(subscribedSignal: "HV_LED")
                            ],
                          ),
                          Column(
                            children: const [
                              FourStateLed(subscribedSignal: "ASB_ERROR_LED"),
                              FourStateLed(subscribedSignal: "TS_OFF_LED")
                            ],
                          ),
                          Column(
                            children: const [
                              FourStateLed(subscribedSignal: "IMD_LED"),
                              FourStateLed(subscribedSignal: "TCU_LED")
                            ],
                          ),
                          Column(
                            children: const [
                              FourStateLed(subscribedSignal: "MCU1_LED"),
                              FourStateLed(subscribedSignal: "MCU2_LED")
                            ],
                          ),
                          Column(
                            children: const [
                              FourStateLed(subscribedSignal: "MCU3_LED"),
                              FourStateLed(subscribedSignal: "MCU4_LED")
                            ],
                          ),
                        ],
                      ),
                    ]
                  ),
                  Column(
                    children: const [
                      BooleanPanel(
                        subscribedSignals: [
                          "SC_BSPD_FB",
                          "SC_DV_FB",
                          "SC_DV_RELAY_FB",
                          "SC_EBS_FB",
                          "SC_FRONT_FB",
                          "SC_HOOP_FB",
                          "SC_MCU_FB",
                        ],
                        colsize: 7,
                        title: "SC leds"
                      ),
                      NumericIndicator(subscribedSignal: "SC_ENDLINE")
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      StringIndicator(subscribedSignal: "ASSI_state", decoder: assiStateDecoder),
                      StringIndicator(subscribedSignal: "AS_Mission_selected", decoder: missionSelectDecoder),
                      StringIndicator(subscribedSignal: "AS_State", decoder: asStateDecoder),
                      BooleanIndicator(subscribedSignal: "ON_Car_State"),
                      BooleanIndicator(subscribedSignal: "OFF_Car_State"),
                      BooleanIndicator(subscribedSignal: "RTDS_Car_State"),
                      BooleanIndicator(subscribedSignal: "START_Car_State"),
                      BooleanIndicator(subscribedSignal: "ASMS"),
                      BooleanIndicator(subscribedSignal: "RES_GO_Signal"),
                    ],
                  )
                ],
              ),
              const Titlebar(title: "Dynamics and Control"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: const [
                      RotaryIndicator(subscribedSignal: "v_x", numofStates: 51, granularity: 10,),
                      Plot2D(subscribedSignals: ["Acc_Front_AccX", "Acc_Front_AccY"], title: "Accel Front", maxValue: 4),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      NumericPanel(
                        subscribedSignals: [
                          "v_x",
                          "v_y",
                          "Acc_Front_AccX",
                          "Acc_Front_AccY",
                          "AccX_Rear",
                          "AccY_Rear",
                          "Bosch_yaw_rate",
                          "Vectornav_yaw_rate_rear_value",
                          "Yaw_Rate_Rear",
                        ],
                        colsize: 10, title: "Dynamics"
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NumericPanel(
                        subscribedSignals: [
                          "VDC_Torque_Demand",
                          "VDC_Power_Max",
                          "VDC_Braking_Torque_Multiplier",
                          "VDC_Yaw_Control_P",
                          "VDC_Driving_Torque_Multiplier",
                          "VDC_Yaw_Control_Balance",
                        ],
                        colsize: 6, title: "Control"
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                        width: widthPerColumnNumeric.toDouble(),
                        child: Expanded(
                          child: Column(
                            children: const [
                              CompoundIndicator(
                                firstSignal: "AMK1_Torque_Limit_Positive",
                                secondSignal: "AMK1_Torque_Limit_Negative",
                                title: "AMK1 Torque Limit",
                                rule: torqueLimitRule,
                              ),
                              CompoundIndicator(
                                firstSignal: "AMK2_Torque_Limit_Positive",
                                secondSignal: "AMK2_Torque_Limit_Negative",
                                title: "AMK2 Torque Limit",
                                rule: torqueLimitRule,
                              ),
                              CompoundIndicator(
                                firstSignal: "AMK3_TorqueLimitPositive",
                                secondSignal: "AMK3_TorqueLimitNegative",
                                title: "AMK3 Torque Limit",
                                rule: torqueLimitRule,
                              ),
                              CompoundIndicator(
                                firstSignal: "AMK4_TorqueLimitPositive",
                                secondSignal: "AMK4_TorqueLimitNegative",
                                title: "AMK4 Torque Limit",
                                rule: torqueLimitRule,
                              ),
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      BooleanIndicator(subscribedSignal: "VDC_DV_mode")
                    ],
                  )
                ],
              ),
              const Titlebar(title: "Power and MCUs"),
              Row(
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
                        ],
                        colsize: 4,
                        title: "HV Status"
                      ),
                      BooleanIndicator(subscribedSignal: "HV_DetStatus"),
                      BooleanIndicator(subscribedSignal: "HV_ECU_SC_Endline_State"),
                      BooleanIndicator(subscribedSignal: "HV_Cell_OT"),
                      CompoundIndicator(firstSignal: "HV_Current", secondSignal: "HV_Voltage_After_AIRs", rule: hvPowerRule, title: "HV Power out"),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 600,
                    width: 900,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Transform.translate(
                          offset: Offset.fromDirection(-0.70 * pi ,450),
                          child:
                            const RotaryIndicator(
                              granularity: 1,
                              numofStates: 12,
                              subscribedSignal: "Rotary1",
                            ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(-0.75 * pi ,260),
                          child:
                            const RotaryIndicator(
                              granularity: 1,
                              numofStates: 12,
                              subscribedSignal: "Rotary3",
                            ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(-0.5 * pi ,50),
                          child:
                            const RotaryIndicator(
                              granularity: 1,
                              numofStates: 12,
                              subscribedSignal: "Rotary5",
                            ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(-0.25 * pi ,260),
                          child:
                            const RotaryIndicator(
                              granularity: 1,
                              numofStates: 12,
                              subscribedSignal: "Rotary4",
                            ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(-0.3 * pi ,450),
                          child:
                            const RotaryIndicator(
                              granularity: 1,
                              numofStates: 12,
                              subscribedSignal: "Rotary2",
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
          ),
        ),
      );
    }
    else{
      return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent){
            if(event.logicalKey.keyLabel == '0'){
              _controller.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            }
            else if(event.logicalKey.keyLabel == '1'){
              _controller.animateTo(750, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            }
            else if(event.logicalKey.keyLabel == '2'){
              _controller.animateTo(1550, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            }
            else if(event.logicalKey.keyLabel == '3'){
              _controller.animateTo(2470, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor,
            toolbarHeight: 50,
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () {
                  _controller.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                },
                child: Text("System and Sensor checks", style: TextStyle(color: primaryColor),),
              ),
              TextButton(
                onPressed: () {
                  _controller.animateTo(750, duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
                },
                child: Text("Dynamics and Control", style: TextStyle(color: primaryColor),),
              ),
              TextButton(
                onPressed: () {
                  _controller.animateTo(1550, duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
                },
                child: Text("Power and MCUs", style: TextStyle(color: primaryColor),),
              ),
              TextButton(
                onPressed: () {
                  _controller.animateTo(2470, duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
                },
                child: Text("Steering and Lap", style: TextStyle(color: primaryColor),),
              ),
            ],
            ),
          body: ListView(
            controller: _controller,
            children: [
              const Titlebar(title: "System and Sensor checks"),
              Row(
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
                    colsize: 9,
                    title: "Sensor leds"
                  ),
                  Column(
                    children: const [
                      BooleanPanel(
                        subscribedSignals: [
                          "SC_BSPD_FB",
                          "SC_DV_FB",
                          "SC_DV_RELAY_FB",
                          "SC_EBS_FB",
                          "SC_FRONT_FB",
                          "SC_HOOP_FB",
                          "SC_MCU_FB",
                        ],
                        colsize: 7,
                        title: "SC leds"
                      ),
                      NumericIndicator(subscribedSignal: "SC_ENDLINE")
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      StringIndicator(subscribedSignal: "ASSI_state", decoder: assiStateDecoder),
                      StringIndicator(subscribedSignal: "AS_Mission_selected", decoder: missionSelectDecoder),
                      StringIndicator(subscribedSignal: "AS_State", decoder: asStateDecoder),
                      BooleanIndicator(subscribedSignal: "ON_Car_State"),
                      BooleanIndicator(subscribedSignal: "OFF_Car_State"),
                      BooleanIndicator(subscribedSignal: "RTDS_Car_State"),
                      BooleanIndicator(subscribedSignal: "START_Car_State"),
                      BooleanIndicator(subscribedSignal: "ASMS"),
                      BooleanIndicator(subscribedSignal: "RES_GO_Signal"),
                    ],
                  ),
                ],
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
                    ScaleIndicator(subscribedSignal: "Brake_pressure_rear_ADC", maxValue: 700, minValue: 0),
                    ScaleIndicator(subscribedSignal: "Brake_pressure_front_ADC", maxValue: 700, minValue: 0),
                    ScaleIndicator(subscribedSignal: "Brake_Force_sensor", maxValue: 1500, minValue: 0),
                  ],),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: const [
                          FourStateLed(subscribedSignal: "AMS_LED"),
                          FourStateLed(subscribedSignal: "HV_LED")
                        ],
                      ),
                      Column(
                        children: const [
                          FourStateLed(subscribedSignal: "ASB_ERROR_LED"),
                          FourStateLed(subscribedSignal: "TS_OFF_LED")
                        ],
                      ),
                      Column(
                        children: const [
                          FourStateLed(subscribedSignal: "IMD_LED"),
                          FourStateLed(subscribedSignal: "TCU_LED")
                        ],
                      ),
                      Column(
                        children: const [
                          FourStateLed(subscribedSignal: "MCU1_LED"),
                          FourStateLed(subscribedSignal: "MCU2_LED")
                        ],
                      ),
                      Column(
                        children: const [
                          FourStateLed(subscribedSignal: "MCU3_LED"),
                          FourStateLed(subscribedSignal: "MCU4_LED")
                        ],
                      ),
                    ],
                  ),
                ]
              ),
              const Titlebar(title: "Dynamics and Control"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: const [
                      RotaryIndicator(subscribedSignal: "v_x", numofStates: 51, granularity: 10,),
                      Plot2D(subscribedSignals: ["Acc_Front_AccX", "Acc_Front_AccY"], title: "Accel Front", maxValue: 4),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      NumericPanel(
                        subscribedSignals: [
                          "v_x",
                          "v_y",
                          "Acc_Front_AccX",
                          "Acc_Front_AccY",
                          "AccX_Rear",
                          "AccY_Rear",
                          "Bosch_yaw_rate",
                          "Vectornav_yaw_rate_rear_value",
                          "Yaw_Rate_Rear",
                        ],
                        colsize: 10, title: "Dynamics"
                      ),
                    ],
                  ),
                ],
              ),
              Row(
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
                        ],
                        colsize: 6, title: "Control"
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BooleanIndicator(subscribedSignal: "VDC_DV_mode"),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                        width: widthPerColumnNumeric.toDouble(),
                        child: Expanded(
                          child: Column(
                            children: const [
                              CompoundIndicator(
                                firstSignal: "AMK1_Torque_Limit_Positive",
                                secondSignal: "AMK1_Torque_Limit_Negative",
                                title: "AMK1 Torque Limit",
                                rule: torqueLimitRule,
                              ),
                              CompoundIndicator(
                                firstSignal: "AMK2_Torque_Limit_Positive",
                                secondSignal: "AMK2_Torque_Limit_Negative",
                                title: "AMK2 Torque Limit",
                                rule: torqueLimitRule,
                              ),
                              CompoundIndicator(
                                firstSignal: "AMK3_TorqueLimitPositive",
                                secondSignal: "AMK3_TorqueLimitNegative",
                                title: "AMK3 Torque Limit",
                                rule: torqueLimitRule,
                              ),
                              CompoundIndicator(
                                firstSignal: "AMK4_TorqueLimitPositive",
                                secondSignal: "AMK4_TorqueLimitNegative",
                                title: "AMK4 Torque Limit",
                                rule: torqueLimitRule,
                              ),
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Titlebar(title: "Power and MCUs"),
              Row(
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
                        ],
                        colsize: 4,
                        title: "HV Status"
                      ),
                      BooleanIndicator(subscribedSignal: "HV_DetStatus"),
                      BooleanIndicator(subscribedSignal: "HV_ECU_SC_Endline_State"),
                      BooleanIndicator(subscribedSignal: "HV_Cell_OT"),
                      CompoundIndicator(firstSignal: "HV_Current", secondSignal: "HV_Voltage_After_AIRs", rule: hvPowerRule, title: "HV Power out"),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 600,
                    width: 900,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Transform.translate(
                          offset: Offset.fromDirection(-0.65 * pi ,450),
                          child:
                            const RotaryIndicator(
                              granularity: 1,
                              numofStates: 12,
                              subscribedSignal: "Rotary1",
                            ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(-0.75 * pi ,260),
                          child:
                            const RotaryIndicator(
                              granularity: 1,
                              numofStates: 12,
                              subscribedSignal: "Rotary3",
                            ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(-0.5 * pi ,50),
                          child:
                            const RotaryIndicator(
                              granularity: 1,
                              numofStates: 12,
                              subscribedSignal: "Rotary5",
                            ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(-0.25 * pi ,260),
                          child:
                            const RotaryIndicator(
                              granularity: 1,
                              numofStates: 12,
                              subscribedSignal: "Rotary4",
                            ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(-0.35 * pi ,450),
                          child:
                            const RotaryIndicator(
                              granularity: 1,
                              numofStates: 12,
                              subscribedSignal: "Rotary2",
                            ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
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
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}