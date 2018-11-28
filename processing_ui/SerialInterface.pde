class SerialInterface{
  Serial port;
  private String incMsg = "";
  
  void Start(PApplet parent){
    if (Serial.list().length > 0){ 
      port = new Serial(parent, Serial.list()[0], 9600);
    }else{
      println("NO USB DEVICES");
    }
  }
  
  void SetConstant(String constant, float value){
    port.write("SET " + constant + " " + str(value) + "\n");
  }
  
  void receiveMessage(){
    while (port.available() > 0){
      char c = port.readChar();
      if (c == '\n'){
        processMessage(incMsg);
        incMsg = "";
      }else{
        incMsg += c;
      }
    }
  }
  
  void processMessage(String msg){
    if (msg.substring(6) == "DEBUG "){
      println(msg);
    }else if (msg.substring(7) == "SENSOR "){
      //Use sensor reading
      println(msg);
    }else{
      println(msg);
    }
  }
}
