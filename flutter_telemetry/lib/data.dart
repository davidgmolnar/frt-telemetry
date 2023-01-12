import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_telemetry/constants.dart';
import 'package:universal_io/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

bool isconnected = false;
late RawDatagramSocket sock;

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

Future<void> startListener() async {
  sock = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8990); // 
  //sock.sink.add("ping");
  isconnected = true;
  sockListener();
}

void sockListener(){
  AsciiDecoder decoder = const AsciiDecoder();
  if(isconnected){
    sock.listen((event){
      Uint8List? result = sock.receive()?.data;
      if(result != null) {
        Map temp = jsonDecode(decoder.convert(result));
        processPacket(temp);
      }
      else{
        print("fuck");
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