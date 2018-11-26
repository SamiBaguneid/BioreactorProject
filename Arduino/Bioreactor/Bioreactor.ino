char *incMsg = malloc(sizeof(char) * 256);

float targetMotorSpeed;
float targetPH;
float targetTemperature;
long int lastUpdateTime[] = {0, 0, 0};

float motorSpeed = 0.235;
float ph = 12.2354;
float temperature = -12.5;

long int sendInterval = 2000;
long int lastSendTime = 0;

int decimalPlaces = 3;

void setup() {
  Serial.begin(9600);
  
  motor_setup();
  ph_setup();
  temp_setup();
  sendDebug("test");
}

void loop() {
  motor_loop();
  ph_loop();
  temp_loop();

  if (lastSendTime + sendInterval < millis()){
    receiveSerial();
    writeReading(0, motorSpeed);
    writeReading(1, ph);
    writeReading(2, temperature);
    lastSendTime = millis();    
  }
}
void sendReading(int sensor, float value){
  if (sensor >= 0 && sensor <=2){
    lastUpdateTime[sensor] = millis();
  }
  if (sensor == 0){
    motorSpeed = value;
  }else if (sensor == 1){
    ph = value;
  }else if (sensor == 2){
    temperature = value;
  }
}
void writeReading(int sensor, float value){
  if (lastUpdateTime[sensor] != -1){
    Serial.print("SENSOR ");
    Serial.print(sensor);
    Serial.print(" ");
    Serial.print(lastUpdateTime[sensor]);
    Serial.print(" ");
    Serial.print(value, decimalPlaces);
    Serial.print("\n");
    lastUpdateTime[sensor] = -1;
  }
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
      *incMsg = 0;
    }else{
      appendString(incMsg, c);
    }
  }
}
void processMessage(char *msg){
  sendDebug(msg);
  if (startswith(msg, "SET ")){
    char* constant = splitSpace(msg + 4);
    char* value = splitSpace(msg + len(constant) - 1);
    float val = strToFloat(value);
    if (constant == "targetMotorSpeed"){
        targetMotorSpeed = val;
    }else if (constant == "targetPH"){
        targetPH = val;
    }else if (constant == "targetTemperature"){
        targetTemperature = val;
    }
    free(constant);
    free(value);
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
float strToFloat(char *val){
  bool negative = false;
  float out = 0;
  bool decimalPoint = false;
  int j = 0;
  int i = 0;
  if (*val == '-'){
    negative = true;
    i = 1;
  }
  for (; *(val + i) != 0; i++){
    char c = *(val + i);
    if (!decimalPoint){
      if (c == '.'){
        decimalPoint = true;
        j = i;
        continue;
      }
      out *= 10;
      out += charToInt(c);
    }else{
      if (c == '.')
        return out;
      float a = pow(10, j - i);
      a *= charToInt(c);
      out += a;
    }
  }
  return out;
}
int charToInt(char c){
  if (48 <= c && c <= 58)
    return c - 48;
  return 0;
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
