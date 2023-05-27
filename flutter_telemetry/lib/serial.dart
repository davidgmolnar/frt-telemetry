import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
import 'package:universal_io/io.dart';

extension ReadWithOneSecTimeout on SerialPort{
  Uint8List readWithTimeout(int bytes) => read(bytes, timeout: 1000);
}

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

    Uint8List helloWorldMessage =  Uint8List.fromList([0x02, 0x00, 0x0C, 0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x20, 0x57, 0x6F, 0x72, 0x6C, 0x64, 0x21, 0x0F]);
    Timer? timer;

    await for (List<dynamic> msg in isolateReceivePort){
      if(timer != null && timer.isActive){
        timer.cancel();
      }
      if(serial != null && serial.isOpen){
        serial.close();
      }

      serial = SerialPort(msg[0]);
      serial.openReadWrite();
      serial.config = conf;

      timer = Timer.periodic(const Duration(seconds: 1), ((timer) {
        serial?.write(helloWorldMessage);
      }));

      int hostUdpPort = msg[1];
      RawDatagramSocket sock = await RawDatagramSocket.bind(InternetAddress.anyIPv4, msg[2]);

      // Innen python script
      Uint8List batch = Uint8List.fromList([]);

      while(true){
        Uint8List startByte = serial.readWithTimeout(1);
        while(startByte.isNotEmpty && startByte.first != 0x02){
          startByte = serial.readWithTimeout(1);
        }
        Uint8List cmd = serial.readWithTimeout(1);
        if(cmd.isEmpty || cmd.first != 0x81){
          continue;
        }
        Uint8List length = serial.readWithTimeout(1);
        if(length.isEmpty){
          continue;
        }
        Uint8List msg = serial.readWithTimeout(length.first);
        Uint8List rssi = serial.readWithTimeout(1);
        batch.addAll(msg);
        if(batch.length >= 100){
          batch.add(rssi.first);
          sock.send(batch, InternetAddress.anyIPv4, hostUdpPort);
          batch.clear();
        }
      }

    }
  }