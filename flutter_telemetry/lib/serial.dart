import 'dart:isolate';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
import 'package:universal_io/io.dart';

class SerialPortManager{

  static final SerialPortManager _instance = SerialPortManager._internal();
  // Ahol a host fogad
  static final ReceivePort _hostReceivePort = ReceivePort();
  // Ahol a host küld
  static SendPort? _hostSendPort;

  static Isolate? _isolate;

  SerialPortManager._internal();

  factory SerialPortManager(){
    return _instance;
  }

  List<String> listAvailablePorts() {
    return SerialPort.availablePorts;
  }

  Future<bool> startListenerOnPort(String com) async {
    if(_isolate != null){
      kill();
    }
    try{
      _isolate = await Isolate.spawn(_isolateCycle, _hostReceivePort.sendPort).timeout(const Duration(milliseconds: 1000));
      _hostSendPort = await _hostReceivePort.first.timeout(const Duration(milliseconds: 1000));
      _hostSendPort?.send([com, settings["listenPort"]!.value, settings["listenPort"]!.value + 1]);
      return true;
    }
    catch (exc){
      return false;
    }
  }

  void kill() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _hostSendPort = null;
  }
}

void _isolateCycle(SendPort isolateSendPort) async {
    final ReceivePort isolateReceivePort = ReceivePort();
    isolateSendPort.send(isolateReceivePort.sendPort);

    SerialPort? serial;
    SerialPortConfig conf = SerialPortConfig();
    conf.baudRate = 460800;
    conf.stopBits = 1;
    conf.parity = SerialPortParity.none;
    conf.bits = 8;

    await for (List<dynamic> msg in isolateReceivePort){
      serial = SerialPort(msg[0]);
      serial.openReadWrite();
      serial.config = conf;

      int hostUdpPort = msg[1];      
      RawDatagramSocket sock = await RawDatagramSocket.bind(InternetAddress.anyIPv4, msg[2]);

      while(true){
        //naez
      }

    }
  }