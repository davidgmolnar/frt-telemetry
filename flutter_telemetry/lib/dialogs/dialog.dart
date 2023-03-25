import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';

class DialogTitleBar extends StatelessWidget{
  const DialogTitleBar({super.key, required this.parentContext});

  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dialogTitleBarHeight,
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.all(defaultPadding), child: Text("Accu Snapshot"),),
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