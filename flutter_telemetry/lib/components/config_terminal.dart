import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';

const Map<int, String> displayIdLevelMap = {
  0: "Critical",
  1: "Error",
  2: "Warning",
  3: "Info",
  4: "Debug"
};

const int terminalWidth = 700;

class TerminalElement{
  final String message;
  final int level; // 0 Critical, 1 Error, 2 Warn, 3 Info, 4 Debug
  final DateTime time = DateTime.now();

  TerminalElement(this.message, this.level);
}

class TerminalDisplay extends StatefulWidget {
  const TerminalDisplay({
    super.key
    });

  @override
  State<TerminalDisplay> createState() => TerminalDisplayState();
}

// Csak azokat a msgket jeleníti meg amiknek a levele <= mint a displaylevel + nem is jönnek létre máshol azok a msgek, globálban ez elérhető
class TerminalDisplayState extends State<TerminalDisplay> {
  List<TerminalElement> content = [];
  late Timer timer;

  @override
  void initState() {
    super.initState();
    content = terminalQueue;
    timer = Timer.periodic(const Duration(milliseconds: 200), (Timer t) => update());
  }

  void update(){
    if(terminalQueue.isNotEmpty){
      int len = terminalQueue.length; // ha ennek futása közben még nőne a lista az csak a kövi körben lesz megjelenítve
      for(int i = 0; i < len; i++){
        if(terminalQueue[i].level <= displayLevel){
          content.add(terminalQueue[i]);
        }
      }
      terminalQueue.removeRange(0, len); // mások a végére raknak, ez így threadsafe
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Text("Telemetry Log"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton(
              value: displayLevel,
              items: [
                DropdownMenuItem(value: 0, child: Text(displayIdLevelMap[0]!)),
                DropdownMenuItem(value: 1, child: Text(displayIdLevelMap[1]!)),
                DropdownMenuItem(value: 2, child: Text(displayIdLevelMap[2]!)),
                DropdownMenuItem(value: 3, child: Text(displayIdLevelMap[3]!)),
                DropdownMenuItem(value: 4, child: Text(displayIdLevelMap[4]!)),
              ],
              onChanged: (int? value) {
                if(value != null){
                  displayLevel = value;
                  content.removeWhere(((element) => element.level > displayLevel));
                  setState(() {});
                }
              },
            ),
            IconButton(
              padding: const EdgeInsets.all(defaultPadding),
              icon: Icon(Icons.clear, color: primaryColor),
              splashRadius: 20,
              onPressed: () {
                content.clear();
                setState(() {});
              },
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: primaryColor, width: 1.0)),
          width: terminalWidth.toDouble(),
          height: 400,
          child: ListView.builder(
            itemCount: content.length,
            itemExtent: 40,
            itemBuilder: (BuildContext context, int index){
              return ListTile(
                leading: Text("${displayIdLevelMap[content[index].level]} - ${content[index].time} - ${content[index].message}",
                  overflow: TextOverflow.clip,
                  maxLines: 1,),
                trailing: IconButton(
                  padding: const EdgeInsets.all(defaultPadding),
                  icon: Icon(Icons.check, color: primaryColor),
                  onPressed: () {
                    content.removeAt(index);
                    setState(() {});
                  },
                  splashRadius: 20,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
