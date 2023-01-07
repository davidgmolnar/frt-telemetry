import 'dart:convert';

import 'package:flutter_telemetry/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

bool isconnected = false;
late WebSocketChannel sock;

Map<String, List<dynamic>> signalValues = {
  //"Bosch_yaw_rate": [],
  //"Vectornav_yaw_rate_rear_value": [],
  //"Xavier_orientation": [],
};

Map<String, List<DateTime>> signalTimestamps = {
  //"Bosch_yaw_rate": [],
  //"Vectornav_yaw_rate_rear_value": [],
  //"Xavier_orientation": [],
};

void startListener(){
  sock = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8990'),); // 
  sock.sink.add("ping");
  isconnected = true;
  sockListener();
}

void sockListener(){
  if(isconnected){
    sock.stream.listen((buffer){
      String result = buffer.toString();
      if(result.isNotEmpty) {
        Map temp = jsonDecode(result);
        processPacket(temp);
      }
    });
  }
}

void processPacket(Map rawJsonMap){
  for(String key in rawJsonMap.keys){
    if(!signalValues.containsKey(key)){
      signalValues[key] = [];
      signalTimestamps[key] = [];
    }   
    signalValues[key]!.insert(signalValues[key]!.length, rawJsonMap[key]);
    signalTimestamps[key]!.insert(signalTimestamps[key]!.length, DateTime.now());
    if(signalValues[key]!.length > signalValuesToKeep){
      signalValues[key]!.removeAt(0);
      signalTimestamps[key]!.removeAt(0);
    }
    else{
      //print("No such signal");
    }
  }
}