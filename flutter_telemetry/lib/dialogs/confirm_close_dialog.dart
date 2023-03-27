import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_telemetry/dialogs/dialog.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/session.dart';
import 'package:universal_io/io.dart';

class ConfirmCloseDialog extends StatelessWidget {
  const ConfirmCloseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: bgColor,
      child: SizedBox(
        width: 200,
        height: 100,
        child: Column(
          children: [
            DialogTitleBar(parentContext: context, title: "Confirm Close",),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")
                ),
                TextButton(
                  onPressed: (){
                    SchedulerBinding.instance.scheduleTask(() => saveSession(), Priority.animation);
                    exit(0);
                  },
                  child: const Text("Close")
                ),
              ],
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}