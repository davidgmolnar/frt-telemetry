int normalizeInbetween(num value, num min, num max, int minHeight, int maxHeight){
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