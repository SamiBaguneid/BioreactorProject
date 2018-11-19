char *incMsg = malloc(sizeof(char) * 256);
void setup() {
  Serial.begin(9600);
}

void loop() {
  
  
  
}
void receiveSerial(){
  while (Serial.available() > 0){
    char c = Serial.read();
    if (c == '\n'){
      processMessage(incMsg);
    }else{
      //Append c to incMsg
    }
  }
}
void processMessage(char *msg){
  
}
