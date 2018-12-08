char *incMsg = malloc(sizeof(char) * 256);

float targets[] = {600, 0, 0};
unsigned long lastUpdateTime[] = {0, 0, 0};

float values[] = {0, 0, 0};

long int sendInterval = 10;
long int lastSendTime = 0;

int decimalPlaces = 3;

void setup() {
  Serial.begin(9600);
  
  motor_setup();
  ph_setup();
  temp_setup();
  sendDebug("Started");
}

void loop() {
  motor_loop();
  ph_loop();
  temp_loop();
  //sendReading(0, targets[0]);
  if (lastSendTime + sendInterval < millis()){
    receiveSerial();
    for (int i = 0; i < 3; i++){
      writeReading(i, values[i]);
    }
    lastSendTime = millis();    
  }
}
float getReading(int sensor){
  if (sensor >= 0 && sensor <= 2){
    return values[sensor];
  }
  return 0;
}
float getTarget(int sensor){
  if (sensor >= 0 && sensor <= 2){
    return targets[sensor];
  }
  return 0;
}
void sendReading(int sensor, float value){
  if (sensor >= 0 && sensor <=2){
    lastUpdateTime[sensor] = millis();
    values[sensor] = value;
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
      sendDebug(incMsg);
      *incMsg = 0;
    }else{
      appendString(incMsg, c);
    }
  }
}
void processMessage(char *msg){
  if (startswith(msg, "SET ")){
    char* constant = splitSpace(msg + 4);
    char* value = splitSpace(msg + len(constant) - 1);
    float val = strToFloat(value);
    sendDebug(msg);
    if (compareString(constant, "targetMotorSpeed")){
        targets[0] = val;
    }else if (compareString(constant, "targetPH")){
        targets[1] = val;
    }else if (compareString(constant, "targetTemperature")){
        targets[2] = val;
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
bool compareString(char *a, char *b){
  for (int i = 0; *(a + i) != 0 && *(b + i) != 0; i++){
    if (*(a + i) != *(b + i)){
      return false;
    }
  }
  return true;
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
