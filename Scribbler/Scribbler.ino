

#include <SoftwareSerial.h>  
#include <math.h>
#include <Servo.h>

int bluetoothTx = 2;  // TX-O pin of bluetooth mate, Arduino D2
int bluetoothRx = 3;  // RX-I pin of bluetooth mate, Arduino D3
double startAngle=0.0;
float currentX=0;
float currentY=0;
SoftwareSerial bluetooth(bluetoothTx, bluetoothRx);
Servo myservo;
int x;
int y;
int dropPen=0;
const int enableL=7;
const int enableR=9;
const int motor_left[] = {12,13};
const int motor_right[] = {11,10};


void setup()
{
  Serial.begin(9600);  // Begin the serial monitor at 9600bps
  pinMode(enableL,OUTPUT);
  pinMode(enableR,OUTPUT);
  digitalWrite(enableL,HIGH);    //always enabled
  digitalWrite(enableR,HIGH);
  for(int i=0;i<2;i++){
  pinMode(motor_left[i], OUTPUT);
  pinMode(motor_right[i], OUTPUT);
  }
  myservo.attach(8);
  myservo.write(90);
 
 //Serial.println(findAngle(5,5));
  //turnMotor(45);
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
  
 //drive_forward();
  Serial.write(1);
  if(Serial.available()>2){
    x = Serial.read();
    y = Serial.read();
   dropPen = Serial.read();
   double theta = findAngle((double)x, (double)y);
   turnMotor(theta);
 //  driveFoward(findMag((double)x, (double)y);
   //stopMotor();
   //Serial.println(theta); 
   
   //Serial.println("HEY DARE");
   
  // digitalWrite(LMotor,HIGH);
   }
   
 
}


double findAngle(byte x, byte y){
 double theta = (atan(((float)y-currentY)/((float)x-currentX)))*(180/PI);
 double angle=theta-startAngle;
  startAngle=theta;
  return angle;
}

double findMag(double x, double y){
  return sqrt(sq(x-currentX)+sq(y-currentY));
}

void lowerPen(boolean lower)
{
  if(lower)
  myservo.write(80);
  else
  myservo.write( 90);
}

void turnMotor(double angle)
{
  int startTime=millis();
  while(millis()-startTime<(angle*100)/12){
  if(angle<180.0){
    turn_left();
  }
  else {
   turn_right();
  }
  }
  motor_stop();
}


void motor_stop(){
digitalWrite(motor_left[0], LOW);
digitalWrite(motor_left[1], LOW);

digitalWrite(motor_right[0], LOW);
digitalWrite(motor_right[1], LOW);
delay(25);
}

void drive_forward(int time){
  int currentTime=millis();
  while((millis()-currentTime)<time){
digitalWrite(motor_left[0], HIGH);
digitalWrite(motor_left[1], LOW);

digitalWrite(motor_right[0], HIGH);
digitalWrite(motor_right[1], LOW);
  }
}

void drive_backward(int time){
  int currentTime=millis();
  while((millis()-currentTime)<time){
digitalWrite(motor_left[0], LOW);
digitalWrite(motor_left[1], HIGH);

digitalWrite(motor_right[0], LOW);
digitalWrite(motor_right[1], HIGH);
  }
}

void turn_left(){
digitalWrite(motor_left[0], LOW);
digitalWrite(motor_left[1], HIGH);

digitalWrite(motor_right[0], HIGH);
digitalWrite(motor_right[1], LOW);
}

void turn_right(){
digitalWrite(motor_left[0], HIGH);
digitalWrite(motor_left[1], LOW);

digitalWrite(motor_right[0], LOW);
digitalWrite(motor_right[1], HIGH);
}
/*
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
