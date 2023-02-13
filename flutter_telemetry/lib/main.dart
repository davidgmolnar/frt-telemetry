import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';
import 'package:flutter_telemetry/helpers/session.dart';
import 'package:flutter_telemetry/screens/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  await getCurrentDirectory();
  await loadSession();
  await startListener();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  void toggleTheme(){
    toggleColorTheme();
    SchedulerBinding.instance.scheduleTask(() => saveSession(), Priority.animation);
    setState(() {
      
    });
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

	@override
  Widget build(BuildContext context) {
    rebuildAllChildren(context); // a const widgetek is rebuildelnek
    return MaterialApp(
      title: 'BME-FRT Telemetry',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: textColor),
        canvasColor: bgColor,
      ),
      home: MainScreen(toggleTheme: toggleTheme,),
    );
  }

  @override
  void dispose(){
    SchedulerBinding.instance.scheduleTask(() => saveSession(), Priority.animation);
    super.dispose();
  }
}