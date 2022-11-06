import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/screens/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

	@override
  State<StatefulWidget> createState() {
		return MyAppState();
  }
}

class MyAppState extends State<MyApp>{
	late Timer timer;
  late WebSocketChannel sock;
  bool isconnected = false;
  Map<String, List<dynamic>> signalData = signalMap;

  void setSock(){
    isconnected = true;
    sock = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:8990'),); // 18.185.65.162
    sockListener();
  }

  void run(){
    if(isconnected){
      sock.sink.add("ping"); // ping, hogy jöjjön adat
    }
	}

  List<dynamic>? getData(String key, bool lastOnly){
    if(!signalData.containsKey(key)){
      return [];
    }
    if(lastOnly){
      int len = signalData[key]!.length;
      return [signalData[key]![len - 1]];
    }
    else{
      return signalData[key];
    }
  }

  void processPacket(Map rawJsonMap){
    for(String key in rawJsonMap.keys){
      if(signalData.containsKey(key)){
        signalData[key]!.insert(signalData[key]!.length, rawJsonMap[key]);
        if(signalData[key]!.length > signalValuesToKeep){
          signalData[key]!.removeAt(0);
        }
      }
      else{
        //print("No such signal");
      }
    }
  }

	void sockListener(){
    if(isconnected){
      sock.stream.listen((buffer){
        String result = buffer.toString();
        if(result.isNotEmpty) {
          Map temp = jsonDecode(result);
          processPacket(temp);
        }
      });
    }
	}

	@override
	void initState(){
		super.initState();
		timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => run());
	}

	@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BME-FRT Telemetry',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        	.apply(bodyColor: Colors.white),
        canvasColor: bgColor,
      ),
      home: MainScreen(getData: getData, connect: setSock,),
    );
  }
}