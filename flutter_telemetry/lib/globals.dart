import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/indicators/as_map.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

String activeTab = "CONFIG";
String dir = "";
bool isFullScreen = false;
late BuildContext tabContext;

List<String> canPathList = [];

List<Color> coneColors = [Colors.orange, Colors.purple, Colors.red, Colors.yellow, Colors.blue];

Color primaryColor = primaryColorDark;
Color secondaryColor = secondaryColorDark;
Color bgColor = bgColorDark;
Color textColor = textColorDark;

List<TerminalElement> terminalQueue = []; // ide mindenki pakol akárhonnan
int displayLevel = 3;

List<TelemetryAlert> alerts =
    []; // ide csak a config tab pakol, és a mainscreen nézi hogy mi van

DateTime? lastBrightloopMAH;
DateTime appstartdate = DateTime.now();

// TODO ennek editor
List<double> tempBrakepoints = [
  -double.infinity,
  1,
  20,
  30,
  35,
  40,
  45,
  50,
  double.infinity
];
List<Color> tempColorBank = [
  Colors.white,
  Colors.blue,
  Colors.green.shade800,
  Colors.yellow,
  Colors.orange.shade800,
  const Color.fromARGB(255, 255, 17, 0),
  Colors.purple,
  Colors.black
];

DateTime lapStart = DateTime.now();
bool lapTimerStarted = false;
bool useAutoTrigger = false;
List<LapData> lapData = [];

List<VirtualSignal> virtualSignals = [
  VirtualSignal(["AMK1_Torque_Limit_Positive", "AMK1_Torque_Limit_Negative"],
      ((listOfSignals) {
    dynamic first = signalValues[listOfSignals[0]]!.last;
    dynamic second = signalValues[listOfSignals[1]]!.last;
    if (first == 0) {
      return second;
    }
    return first;
  }), "VIRT_AMK1_LIMIT"),
  VirtualSignal(["AMK2_Torque_Limit_Positive", "AMK2_Torque_Limit_Negative"],
      ((listOfSignals) {
    dynamic first = signalValues[listOfSignals[0]]!.last;
    dynamic second = signalValues[listOfSignals[1]]!.last;
    if (first == 0) {
      return second;
    }
    return first;
  }), "VIRT_AMK2_LIMIT"),
  VirtualSignal(["AMK3_TorqueLimitPositive", "AMK3_TorqueLimitNegative"],
      ((listOfSignals) {
    dynamic first = signalValues[listOfSignals[0]]!.last;
    dynamic second = signalValues[listOfSignals[1]]!.last;
    if (first == 0) {
      return second;
    }
    return first;
  }), "VIRT_AMK3_LIMIT"),
  VirtualSignal(["AMK4_TorqueLimitPositive", "AMK4_TorqueLimitNegative"],
      ((listOfSignals) {
    dynamic first = signalValues[listOfSignals[0]]!.last;
    dynamic second = signalValues[listOfSignals[1]]!.last;
    if (first == 0) {
      return second;
    }
    return first;
  }), "VIRT_AMK4_LIMIT"),
  VirtualSignal(["HV_Current", "HV_Voltage_After_AIRs"], ((listOfSignals) {
    dynamic first = signalValues[listOfSignals[0]]!.last;
    dynamic second = signalValues[listOfSignals[1]]!.last;
    return first * second;
  }), "VIRT_HV_POWER_OUT"),
  VirtualSignal(["APPS1_validity", "APPS2_validity"], ((listOfSignals) {
    int first = signalValues[listOfSignals[0]]!.last.toInt();
    int second = signalValues[listOfSignals[1]]!.last.toInt();
    return first * second; // bool and
  }), "VIRT_APPS_VALID"),
  VirtualSignal(["STA1_validity", "STA1_validity"], ((listOfSignals) {
    int first = signalValues[listOfSignals[0]]!.last.toInt();
    int second = signalValues[listOfSignals[1]]!.last.toInt();
    return first * second; // bool and
  }), "VIRT_STA_VALID"),
  VirtualSignal(["APPS1_position", "APPS2_posiition"], ((listOfSignals) {
    dynamic first = signalValues[listOfSignals[0]]!.last;
    dynamic second = signalValues[listOfSignals[1]]!.last;
    return (first + second) / 2;
  }), "VIRT_AVG_APPS"),
  VirtualSignal(["STA1_position", "STA2_position"], ((listOfSignals) {
    dynamic first = signalValues[listOfSignals[0]]!.last;
    dynamic second = signalValues[listOfSignals[1]]!.last;
    return (first + second) / 2;
  }), "VIRT_AVG_STA"),
  VirtualSignal(["Yaw_Rate_Vectornav"], ((listOfSignals) {
    num val = signalValues[listOfSignals[0]]!.last;
    return val * deg2rad;
  }), "VIRT_ACC_FRONT_YAW_RAD"),
  VirtualSignal(["Xavier_Target_Wheel_Angle"], ((listOfSignals) {
    num val = signalValues[listOfSignals[0]]!.last;
    return val / deg2rad;
  }), "VIRT_XAVIER_TARGET_ANGLE_DEG"),
  VirtualSignal(["VDCDCOutput1Average", "IDCDCOutput1Average"],
      ((listOfSignals) {
    dynamic first = signalValues[listOfSignals[0]]!.last;
    dynamic second = signalValues[listOfSignals[1]]!.last;
    return first * second;
  }), "VIRT_BRIGHTLOOP_CH1_POWER"),
  VirtualSignal(["VDCDCOutput1Average", "IDCDCOutput1Average"],
      ((listOfSignals) {
    dynamic first = signalValues[listOfSignals[0]]!.last;
    dynamic second = signalValues[listOfSignals[1]]!.last;
    return first * second;
  }), "VIRT_BRIGHTLOOP_CH2_POWER"),
  VirtualSignal(["NDCDCOutputOverload1Count m4", "NDCDCOutputOverload2Count m4"],
      ((listOfSignals) {
    dynamic first = signalValues[listOfSignals[0]]!.last;
    dynamic second = signalValues[listOfSignals[1]]!.last;
    return first + second;
  }), "VIRT_BRIGHTLOOP_OLC"),
  VirtualSignal(["IDCDCOutput1Average", "IDCDCOutput2Average"],
      ((listOfSignals) {
    dynamic i_1 = signalValues[listOfSignals[0]]?.last;
    dynamic i_2 = signalValues[listOfSignals[1]]?.last;
    if (i_1 == null || i_2 == null) {
      return 0;
    }
    if (lastBrightloopMAH == null) {
      lastBrightloopMAH = DateTime.now();
      return 0;
    } else {
      DateTime now = DateTime.now();
      double diffmH = now.difference(lastBrightloopMAH!).inMilliseconds /
          3600; // milliHours
      lastBrightloopMAH = now;
      return signalValues["VIRT_BRIGHTLOOP_LV_MAH"]!.last +
          diffmH * (i_1 + i_2);
    }
  }), "VIRT_BRIGHTLOOP_LV_MAH"),
  VirtualSignal(["HV_Cell_ID", "HV_Cell_Voltage", "HV_Cell_Temperature"],
      ((listOfSignals) {
    hvCellTemps[signalValues[listOfSignals[0]]!.last.toInt().toString()] =
        signalValues[listOfSignals[2]]!.last;
    hvCellVoltages[signalValues[listOfSignals[0]]!.last.toInt().toString()] =
        signalValues[listOfSignals[1]]!.last;
  }), "INDEPENDENT_SIGNAL"),
  VirtualSignal(["HV_Current"], ((listOfSignals) {
    if (lapTimerStarted) {
      if (lapHVCurrent.length < 4320000) {
        // 12 hours worth of data at 100Hz  ~ 34 MB
        lapHVCurrent.add(signalValues[listOfSignals[0]]!.last);
      } else {
        terminalQueue.add(TerminalElement("Elaludtál he", 0)); // lmao
      }
    }
  }), "INDEPENDENT_SIGNAL"),
  VirtualSignal([
    "Xavier_landmark_id",
    "Xavier_landmark_x",
    "Xavier_landmark_y",
    "Xavier_landmark_color"
  ], ((listOfSignals) {
    String id = signalValues[listOfSignals[0]]!.last.toString();
    num x = signalValues[listOfSignals[1]]!.last;
    num y = signalValues[listOfSignals[2]]!.last;
    Color col;
    num colId = signalValues[listOfSignals[3]]!.last;
    switch (colId) {
      case 0:
        col = Colors.blue;
        break;
      case 1:
        col = Colors.yellow;
        break;
      case 2:
        col = Colors.red;
        break;
      case 3:
        col = Colors.orange;
        break;
      default:
        col = Colors.purple;
        break;
    }
    conesOnTrack[id] = Cone(Offset(x.toDouble(), y.toDouble()), col);
    //print(x.toDouble().toString() + y.toDouble().toString() + col.toString());
  }), "INDEPENDENT_SIGNAL")
];

// live settings  [val, min, max]
/*Map<String, List<int>> settings = {
  "refreshTimeMS": [100, 50, 2000],
  "chartrefreshTimeMS": [16, 5, 2000],
  "signalValuesToKeep": [8192, 128, 32768],
  "chartShowSeconds": [40, 1, 180],
  "listenPort": [8998, 1000, 65535],
  "scrollCache": [200, 0, 2000]
};
*/

// [signals concatenated] = (setting)
Map<String,ChartSetting> chartSettings = {};

int tooltipShowMs = 0;
int tooltipWaitMs = 1000;
