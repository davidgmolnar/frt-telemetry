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
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: primaryColor)), color: secondaryColor),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.only(left: 4 * defaultPadding), child: Text(title, style: const TextStyle(fontSize: subTitleFontSize),),),
          const Spacer(),
          IconButton(
            onPressed: (){
              Navigator.of(parentContext).pop();
            },
            splashRadius: iconSplashRadius,
            icon: Icon(Icons.close, color: primaryColor,)
          )
        ],
      ),
    );
  }
}

class DialogBase extends StatelessWidget{
  final String title;
  final Widget dialog;

  const DialogBase({super.key, required this.title, required this.dialog});
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      elevation: 10,
      child: Container(
        width: size.width * 0.3,
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 1),
          color: bgColor
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogTitleBar(parentContext: context, title: title),
            dialog
          ],
        ),
      ),
    );
  }
}