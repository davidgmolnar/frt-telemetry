import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:universal_io/io.dart';

bool isconnected = false;
late RawDatagramSocket sock;

Map<String, List<num>> signalValues = {};
Map<String, List<DateTime>> signalTimestamps = {};
Map<String, num> hvCellVoltages = {};
Map<String, num> hvCellTemps = {};

class VirtualSignal {
  const VirtualSignal(this.signals, this.rule, this.name);
  final String name;
  final List<String> signals;
  final Function rule;
}

Future<void> startListener() async {
  sock = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8990);
  sock.port == udpPort ?
    terminalQueue.add(TerminalElement("UDP socket bind successful", 3)) 
    :
    terminalQueue.add(TerminalElement("UDP socket bind failed", 0));
  isconnected = true;
  sockListener();
}

void sockListener(){
  bool initialPacket = true;
  AsciiDecoder decoder = const AsciiDecoder();
  if(isconnected){
    sock.listen((event){
      if(event == RawSocketEvent.read){
        Uint8List? result = sock.receive()?.data;
        if(result != null) {
          Map temp = jsonDecode(decoder.convert(result));
          processPacket(temp);
        }
        else{
          if(!initialPacket){
            terminalQueue.add(TerminalElement("Datagram with no data was received", 2));
          }
        }
        initialPacket = false;
      }
    });
  }
}

void processPacket(Map rawJsonMap){
  rawJsonMap["last_singal_update_cnt"] = rawJsonMap.keys.length;
  for(String key in rawJsonMap.keys){
    if(!signalValues.containsKey(key)){
      signalValues[key] = [];
      signalTimestamps[key] = [];
    }   
    signalValues[key]!.insert(signalValues[key]!.length, rawJsonMap[key]); // TODO itt az add nemtom miért nem jó
    signalTimestamps[key]!.insert(signalTimestamps[key]!.length, DateTime.now());
    if(signalValues[key]!.length > settings['signalValuesToKeep'][0]){
      signalValues[key]!.removeAt(0);
      signalTimestamps[key]!.removeAt(0);
    }
  }
  // process virtual signals
  for(VirtualSignal virtualSignal in virtualSignals){
    if(virtualSignal.signals.every((element) => rawJsonMap.containsKey(element))){
      if(virtualSignal.name == "INDEPENDENT_SIGNAL"){
        virtualSignal.rule(virtualSignal.signals);
        continue;
      }
      if(!signalValues.containsKey(virtualSignal.name)){
        signalValues[virtualSignal.name] = [];
        signalTimestamps[virtualSignal.name] = [];
      }
      signalValues[virtualSignal.name]!.insert(signalValues[virtualSignal.name]!.length, virtualSignal.rule(virtualSignal.signals)); // TODO itt az add nemtom miért nem jó
      signalTimestamps[virtualSignal.name]!.insert(signalTimestamps[virtualSignal.name]!.length, DateTime.now());
      if(signalValues[virtualSignal.name]!.length > settings['signalValuesToKeep'][0]){
        signalValues[virtualSignal.name]!.removeAt(0);
        signalTimestamps[virtualSignal.name]!.removeAt(0);
    }
    }
  }
}