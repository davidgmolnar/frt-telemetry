import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/dialogs/dialog.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class ChartRescaleDialog extends StatefulWidget {
  const ChartRescaleDialog({super.key, required this.updater});

  final Function updater;

  @override
  State<ChartRescaleDialog> createState() => ChartRescaleDialogState();
}

class ChartRescaleDialogState extends State<ChartRescaleDialog> {
  late double max;
  bool isMaxSet = false;
  late double min;
  bool isMinSet = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: bgColor,
      child: SizedBox(
        width: 400,
        height: 100,
        child: Column(
          children: [
            DialogTitleBar(parentContext: context, title: "Chart rescale",),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      hintText: "MAX",
                      hintStyle: const TextStyle(color: Colors.grey)
                    ),
                    onChanged:(value) {
                      try{
                        max = double.parse(value);
                        isMaxSet = true;
                      }
                      catch (_){}
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      hintText: "MIN",
                      hintStyle: const TextStyle(color: Colors.grey)
                    ),
                    onChanged:(value) {
                      try{
                        min = double.parse(value);
                        isMinSet = true;
                      }
                      catch (_){}
                    },
                  ),
                ),
                IconButton(
                  onPressed: (){
                    if(isMaxSet && isMinSet){
                      if(max <= min){
                        showError(context, "Min >= max ?");
                        return;
                      }
                      widget.updater(max, min);
                      Navigator.of(context).pop();
                    }
                    else{
                      showError(context, "Either min or max was not set");
                    }
                  },
                  icon: const Icon(Icons.check),
                  splashRadius: iconSplashRadius,
                )
              ],
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}