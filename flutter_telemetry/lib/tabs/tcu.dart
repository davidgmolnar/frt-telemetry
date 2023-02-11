import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

/*class TCUTab extends StatefulWidget{
  const TCUTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return TCUTabState();
  }
}

class TCUTabState extends State<TCUTab>{
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
    return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor,
            toolbarHeight: 50,
            elevation: 0,
            actions: const [],
          ),
          body: isSmall ?
            // Small layout
            Container(color: Colors.red,)
            : // Big layout
            ListView(
              controller: _controller,
              children: [
                Row(
                  children: const [
                    NumericPanel(
                      title: "AMK data",
                      colsize: 4,
                      subscribedSignals: [
                        "AMK1_Torque_Limit_Positive",
                        "AMK1_Torque_Limit_Negative",
                        "AMK1_Target_Velocity",
                        "VDC_Fz_FL",
                        "AMK2_Torque_Limit_Positive",
                        "AMK2_Torque_Limit_Negative",
                        "AMK2_Target_Velocity",
                        "VDC_Fz_FR",
                        "AMK3_TorqueLimitPositive",
                        "AMK3_TorqueLimitNegative",
                        "AMK3_Target_Velocity",
                        "VDC_Fz_RL",
                        "AMK4_TorqueLimitPositive",
                        "AMK4_TorqueLimitNegative",
                        "AMK4_Target_Velocity",
                        "VDC_Fz_RR",
                      ],
                    )
                  ],
                ),
                const WaveformChart(
                  subscribedSignals: ["VIRT_AMK1_LIMIT", "VIRT_AMK2_LIMIT", "VIRT_AMK3_LIMIT", "VIRT_AMK4_LIMIT"], nultiplier: [1,2,1,1],
                  title: "Torque Limits", min: 0, max: 25000,
                ),
                Row(
                  children: const [
                    BooleanPanel(
                      subscribedSignals: [
                        "VDC_Powerlimiter_Hardcore_On",
                        "VDC_Powerlimiter_Throttle_On",
                        "VDC_Powerlimiter_Torque_On",
                        "VDC_Powerlimiter_Efficiency_On",
                        "VDC_Slip_Control_ON",
                        "VDC_Traction_Control_On",
                        "VDC_Safety_Mode",
                      ],
                      colsize: 7, title: "VDC Status"
                    ),
                  ],
                ),
                Row(
                  children: const [
                    SizedBox(
                      width: 600,
                      child: WaveformChart(
                        subscribedSignals: ["VDC_Torque_Demand"], nultiplier: [1],
                        title: "Torque demand", min: 0, max: 300,
                      ),
                    ),
                    SizedBox(
                      width: 600,
                      child: WaveformChart(
                        subscribedSignals: ["Xavier_Target_Wheel_Angle"], nultiplier: [180/pi],
                        title: "Target steer °", min: -90, max: 90,
                      ),
                    )
                  ]
                ),
              ],
            )
        )
    );
  }

  @override
  void dispose() {
    timer.cancel(); 
    super.dispose();
  }
}*/

List<Widget> tcuBig = [
                Row(
                  children: const [
                    NumericPanel(
                      title: "AMK data",
                      colsize: 4,
                      subscribedSignals: [
                        "AMK1_Torque_Limit_Positive",
                        "AMK1_Torque_Limit_Negative",
                        "AMK1_Target_Velocity",
                        "VDC_Fz_FL",
                        "AMK2_Torque_Limit_Positive",
                        "AMK2_Torque_Limit_Negative",
                        "AMK2_Target_Velocity",
                        "VDC_Fz_FR",
                        "AMK3_TorqueLimitPositive",
                        "AMK3_TorqueLimitNegative",
                        "AMK3_Target_Velocity",
                        "VDC_Fz_RL",
                        "AMK4_TorqueLimitPositive",
                        "AMK4_TorqueLimitNegative",
                        "AMK4_Target_Velocity",
                        "VDC_Fz_RR",
                      ],
                    )
                  ],
                ),
                const WaveformChart(
                  subscribedSignals: ["VIRT_AMK1_LIMIT", "VIRT_AMK2_LIMIT", "VIRT_AMK3_LIMIT", "VIRT_AMK4_LIMIT"], multiplier: [1,2,1,1],
                  title: "Torque Limits", min: 0, max: 25000,
                ),
                Row(
                  children: const [
                    BooleanPanel(
                      subscribedSignals: [
                        "VDC_Powerlimiter_Hardcore_On",
                        "VDC_Powerlimiter_Throttle_On",
                        "VDC_Powerlimiter_Torque_On",
                        "VDC_Powerlimiter_Efficiency_On",
                        "VDC_Slip_Control_ON",
                        "VDC_Traction_Control_On",
                        "VDC_Safety_Mode",
                      ],
                      colsize: 7, title: "VDC Status"
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Flexible(
                      child: WaveformChart(
                        subscribedSignals: ["VDC_Torque_Demand"], multiplier: [1],
                        title: "Torque demand", min: 0, max: 300,
                      ),
                    ),
                    Flexible(
                      child: WaveformChart(
                        subscribedSignals: ["Xavier_Target_Wheel_Angle"], multiplier: [180/pi],
                        title: "Target steer °", min: -90, max: 90,
                      ),
                    )
                  ]
                ),
              ];

List<Widget> tcuSmall = [];