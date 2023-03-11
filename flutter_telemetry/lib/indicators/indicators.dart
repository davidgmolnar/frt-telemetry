import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';

export 'boolean_indicator.dart';
export 'boolean_panel.dart';
export 'numeric_indicator.dart';
export 'numeric_panel.dart';
export 'plot_2d.dart';
export 'rotary_indicator.dart';
export 'scale_indicator.dart';
export 'waveform_chart.dart';
export 'four_state_led.dart';
export 'string_indicator.dart';
export 'compound_indicator.dart'; // Deprecated with virtual signals
export 'amk_status_indicator.dart';
export 'hvcell_indicator.dart';
export 'lap_display.dart';
export 'decoders.dart';

class Titlebar extends StatelessWidget{
  const Titlebar({
    super.key,
    required this.title
  });
  
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Text(title,
        style: const TextStyle(
          fontSize: 30,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

num torqueLimitRule(num first, num second){
  if(first == 0){
    return second;
  }
  return first;
}

num hvPowerRule(num current, num voltage){
  return current * voltage;
}