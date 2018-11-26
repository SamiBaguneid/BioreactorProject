char *incMsg = malloc(sizeof(char) * 256);

float targetMotorSpeed;
float targetPH;
float targetTemperature;

float motorSpeed = 0.235;
float ph = 12.2354;
float temperature = -12.5;

float sendInterval = 2000;
float lastSendTime = 0;

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

  if (lastSendTime + sendInterval < millis()){
    receiveSerial();
    writeReading(0, motorSpeed);
    writeReading(1, ph);
    writeReading(2, temperature);
    lastSendTime = millis();    
  }
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
  char strOut[16];
  sprintf(strOut, "%f", value);
  Serial.print(strOut);
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
void printFloat(float val){
  float val_copy = val;
  if (val < 0){
    Serial.print('-');
    val *= -1;
  }
  while (val > 1){ 
    float c = val;
    float i = 1;
    while (c >= 10){
      c /= 10;
      i *= 10;
    }
    int j = floor(c);
    Serial.print(j);
    val -= i * j;
  }
  Serial.print('.');
  while (val > 0){
    float c = val;
    float i = 1;
    while (c < 1){
      c *= 10;
      i /= 10;
    }
    int j = floor(c);
    Serial.print(j);
    val -= i * j;
  }
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
