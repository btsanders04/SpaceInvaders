#define LMotor 6
#define RMotor 5

#include <SoftwareSerial.h>  
#include <math.h>
int bluetoothTx = 2;  // TX-O pin of bluetooth mate, Arduino D2
int bluetoothRx = 3;  // RX-I pin of bluetooth mate, Arduino D3
double startAngle=0.0;
double currentX=0;
double currentY=0;
byte serial;
SoftwareSerial bluetooth(bluetoothTx, bluetoothRx);

void setup()
{
  //Serial.begin(9600);  // Begin the serial monitor at 9600bps
  pinMode(LMotor, OUTPUT);
  pinMode(RMotor, OUTPUT);
  /*
  bluetooth.begin(115200);  // The Bluetooth Mate defaults to 115200bps
  bluetooth.print("$");  // Print three times individually
  bluetooth.print("$");
  bluetooth.print("$");  // Enter command mode
  delay(100);  // Short delay, wait for the Mate to send back CMD
  bluetooth.println("U,9600,N");  // Temporarily Change the baudrate to 9600, no parity
  // 115200 can be too fast at times for NewSoftSerial to relay the data reliably
  bluetooth.begin(9600);  // Start bluetooth serial at 9600
  */
}

void loop() {
/*
  if(Serial.available()>0){
    serial = Serial.read();
    if (serial==49){
      Serial.println("LEFT");
      digitalWrite(LMotor, HIGH);
      digitalWrite(RMotor, LOW);
    }  
    if(serial==52){
      Serial.println("RIGHT");
      digitalWrite(RMotor, HIGH);
      digitalWrite(LMotor, LOW);
    }
    if(serial==50)
    {
      Serial.println("BOTH");
       digitalWrite(RMotor, HIGH);
      digitalWrite(LMotor, HIGH);
    }
      if(serial==51)
    {
      Serial.println("OFF");
       digitalWrite(RMotor, LOW);
      digitalWrite(LMotor, LOW);
    }
    */
}

double findAngle(double x, double y){
 double theta = atan((y-currentY)/(x-currentX));
 double angle=theta-startAngle;
  startAngle=theta;
  return angle;
}

double findMag(double x, double y){
  return sqrt(sq(x-startX)+sq(y-startY));
}
/*
double findAngle(int x, int px, int py){
  
  
}
  */
  /*
{
  if(bluetooth.available())  // If the bluetooth sent any characters
  {
    // Send any characters the bluetooth prints to the serial monitor
    Serial.print((char)bluetooth.read());  
  }
  if(Serial.available())  // If stuff was typed in the serial monitor
  {
    // Send any characters the Serial monitor prints to the bluetooth
    bluetooth.print((char)Serial.read());
  }
  // and loop forever and ever!
}
*/
