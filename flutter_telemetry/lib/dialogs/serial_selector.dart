import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';
import 'package:flutter_telemetry/serial.dart';

class SerialPortSelectorDialog extends StatelessWidget{
  const SerialPortSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SerialPortSettingElement(name: "Baudrate"),
                SerialPortSettingElement(name: "Bits"),
                SerialPortSettingElement(name: "Stopbits"),
                SerialPortSettingElement(name: "Parity"),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SerialPortSelector(),
                if(SerialPortManager.isOpen())
                  TextButton(onPressed: () => SerialPortManager.kill(), child: const Text("Stop", style: TextStyle(fontSize: subTitleFontSize),))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SerialPortSettingElement extends StatefulWidget {
  const SerialPortSettingElement({super.key, required this.name});

  final String name;

  @override
  State<SerialPortSettingElement> createState() => SerialPortSettingElementState();
}

class SerialPortSettingElementState extends State<SerialPortSettingElement> {
  String input = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String hintText = "";
    switch (widget.name) {
      case "Baudrate":
        hintText = conf.baudRate.toString();
        break;
      case "Bits":
        hintText = conf.bits.toString();
        break;
      case "Stopbits":
        hintText = conf.stopBits.toString();
        break;
      default:
    }
    return Row(
      children: [
        Text(widget.name, style: const TextStyle(fontSize: subTitleFontSize),),
        const Spacer(),
        widget.name != "Parity" ?
        SizedBox(
          width: 100,
          child: TextFormField(
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey)
            ),
            onChanged: (value) {
              input = value;
            },
            controller: controller,
          ),
        )
        :
        SizedBox(
          width: 140,
          child: DropdownButton(
            value: conf.parity,
            items: parityMap.keys.map((e) => 
              DropdownMenuItem(value: e, child: Text(parityMap[e]!))
            ).toList(),
            onChanged: (value) {
              if(value != null){
                conf.parity = value;
                setState(() {});
              }
            }
          ),
        ),
        widget.name != "Parity" ?
        IconButton(
          onPressed: (){
            controller.text = "";
            int? value = int.tryParse(input);
            if(value == null){
              showError(context, "Serial port settings must be integers");
              return;
            }
            switch (widget.name) {
              case "Baudrate":
                conf.baudRate = value;
                break;
              case "Bits":
                conf.bits = value;
                break;
              case "Stopbits":
                conf.stopBits = value;
                break;
              default:
            }
            setState(() {});
          },
          icon: Icon(Icons.check, color: primaryColor,),
          splashRadius: iconSplashRadius,
        )
        :
        const SizedBox()
    ],);
  }
}

class SerialPortSelector extends StatefulWidget {
  const SerialPortSelector({super.key});

  @override
  State<SerialPortSelector> createState() => SerialPortSelectorState();
}

class SerialPortSelectorState extends State<SerialPortSelector> {
  String com = "NOT_SET";

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = SerialPortManager.listAvailablePorts().map((com) => DropdownMenuItem(value: com, child: Text(com, style: const TextStyle(fontSize: subTitleFontSize)))).toList();
    if(items.isEmpty){
      items.add(const DropdownMenuItem(value: "NOT_SET", child: Text("No ports found", style: TextStyle(fontSize: subTitleFontSize),)));
    }
    else{
      items.insert(0, const DropdownMenuItem(value: "NOT_SET", child: Text("Select a port", style: TextStyle(fontSize: subTitleFontSize),)));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 200,
          child: DropdownButton(
            value: "NOT_SET",
            items: items,
            onChanged: (value) {
              if(value != null){
                com = value;
              }
            },
          ),
        ),
        TextButton(
          onPressed: () {
            if(com == "NOT_SET"){
              showError(context, "No port selected");
              return;
            }
            SerialPortManager.startListenerOnPort(com);
          },
          child: const Text("Open", style: TextStyle(fontSize: subTitleFontSize),),
        )
      ],
    );
  }
}