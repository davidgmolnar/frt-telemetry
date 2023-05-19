import 'package:dart_dbc_parser/dart_dbc_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/dialogs/dialog.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';
import 'package:universal_io/io.dart';

class DBCSelectorDialog extends StatefulWidget {
  const DBCSelectorDialog({super.key});

  @override
  State<DBCSelectorDialog> createState() => DBCSelectorDialogState();
}

class DBCSelectorDialogState extends State<DBCSelectorDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: bgColor,
      child: SizedBox(
        width: 700,
        height: 400,
        child: Column(
          children: [
            DialogTitleBar(parentContext: context, title: "DBC selector",),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Selected DBC files", style: TextStyle(fontSize: subTitleFontSize),),
                ),
                const Spacer(),
                TextButton(
                  onPressed: (() async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      allowedExtensions: [".dbc"],
                      allowMultiple: true,
                    );
                    if(result != null){
                      if(result.paths.every((element) => element != null)){
                        for(int i = 0; i < result.paths.length; i++){
                          try{
                            DBCDatabase temp = await DBCDatabase.loadFromFile([File(result.paths[i]!)]);
                            if(temp.database.isNotEmpty && !canPathList.contains(result.paths[i]) ){
                              canPathList.add(result.paths[i]!);
                              can = await DBCDatabase.loadFromFile(canPathList.map((e) => File(e)).toList());
                              terminalQueue.add(TerminalElement("Added new files into DBC database", 3));
                            }
                            else{
                              // ignore: use_build_context_synchronously
                              showError(context, "DBC structure for ${result.paths[i]!.split('\\').last} is either not valid or this file was already added");
                            }
                          }
                          catch (exc) {
                            terminalQueue.add(TerminalElement("Failed to add some files into DBC database", 2));
                          }
                        }
                      }
                    }
                    setState(() {
                      
                    });
                  }),
                  child: const Text("New")
                )
              ],
            ),
            SizedBox(
              height: 400 - dialogTitleBarHeight - 50,
              width: 700 - 2 * defaultPadding,
              child: ListView.builder(
                itemCount: canPathList.length,
                itemExtent: 50,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 500,
                        child: Text(
                          canPathList[index],
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          canPathList.removeAt(index);
                          can = await DBCDatabase.loadFromFile(canPathList.map((e) => File(e)).toList());
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete),
                        splashRadius: iconSplashRadius,
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}