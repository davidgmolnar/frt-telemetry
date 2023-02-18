import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';

int normalizeInbetween(num value, num min, num max, int minHeight, int maxHeight){  // Barchart és g-g plot
  if(min <= value && value <= max){
    return (((value - min) / (max - min)) * (maxHeight - minHeight)).toInt() + minHeight;
  }
  else if(value > max){
    return maxHeight;
  }
  else if(value < min){
    return minHeight;
  }
  else{
    return minHeight;
  }
}

String xPrefix(int i){  // g-g plot
  if(i == 0 || i == 1){
    return "";
  }
  else {
    return "-";
  }
}

String yPrefix(int i){  // g-g plot
  if(i == 3 || i == 0){
    return "";
  }
  else {
    return "-";
  }
}

String representNumber(String ret, {int maxDigit = 10}){
  if(ret.length > maxDigit){
    ret = ret.substring(0, maxDigit);
  }
  if(ret.contains('.')){
    while(ret.endsWith('0') && ret.length >= 2){
      ret = ret.substring(0, ret.length - 2);
    }}
    if(ret.endsWith('.')){
      ret = ret.substring(0, ret.length - 2);
    }
  return ret;
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(context, message){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: textColor, fontSize: 20),),
      backgroundColor: Colors.red,
    )
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfo(context, message){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: textColor, fontSize: 20),),
      backgroundColor: primaryColor,
    )
  );
}

void toggleColorTheme(){
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
}