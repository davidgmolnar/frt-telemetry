import 'dart:ui';
import 'dart:typed_data';
import 'package:dart_dbc_parser/dart_dbc_parser.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/indicators/as_map.dart';
import 'package:universal_io/io.dart';

bool isconnected = false;
late RawDatagramSocket sock;
late DBCDatabase can;

Map<String, List<num>> signalValues = {};
Map<String, List<DateTime>> signalTimestamps = {};
Map<String, num> hvCellVoltages = {};
Map<String, num> hvCellTemps = {};
List<num> lapHVCurrent = [];
Map<String, Cone> conesOnTrack = {};
Size trackSize = const Size(409.5 , 409.5);
Offset trackOffset = const Offset(205.25, 205.25);

// ignore: constant_identifier_names
const int _STORAGE_BUFFER_MINUTES = 3;

Function lapTriggerCallback = (){};

List<Uint8List> logBuffer = [];
bool _logBufferFlushing = false;
bool doLog = false;

class VirtualSignal {
  const VirtualSignal(this.signals, this.rule, this.name);
  final String name;
  final List<String> signals;
  final Function rule;
}

Future<void> startListener() async {
  sock = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4, settings["listenPort"]!.value);
  if(sock.port == settings["listenPort"]!.value){
      terminalQueue.add(TerminalElement(
          "UDP socket bind successful on port ${settings['listenPort']!.value}",3));
      isconnected = true;
      try{
        can = await DBCDatabase.loadFromFile(canPathList.map((e) => File(e)).toList());
        if(can.database.keys.isEmpty){
          throw Exception();
        }
      }
      catch (exc) {
        terminalQueue.add(TerminalElement("Failed to load dbc",0));
      }
      sockListener();
  }
  else{
      terminalQueue.add(TerminalElement(
          "UDP socket bind failed on port ${settings['listenPort']!.value}", 0));
  }
}

void sockListener() {
  bool initialPacket = true;
  //AsciiDecoder decoder = const AsciiDecoder();
  if (isconnected) {
    sock.listen((event) {
      if (event == RawSocketEvent.read) {
        Uint8List? udpPayload = sock.receive()?.data;
        if (udpPayload != null && udpPayload.isNotEmpty) {
          /*
          try {
            Map decoded = jsonDecode(decoder.convert(udpPayload));
            processPacket(decoded);
          } catch (exc) {
            try{
            terminalQueue.add(TerminalElement(
                "Error in processing, data was ${decoder.convert(udpPayload)}", 2));
            } catch (exc2) {
            terminalQueue.add(TerminalElement(
                "Error in processing, received payload was not ascii-decodeable", 2));
            }
          }
          */
          if(doLog){
            logCallback(udpPayload);
          }
          Map<String, num> decoded = can.decode(udpPayload);
          decoded["rssi"] = udpPayload.last.toSigned(8);
          processPacket(decoded);

        } else {
          if (!initialPacket) {
            terminalQueue
                .add(TerminalElement("Datagram with no data was received", 2));
          }
        }
        initialPacket = false;
      }
    });
  }
}

void processPacket(Map rawJsonMap) {
  rawJsonMap["last_singal_update_cnt"] = rawJsonMap.keys.length;
  DateTime storageDateTimeLimit = DateTime.now().subtract(Duration(minutes: settings['signalValuesToKeep']!.value + _STORAGE_BUFFER_MINUTES));
  DateTime storageDateTimeLimitExact = DateTime.now().subtract(Duration(minutes: settings['signalValuesToKeep']!.value));
  for (String key in rawJsonMap.keys) {
    if (!signalValues.containsKey(key)) {
      signalValues[key] = [];
      signalTimestamps[key] = [];
    }
    signalValues[key]!.insert(signalValues[key]!.length, rawJsonMap[key]);
    signalTimestamps[key]!.insert(signalTimestamps[key]!.length, DateTime.now());
    if (signalTimestamps[key]!.first.isBefore(storageDateTimeLimit)) {
      signalTimestamps[key] = signalTimestamps[key]!.skipWhile((value) => value.isBefore(storageDateTimeLimitExact)).toList();
      signalValues[key]!.removeRange(0, signalValues[key]!.length - signalTimestamps[key]!.length);
    }
  }
  // process virtual signals
  for (VirtualSignal virtualSignal in virtualSignals) {
    if (virtualSignal.signals.every((element) => rawJsonMap.containsKey(element))) {
      if (virtualSignal.name == "INDEPENDENT_SIGNAL") {
        virtualSignal.rule(virtualSignal.signals);
        continue;
      }
      if (!signalValues.containsKey(virtualSignal.name)) {
        signalValues[virtualSignal.name] = [];
        signalTimestamps[virtualSignal.name] = [];
      }
      signalValues[virtualSignal.name]!.insert(signalValues[virtualSignal.name]!.length, virtualSignal.rule(virtualSignal.signals));
      signalTimestamps[virtualSignal.name]!.insert(signalTimestamps[virtualSignal.name]!.length, DateTime.now());
      if (signalTimestamps[virtualSignal.name]!.first.isBefore(storageDateTimeLimit)) {
        signalTimestamps[virtualSignal.name] = signalTimestamps[virtualSignal.name]!.skipWhile((value) => value.isBefore(storageDateTimeLimitExact)).toList();
        signalValues[virtualSignal.name]!.removeRange(0, signalValues[virtualSignal.name]!.length - signalTimestamps[virtualSignal.name]!.length);
      }
    }
  }

  for(TelemetryAlert alert in alerts){
    if(rawJsonMap.containsKey(alert.signal)){
      alert.risingEdge();
    }
  }

  /*if(useAutoTrigger){
    // if next lap
    lapTriggerCallback();
  }*/
}

void logCallback(Uint8List udpBuffer){
  Uint8List logEntry = Uint8List(4);
  logEntry.buffer.asByteData(0, 4).setUint32(0, udpBuffer.length);
  logEntry = Uint8List.fromList(logEntry.toList()..addAll(udpBuffer));
  Uint8List timestamp = Uint8List(8);
  timestamp.buffer.asByteData(0, 8).setUint64(0, DateTime.now().difference(appstartdate).inMilliseconds);
  logEntry = Uint8List.fromList(logEntry.toList()..addAll(timestamp));
  logBuffer.add(logEntry);
  if(logBuffer.length > 1000 && !_logBufferFlushing){
    _logBufferFlushing = true;
    logBufferFlushAsync();
  }
}

Future<void> logBufferFlushAsync() async {
  File log = File("$dir/telemetry_log.bin");
  RandomAccessFile access;
  if(await log.exists()){
    access = await log.open(mode: FileMode.append);
  }
  else{
    access = await log.open(mode: FileMode.write);
  }
  int loglength = logBuffer.length;
  for(int i = 0; i < loglength; i++){
    await access.writeFrom(logBuffer[i]);
  }
  logBuffer.removeRange(0, loglength);
  await access.close();
  _logBufferFlushing = false;
}

/*
//
// Isolate based Data service
//

class DataRequest {
  const DataRequest(this.signalRequests, this.sender);
  final List<SignalRequest> signalRequests;
  final ReceivePort sender;
}

class SignalRequest {
  const SignalRequest(this.signal, this.lastOnly, this.withTimestamps,
      this.currentChartData, this.targetLength, this.multiplier);
  final String signal;
  final bool lastOnly;
  final bool withTimestamps;
  final List<WaveformChartElement>?
      currentChartData; // ebbe csak akkor kell belenézni ha withtimestamps
  final int? targetLength;
  final int? multiplier;
}

class SignalData {
  // ha kiadja hogy lastonly-ra iratkoznak fel a widgetek akkor ezen lehet egyszerűsíteni
  const SignalData(
      this.signalValue, this.signalValues, this.chartData, this.updatedNum);
  final num? signalValue;
  final List<num>? signalValues;
  final List<WaveformChartElement>? chartData;
  final int? updatedNum;
}

class DataResponse {
  const DataResponse(this.success, this.signalData);
  final bool success;
  final List<SignalData> signalData;
}

// constants
final ReceivePort dataServiceReceivePort = ReceivePort();
final SendPort dataService =
    dataServiceReceivePort.sendPort; // indikátor erre küld
// constants

//global
Isolate? dataServiceIsolate;
//global

Future<void> startDataService() async {
  dataServiceIsolate =
      await Isolate.spawn(dataHandling, dataServiceReceivePort);
}

void stopDataService() {
  dataServiceIsolate?.kill();
}

Future<void> dataHandling(ReceivePort requests) async {
  startListener();
  await for (DataRequest request in requests) {
    bool success = true;
    List<SignalData>? signalData = request.signalRequests.map((signalRequest) {
      if (signalRequest.signal == "STOP") {
        Isolate.exit();
      }
      if (signalRequest.lastOnly && !signalRequest.withTimestamps) {
        // sima indikátorok
        return SignalData(
            signalValues[signalRequest.signal]?.last, null, null, null);
      } else if (signalRequest.lastOnly && signalRequest.withTimestamps) {
        // chart most recent only mode
        List<WaveformChartElement> tmp =
            signalRequest.currentChartData!.sublist(1); // TODO nem kell másolni
        tmp.add(WaveformChartElement(signalValues[signalRequest.signal]!.last,
            signalTimestamps[signalRequest.signal]!.last));
        return SignalData(null, null, tmp, 1);
      } else if (signalRequest.lastOnly && !signalRequest.withTimestamps) {
        // invalid
        success = false;
        return const SignalData(null, null, null, null);
      } else {
        // chart initial load mode
        List<WaveformChartElement> tmp =
            signalRequest.currentChartData!; // TODO nem kell másolni
        List? tempVal = signalValues[signalRequest.signal];
        List<DateTime>? tempTime = signalTimestamps[signalRequest.signal];
        int newDataStartIdx = tempTime!.length - 1;
        while (tempTime[newDataStartIdx].isAfter(tmp.last.time)) {
          newDataStartIdx--;
        }
        newDataStartIdx++;
        int added = 0;
        while (newDataStartIdx < tempTime.length) {
          tmp.add(WaveformChartElement(
              signalRequest.multiplier! * tempVal![newDataStartIdx],
              tempTime[newDataStartIdx]));
          if (tmp.length > signalRequest.targetLength!) {
            tmp.removeAt(0);
          }
          added++;
          newDataStartIdx++;
        }
        return SignalData(null, null, tmp, added);
      }
    }).toList();
    request.sender.sendPort.send(DataResponse(success, signalData));
  }
}
*/