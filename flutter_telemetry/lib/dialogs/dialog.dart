import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';

class DialogTitleBar extends StatelessWidget{
  const DialogTitleBar({super.key, required this.parentContext, required this.title});

  final BuildContext parentContext;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dialogTitleBarHeight,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor))),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 2 * defaultPadding), child: Text(title, style: const TextStyle(fontSize: subTitleFontSize),),),
          const Spacer(),
          IconButton(
            onPressed: (){
              Navigator.of(parentContext).pop();
            },
            splashRadius: iconSplashRadius,
            icon: const Icon(
              Icons.close,
            )
          )
        ],
      ),
    );
  }
}