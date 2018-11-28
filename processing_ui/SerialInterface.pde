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
    while (port != null && port.available() > 0){
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
    String[] args = msg.split(" ");
    if (args[0].equals("DEBUG")){
      println(msg);
    }else if (args[0].equals("SENSOR")){
      //Use sensor reading
      int sensor = int(args[1]);
      int time = int(args[2]);
      float val = float(args[3]);
      csv.addData(sensor, time, val);
    }else{
      println(msg);
    }
  }
}