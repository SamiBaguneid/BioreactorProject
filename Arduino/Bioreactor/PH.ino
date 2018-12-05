// Sensors ints:
// 0 = Motor
// 1 = PH
// 2 = Temperature

// Functions:
// float getReading(int sensor)
// float getTarget(int sensor)
// void sendReading(int sensor, float value)
// void sendDebug(char *message)
int voltage = A5;
int red_pump = 13;
int black_pump = 8;

float desired_pH = 5;
float current_pH;
float kelvin_T;
long last_verify = 0;

void ph_setup() {
  pinMode(voltage, INPUT);
  pinMode(red_pump, OUTPUT);
  pinMode(black_pump, OUTPUT);
}


void get_temp(float T)
{
  kelvin_T = T + 273.15;
}
void calculate_pH(float current_voltage, float kelvin)
{
  int pHs = 7;
  float desired_pH = 5;
  float current_pH;
  float R = 8.314510;
  float F = 96485.309;
  float offset = 0.454545; //0.270969
  float gain = 5.7;
  float ln10 = 2.30258509299;
  float v_probe = (current_voltage) / gain - offset;

  //current_pH=pHs+((current_voltage*F)/(R*kelvin*2.30258509299));
  //current_pH=(-2.9292)*current_voltage+14.674;
  //current_pH=pHs+(1/5.7)*(current_voltage*F)/(R*kelvin*2.30258509299);
  //current_pH=13.45-(((current_voltage-offset)/gain)*F)/(R*kelvin*2.30258509299);

  current_pH = pHs + (-v_probe * F) / (R * kelvin * ln10);
  //Serial.println(current_pH);
  sendReading(1, current_pH);
}
void verify_pH()
{
  if (last_verify + 2000 > millis()) {
    if (current_pH > 8.2) //desired_pH)
    {
      //open acid pump
      //close after x seconds
      digitalWrite(black_pump, HIGH);
    }
    else if (current_pH < 7.8) //desired_pH)
    {

      digitalWrite(red_pump, HIGH);
    }
    last_verify = millis();
  }
}
void set_pump_low_black(){
  if (last_verify + 1000 > millis()){
    digitalWrite(black_pump, LOW);
  }
}
void set_pump_low_red(){
  if (last_verify + 1000 > millis()){
    digitalWrite(red_pump, LOW);
  }
}
void ph_loop() {
  desired_pH = getTarget(1);
  float current_voltage = analogRead(voltage);
  //int T=analogRead(temperature);

  current_voltage = 0.004936 * current_voltage;

  get_temp(getReading(2));
  calculate_pH(current_voltage, kelvin_T);

  verify_pH();
  set_pump_low_black();
  set_pump_low_red();
  //delay(100);
}
