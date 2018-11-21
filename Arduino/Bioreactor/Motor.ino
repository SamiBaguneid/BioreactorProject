// Readonly Variables:
float targetMotorSpeed;
// float targetPH;
// float targetTemperature;
// float motorSpeed;
// float ph;
// float temperature;

// Functions:
// void sendReading(int sensor, float value)
// void sendDebug(char *message)

void checkRequiredRPM {
  requiredRPM = targetMotorSpeed;
}
void getPhotoInterrupt() {
  beginTime = millis();
  while(timePassed < 5000) {
    endTime = millis();
    timePassed = endTime - beginTime;
    photoSensorValue = analogRead(photoPin);
    //check if sensor detected change
    //if change detected increment photoInterruptCount
  }
  timePassed = 0;
}

void calculateRPM() {
  photoInterruptCount = photoInterruptCount / 2;
  RPM = photoInterruptCount * 12;
}

void checkRPM() {
  if(RPM < (requiredRPM - 20)) {
    //speed up using PWM
  }
  else if(RPM > (requiredRPM + 20)) {
    //slow down using PWM
  }
  else {
    continue;
  }
}

void motor_setup(){

  const int photoPin = A0;
  
  int photoInterruptCount = 0;
  int photoSensorValue = 0;
  
  float RPM = 0;
  float requiredRPM = 0;
  
  int beginTime = 0;
  int endTime = 0;
  int timePassed = 0;
}
void motor_loop(){

  checkRequiredRPM();
  getPhotoInterrupt();
  calculateRPM();
  checkRPM();
  sendReading(1, RPM);
  
}
