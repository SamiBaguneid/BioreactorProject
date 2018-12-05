#include <math.h>
#include <string.h>

float Temperature=0.0;
int work=0;
int thermistor_v=0;
int Thermistor_PIN=A0;
int Heater_PIN=3;
char Val[4];
char fVal[2];
float Set_Temp=30.0;
void temp_setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(Heater_PIN,OUTPUT);

}
float get_temperature(int data)
{
  float temperature,voltage_thermistor,voltage_resistor,current,thermistor_resistance;
  voltage_thermistor=data*(5.0/1023.0);
  voltage_resistor=5.0-voltage_thermistor;
  current=voltage_resistor/10000.0;
  thermistor_resistance=voltage_thermistor/current;
  temperature=(4220.0/(log(thermistor_resistance/10000.0)+4220.0/(25.0+273.0)))-273.0;
  if (temperature + 0.5 >= 30.0 )
    return temperature+1.5;
  else
    return temperature+0.5;
}
int if_work(float temperature,float SetTemp)
{
  if (temperature < SetTemp)
  {
    return 1;
  }
  else
  {
    return 0;
  }
}
void temp_loop() {
  /*
  if (Serial.available()>0)
  {
    char *x=Serial.read();
    strcpy(Val,x);
    strncpy(fVal,Val,1);
    if(strcmp(fVal,"T")==0){                            //get the setted temperature
      Set_Temp=(Val[1]-'0')*10+Val[2]-'0';
    }
  }
  */
  Set_Temp = getTarget(2);
  thermistor_v=analogRead(Thermistor_PIN);
  Temperature = get_temperature(thermistor_v);
  /*Serial.print("SetTemp:");
  Serial.println(Set_Temp);
  Serial.print("thermistor_v:");
  Serial.println(thermistor_v);
  Serial.print("Temp:");
  Serial.println(Temperature);
  */
  sendReading(2, Temperature);
  work=if_work(Temperature,Set_Temp);
  if(work==1)
  {
    //Serial.println("work");
    analogWrite(Heater_PIN,159.375);
  }else{  
    //Serial.println("not work");
    analogWrite(Heater_PIN,0);
  }
  //delay(1000);

}
