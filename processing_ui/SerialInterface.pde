class SerialInterface{
  Serial port;
  private String incMsg = "";
  
  void Start(PApplet parent){
    if (Serial.list().length > 0){ 
      port = new Serial(parent, Serial.list()[0], 9600);
      SetConstant(0);
      SetConstant(1);
      SetConstant(2);
    }else{
      println("NO USB DEVICES");
    }
  }
  
  void SetConstant(String constant, float value){
    port.write("SET " + constant + " " + str(value) + "\n");
  }
  void SetConstant(int target){
    if (target == 0){
      SetConstant("targetMotorSpeed", targets[target]);
    }else if (target == 1){
      SetConstant("targetPH", targets[target]);
    }else if (target == 2){
      SetConstant("targetTemperature", targets[target]);
    }
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
      if (args.length >= 3){
        int sensor = int(args[1]);
        int time = int(args[2]);
        float val = float(args[3]);
        csv.addData(sensor, time, val);
        if (sensor == 0){
          motorGraph.addData((float) time/1000, val);
        }else if (sensor == 1){
          phGraph.addData((float) time/1000, val);
        }else if (sensor == 2){
          tempGraph.addData((float) time/1000, val);
        }
      }
    }else{
      println(msg);
    }
  }
}
