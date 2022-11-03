import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';

class DashMenu extends StatefulWidget{
  DashMenu({
    Key? key,
    required this.flexVal,
    required this.maxFlex,
    required this.minFlex,
    required this.connect,
  }) : super(key: key);

  int flexVal;
  final int maxFlex;
  final int minFlex;
  Function connect;
  
  @override
  State<StatefulWidget> createState() {
    return DashMenuState();
  }

}

class DashMenuState extends State<DashMenu>{
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flexVal,
      child: InkWell(
        onTap: () {},
        onHover: (isHovering){
          if (isHovering){
            setState(() {
              widget.flexVal = widget.maxFlex;
            });
          }
          else{
            setState(() {
              widget.flexVal = widget.minFlex;
            });
          }
        },
        child: Drawer(
          backgroundColor: secondaryColor,
          child: ListView(
            children: [
              DrawerHeader(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                child: Image.asset("assets/images/frt_logo_small.jpg", 
                  scale: 10 / widget.flexVal,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high
                ),
              ),
              ListTile(
                title: const Text("Connect"),
                onTap: () {
                  widget.connect();
                },
              )
            ],
          )
        ),
      )
    );
  }
}