import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_telemetry/helpers/session.dart';
import 'package:universal_io/io.dart';

class ConfirmCloseDialog extends StatelessWidget {
  const ConfirmCloseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: (){
            SchedulerBinding.instance.scheduleTask(() => saveSession(), Priority.animation);
            exit(0);
          },
          child: const Text("Close")
        ),
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text("Cancel")
        ),
      ],
    );
  }
}