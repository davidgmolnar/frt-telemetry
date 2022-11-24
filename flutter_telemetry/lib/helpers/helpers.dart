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