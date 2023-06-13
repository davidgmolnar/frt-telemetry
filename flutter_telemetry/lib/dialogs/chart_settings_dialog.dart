import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

class ChartSettingDialog extends StatefulWidget {
  const ChartSettingDialog({super.key, required this.updater, required this.chartSetting});

  final Function updater;
  final ChartSetting chartSetting;

  @override
  State<ChartSettingDialog> createState() => ChartSettingDialogState();
}

class ChartSettingDialogState extends State<ChartSettingDialog> {
  final TextEditingController _maxController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
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
            controller: _maxController,
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
            controller: _minController,
          ),
        ),
        SizedBox(
          width: 100,
          child: TextFormField(
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              hintText: "SECONDS",
              hintStyle: const TextStyle(color: Colors.grey)
            ),
            controller: _timeController,
          ),
        ),
        IconButton(
          onPressed: (){
            double? max = double.tryParse(_maxController.text);
            double? min = double.tryParse(_minController.text);
            int? time = int.tryParse(_timeController.text);
            if(max != null && min != null && max <= min){
              showError(context, "Min >= max ?");
              return;
            }
            widget.updater(widget.chartSetting.update(yMax: max, yMin: min, showSeconds: time));
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.check, color: primaryColor,),
          splashRadius: iconSplashRadius,
        )
      ],
    );
  }
}