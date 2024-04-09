String assiStateDecoder(num value){
  List<String> map = [
    "AS OFF", "AS READY", "AS DRIVING", "AS FINISHED", "AS EMERGENCY", "UNKNOWN", "UNKNOWN", "UNKNOWN"
  ];
  if(value < map.length && value >= 0){
    return map[value.toInt()];
  }
  else{
    return "INVALID";
  }
}

String missionSelectDecoder(num value){
  List<String> map = [
    "UNKNOWN", "ACCELERATION", "SKIDPAD", "AUTOX", "TRACKDRIVE", "EBS TEST", "INSPECTION", "MANUAL"
  ];
  if(value < map.length && value >= 0){
    return map[value.toInt()];
  }
  else{
    return "INVALID";
  }
}

String asStateDecoder(num value){
  List<String> map = [
    "AS OFF", "MANUAL DRIVING", "AS READY", "AS DRIVING", "AS FINISHED", "EMERGENCY BRAKE", "INITIAL CHECKUP", "UNKNOWN"
  ];
  if(value < map.length && value >= 0){
    return map[value.toInt()];
  }
  else{
    return "INVALID";
  }
}
String carStateDecoder(num value){
  List<String> map = [
    "OFF", "ON", "RTDS", "R2D", "AS ON", "INITIAL CHECKUP", "AS READY", "AS RTDS", "AS DRIVING", "AS EMERGENCY", "AS FINISHED"
  ];
  if(value < map.length && value >= 0){
    return map[value.toInt()];
  }
  else{
    return "INVALID";
  }
}

String initialCheckupStateDecoder(num value){
  List<String> map = [
    "START WATCHDOG", "STOP WATCHDOG", "RESTART WATCHDOG", "WAIT FOR HV", "SWITCH OFF BRAKES", "SWITCH ON EBS1", "SWITCH OFF EBS1", "SWITCH ON EBS2", "SWITCH OFF EBS2", "UNKNOWN", "UNKNOWN", "UNKNOWN", "UNKNOWN", "UNKNOWN", "UNKNOWN", "UNKNOWN"
  ];
  if(value < map.length && value >= 0){
    return map[value.toInt()];
  }
  else{
    return "INVALID";
  }
}

String vdcStateDecoder(num value){
  List<String> map = [
    "INACTIVE", "POWER ON SEQ", "ACTIVE", "TURNING OFF"
  ];
  if(value < map.length && value >= 0){
    return map[value.toInt()];
  }
  else{
    return "INVALID";
  }
}

String raspberryErrorDecoder(num value){
  List<String> map = [
    "UNKNOWN", "UART READ ERROR", "UNKNOWN", "UART INIT ERROR", "SOCKET ERROR", "ADDRESS ERROR", "ADDRINFO ERROR", "TIMEOUT ERROR", "INVALID CAN ID", "DBC INIT ERROR", "CHECKSUM ERROR"
  ];
  if(value < map.length && value >= 0){
    return map[value.toInt()];
  }
  else{
    return "INVALID";
  }
}