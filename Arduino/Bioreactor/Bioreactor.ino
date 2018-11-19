char *incMsg = malloc(sizeof(char) * 256);

float targetMotorSpeed;
void setup() {
  Serial.begin(9600);
  motor_setup();
  ph_setup();
  temp_setup();
}

void loop() {
  motor_loop();
  ph_loop();
  temp_loop();
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
