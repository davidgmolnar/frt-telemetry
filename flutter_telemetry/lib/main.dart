import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/screens/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  // TODO local config load
  // TODO auth?
  // TODO load signalValues.keys as cache
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
    if(textColor == textColorDark){
      textColor = textColorBright;
      primaryColor = primaryColorBright;
      secondaryColor = secondaryColorBright;
      bgColor = bgColorBright;
    }
    else{
      textColor = textColorDark;
      primaryColor = primaryColorDark;
      secondaryColor = secondaryColorDark;
      bgColor = bgColorDark;
    }
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
  void dispose() {
    // TODO save signalValues.keys as cache
    // TODO local config update
    super.dispose();
  }
}