char *incMsg = malloc(sizeof(char) * 256);

float targetMotorSpeed;
float targetPH;
float targetTemperature;

//float sendInterval;

float motorSpeed;
float ph;
float temperature;

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
void sendReading(int sensor, float value){
  //Send Reading
}
void sendDebug(char *message){
  //Send debug message
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
