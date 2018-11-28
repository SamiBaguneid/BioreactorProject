// Sensors ints:
// 0 = Motor
// 1 = PH
// 2 = Temperature

// Functions:
// float getReading(int sensor)
// float getTarget(int sensor)
// void sendReading(int sensor, float value)
// void sendDebug(char *message)

const int photoPin = A0;
const int transistorPin = 9;

int startValue = 150;
  
int photoInterruptCount = 0;
int photoSensorValue = 0;
  
double RPM = 0;
float requiredRPM = 0;
  
long beginTime = 0;
long endTime = 0;
long timePassed = 0;

void checkRequiredRPM() {
  requiredRPM = getTarget(0);
}

void getPhotoInterrupt() {
  beginTime = millis();
  while(timePassed < 2000) {
    endTime = millis();
    timePassed = endTime - beginTime;
    photoSensorValue = analogRead(photoPin);
    photoSensorValue = photoSensorValue * (5.0/1023);
    if (photoSensorValue < 2) {
      photoInterruptCount += 1;
      while(photoSensorValue < 2) {
        photoSensorValue = analogRead(photoPin);
        photoSensorValue = photoSensorValue * (5.0/1023);
      }
    }
  }
  timePassed = 0;
}

void calculateRPM() {
  photoInterruptCount = photoInterruptCount / 2;
  RPM = photoInterruptCount * 30;
  photoInterruptCount = 0;
}

void checkRPM() {
  if(RPM < (requiredRPM - 15)) {
    startValue += 10;
    analogWrite(transistorPin, startValue);
  }
  else if(RPM > (requiredRPM + 15)) {
    startValue -= 10;
    analogWrite(transistorPin, startValue);
  }
}

void motor_setup(){
  pinMode(transistorPin, OUTPUT);
  Serial.println("Motor setup executed");
}
void motor_loop(){

  checkRequiredRPM();
  getPhotoInterrupt();
  calculateRPM();
  checkRPM();
  sendReading(0, RPM);
  
}
