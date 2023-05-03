import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/indicators/as_map.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:universal_io/io.dart';

bool isconnected = false;
late RawDatagramSocket sock;

Map<String, List<num>> signalValues = {};
Map<String, List<DateTime>> signalTimestamps = {};
Map<String, num> hvCellVoltages = {};
Map<String, num> hvCellTemps = {};
List<num> lapHVCurrent = [];
Map<String, Cone> conesOnTrack = {};
Size trackSize = const Size(255, 255);

bool needsTruncate = false;
int turncateTo = 0;

class VirtualSignal {
  const VirtualSignal(this.signals, this.rule, this.name);
  final String name;
  final List<String> signals;
  final Function rule;
}

Future<void> startListener() async {
  sock = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4, settings["listenPort"]![0]);
  sock.port == settings["listenPort"]![0]
      ? terminalQueue.add(TerminalElement(
          "UDP socket bind successful on port ${settings['listenPort']![0]}",
          3))
      : terminalQueue.add(TerminalElement(
          "UDP socket bind failed on port ${settings['listenPort1']![0]}", 0));
  isconnected = true;
  sockListener();
}

void sockListener() {
  bool initialPacket = true;
  AsciiDecoder decoder = const AsciiDecoder();
  if (isconnected) {
    sock.listen((event) {
      if (event == RawSocketEvent.read) {
        Uint8List? result = sock.receive()?.data;
        if (result != null) {
          try {
            Map temp = jsonDecode(decoder.convert(result));
            processPacket(temp);
          } catch (exc) {
            terminalQueue.add(TerminalElement(
                "Error in processing, data was ${decoder.convert(result)}", 2));
          }
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
  for (String key in rawJsonMap.keys) {
    if (!signalValues.containsKey(key)) {
      signalValues[key] = [];
      signalTimestamps[key] = [];
    }
    signalValues[key]!.insert(signalValues[key]!.length, rawJsonMap[key]);
    signalTimestamps[key]!
        .insert(signalTimestamps[key]!.length, DateTime.now());
    if (signalValues[key]!.length > settings['signalValuesToKeep']![0]) {
      signalValues[key]!.removeAt(0);
      signalTimestamps[key]!.removeAt(0);
    }
  }
  // process virtual signals
  for (VirtualSignal virtualSignal in virtualSignals) {
    if (virtualSignal.signals
        .every((element) => rawJsonMap.containsKey(element))) {
      if (virtualSignal.name == "INDEPENDENT_SIGNAL") {
        virtualSignal.rule(virtualSignal.signals);
        continue;
      }
      if (!signalValues.containsKey(virtualSignal.name)) {
        signalValues[virtualSignal.name] = [];
        signalTimestamps[virtualSignal.name] = [];
      }
      signalValues[virtualSignal.name]!.insert(
          signalValues[virtualSignal.name]!.length,
          virtualSignal.rule(virtualSignal.signals));
      signalTimestamps[virtualSignal.name]!
          .insert(signalTimestamps[virtualSignal.name]!.length, DateTime.now());
      if (signalValues[virtualSignal.name]!.length >
          settings['signalValuesToKeep']![0]) {
        signalValues[virtualSignal.name]!.removeAt(0);
        signalTimestamps[virtualSignal.name]!.removeAt(0);
      }
    }
  }
  if (needsTruncate) {
    truncateData(turncateTo);
  }
}

void truncateData(int limit) {
  needsTruncate = false;
  for (String signal in signalValues.keys) {
    if (signalValues[signal]!.length > limit) {
      signalValues[signal] = signalValues[signal]!
          .sublist(signalValues[signal]!.length - limit - 1);
    }
    if (signalTimestamps[signal]!.length > limit) {
      signalTimestamps[signal] = signalTimestamps[signal]!
          .sublist(signalTimestamps[signal]!.length - limit - 1);
    }
  }
}

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
