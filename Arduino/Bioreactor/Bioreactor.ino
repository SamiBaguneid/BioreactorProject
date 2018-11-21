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
  if (sensor == 0){
    motorSpeed = value;
  }else if (sensor == 1){
    ph = value;
  }else if (sensor == 2){
    temperature = value;
  }
}
void writeReading(int sensor, float value){
  Serial.print("SENSOR ");
  Serial.print(sensor);
  Serial.print(" ");
  Serial.print(millis());
  Serial.print(" ");
  Serial.print(value);
  Serial.print("\n");
}
void sendDebug(char *message){
  Serial.print("DEBUG ");
  Serial.print(message);
  Serial.print("\n");
}
void receiveSerial(){
  while (Serial.available() > 0){
    char c = Serial.read();
    if (c == '\n'){
      processMessage(incMsg);
    }else{
      appendString(incMsg, c);
    }
  }
}
void processMessage(char *msg){
  if (startswith(msg, "SET ")){
    char* constant = splitSpace(msg + 4);
    char* value = splitSpace(msg + len(constant));
  }
}
void appendString(char *string, char a){
  int i = 0;
  while (*(string + i) != 0){
    i++;
  }
  if (i == 255){
    sendDebug("Message overflow");
  }
  *(string + i++) = a;
  *(string + i) = 0;
}
int len(char *string){
  int i = 0;
  for (i = 0; *(string + i) != 0; i++);
  return i;
}
char* splitSpace(char *string){
  int i = 0;
  while (*(string + i) != 0 || *(string + i) == ' '){
    i++;
  }
  return subString(string, i);
}
bool startswith(char *string, char *sub){
  int i = 0;
  while (*(string + i) != 0 && *(sub + i) != 0){
    if (*(sub + i) != *(string + i)){
      return false;
    }
    i++;
  }
  return true;
}
char* subString(char *string, int l){
  char *out = malloc(sizeof(char) * (l + 1));
  int i = 0;
  for (i = 0; i < l; i++){
    *(out + i) = *(string + i);
  }
  *(out + i) = 0;
  return out;
}
