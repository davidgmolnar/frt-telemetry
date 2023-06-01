import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
import 'package:universal_io/io.dart';

  SerialPortConfig conf = SerialPortConfig()
  ..baudRate = 460800
  ..stopBits = 1
  ..parity = SerialPortParity.none
  ..bits = 8;

extension ReadWithOneSecTimeout on SerialPort{
  Future<Uint8List> readWithTimeout(int bytes) => Future.delayed(const Duration(microseconds: 100), () {return read(bytes);});
}

class SerialPortManager{

  static Isolate? _isolate;

  static List<String> listAvailablePorts() {
    return SerialPort.availablePorts;
  }

  static Future<bool> startListenerOnPort(String com) async {
    if(_isolate != null){
      kill();
    }
    try{
      _isolate = await Isolate.spawn(_isolateCycle, com).timeout(const Duration(milliseconds: 1000));
      return true;
    }
    catch (exc){
      return false;
    }
  }

  static void kill() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }
}

void _isolateCycle(String com) async {
  Uint8List helloWorldMessage =  Uint8List.fromList([0x02, 0x00, 0x0C, 0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x20, 0x57, 0x6F, 0x72, 0x6C, 0x64, 0x21, 0x0F]);

  SerialPort serial = SerialPort(com);
  serial.openReadWrite();
  serial.config = conf;

  int hostUdpPort = settings['listenPort']!.value;
  List<RawDatagramSocket> socks = [];
  List<NetworkInterface> intfs = await NetworkInterface.list();
  for (NetworkInterface intf in intfs) {
    if(intf.addresses.first.address.isEmpty || intf.addresses.first.address.startsWith("10.")){
      continue;
    }
    socks.add(await RawDatagramSocket.bind(intf.addresses.first, hostUdpPort + 1)..broadcastEnabled = true);
  }

  Timer.periodic(const Duration(seconds: 1), ((timer) {
    serial.write(helloWorldMessage);
  }));

  // Innen python script
  Uint8List batch = Uint8List.fromList([]);

  while(true) {
    Uint8List startByte = await serial.readWithTimeout(1);
    while(startByte.isEmpty || startByte.first != 0x02){
      startByte = await serial.readWithTimeout(1);
    }
    Uint8List cmd = await serial.readWithTimeout(1);
    if(cmd.isEmpty || cmd.first != 0x81){
      continue;
    }
    Uint8List length = await serial.readWithTimeout(1);
    if(length.isEmpty){
      continue;
    }
    Uint8List msg = await serial.readWithTimeout(length.first);
    Uint8List rssi = await serial.readWithTimeout(1);
    batch = Uint8List.fromList(batch.toList()..addAll(msg.toList()));
    if(batch.length >= 100){
      batch = Uint8List.fromList(batch.toList()..add(rssi.first));
      for (RawDatagramSocket sock in socks) {
        sock.send(batch, InternetAddress("255.255.255.255"), hostUdpPort);
      }
      batch = Uint8List.fromList([]);
    }
  }
}