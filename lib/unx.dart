class UNX {
  String input;
  UNX(this.input){
    generatedAt = DateTime.now().millisecondsSinceEpoch;
  }

  int generatedAt;

  String getCoins(){
    return input.substring(0, input.indexOf("x"));
  }

  String getTime(){
    return input.substring(input.indexOf("x")+1);
  }
}