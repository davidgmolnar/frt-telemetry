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

String representNumber(String ret){
  if(ret.length > 10){
    ret = ret.substring(0, 10);
  }
  if(ret.length >= 2 && ret.substring(ret.length - 2) == '.0'){
    return ret.substring(0, ret.length - 2);
  }
  if(ret.contains('.')){
    while(ret.endsWith('0')){
      ret = ret.substring(0, ret.length - 2);
    }}
  return ret;
}