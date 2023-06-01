import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/serial.dart';

class SerialPortSelectorDialog extends StatefulWidget{
  const SerialPortSelectorDialog({super.key});

  @override
  State<StatefulWidget> createState() {
    return SerialPortSelectorDialogState();
  }
}

class SerialPortSelectorDialogState extends State<SerialPortSelectorDialog>{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Baudrate", style: TextStyle(fontSize: subTitleFontSize),),
                  Text(conf.baudRate.toString())
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Bits", style: TextStyle(fontSize: subTitleFontSize),),
                  Text(conf.bits.toString())
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Stopbits", style: TextStyle(fontSize: subTitleFontSize),),
                  Text(conf.stopBits.toString())
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Parity", style: TextStyle(fontSize: subTitleFontSize),),
                  Text(conf.parity.toString())
              ],)
            ],
          )
        ],
      ),
    );
  }

}