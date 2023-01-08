String assiStateDecoder(num value){
  List<String> map = [
    "AS OFF", "AS READY", "AS DRIVING", "AS FINISHED", "AS EMERGENCY", "UNKNOWN", "UNKNOWN", "UNKNOWN"
  ];
  if(value < map.length){
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
  if(value < map.length){
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
  if(value < map.length){
    return map[value.toInt()];
  }
  else{
    return "INVALID";
  }
}