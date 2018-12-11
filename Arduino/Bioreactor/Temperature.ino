#include <math.h>
#include <string.h>

float Temperature=0.0;
int work=0;
int thermistor_v=0;
int Thermistor_PIN=A0;
int Heater_PIN=3;
char Val[4];
char fVal[2];
float Set_Temp=50.0;
int analoheat=0;
void temp_setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(Heater_PIN,OUTPUT);

}
float get_temperature(int data)
{
  float tran , temp;
  tran = (1023.0/(1023.0-data))-1.0;
  temp = 1.0/(1.0/298.15 + log(tran)/4220.0) - 273.15;
  return temp;
}
int if_work(float temperature,float SetTemp)
{
  if (temperature < SetTemp - 0.4 )
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
  Serial.print("SetTemp:");
  Serial.println(Set_Temp);
  Serial.print("thermistor_v:");
  Serial.println(thermistor_v);
  Serial.print("Temp:");
  Serial.println(Temperature);
  
  sendReading(2, Temperature);
  work=if_work(Temperature,Set_Temp);
  if(work==1)
  {
    //Serial.println("work");
    analoheat=160;
  }else{  
    //Serial.println("not work");
    analoheat=0;
  }
  analogWrite(Heater_PIN,analoheat);
  //delay(1000);

}
