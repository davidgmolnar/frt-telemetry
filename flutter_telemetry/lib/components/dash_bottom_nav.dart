import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';

class DashBottomNavButton extends StatelessWidget{
  const DashBottomNavButton({super.key, required this.iconData, required this.onPressed});
  
  final Function onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: iconSplashRadius + 10,
      width: iconSplashRadius + 10,
      child: Center(
        child: IconButton(
          icon: Icon(iconData),
          padding: const EdgeInsets.all(0),
          color: textColor,
          splashRadius: iconSplashRadius,
          onPressed: () {
            onPressed();
          },
        ),
      ),
    );
  }
}