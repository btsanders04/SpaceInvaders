

#include <SoftwareSerial.h>  
#include <math.h>
#include <Servo.h>



//software serial for bluetooth
int bluetoothTx = 2;  // TX-O pin of bluetooth mate, Arduino D2
int bluetoothRx = 3;  // RX-I pin of bluetooth mate, Arduino D3

//angle the scribbler starts at
double startAngle=0.0;

//scribblers starting position
double currentX=0;
double currentY=0;


SoftwareSerial bluetooth(bluetoothTx, bluetoothRx);

//pen servo
Servo myservo;


//direction to turn motor
int dir;

//data that comes in to tell the scribbler where to go
int x;
int y;

//state the scribbler should be in. StartPage, Draw, or Calibrate
int state;

//hardcoded calibration turns
int rotations=10;

//degrees/millisecond from calibration
float vangle;


// time sent from processing to tell the arduino what to do
float turnTime;
float driveTime;


//time used in calibration
float currentTime;

//motor pins
const int enableL=7;
const int enableR=9;
const int motor_left[] = {12,13};
const int motor_right[] = {11,10};


//time received from calibration
float time;

//control booleans to tell whether to drive or calibrate
boolean drive=false;
boolean cali=false;

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
 // drive_forward(1000);
 // turnMotor(45);
 // drive_backward(500);
 // turnMotor(720);
 //Serial.println(findAngle(5,5));
  //turnMotor(45);
  
  bluetooth.begin(115200);  // The Bluetooth Mate defaults to 115200bps
  bluetooth.print("$");  // Print three times individually
  bluetooth.print("$");
  bluetooth.print("$");  // Enter command mode
  delay(100);  // Short delay, wait for the Mate to send back CMD
  bluetooth.println("U,9600,N");  // Temporarily Change the baudrate to 9600, no parity
  // 115200 can be too fast at times for NewSoftSerial to relay the data reliably
  bluetooth.begin(9600);  // Start bluetooth serial at 9600
  
   
}


void loop() {
  
  
// Serial.println(bluetooth.readString());
 //drive_forward();
 if(drive){
     turnMotor(turnTime, dir);
     //figure out how mag corresponds to time
     drive_forward(driveTime);
     drive=false;
     bluetooth.write(1);
    // Serial.write(1);
 }

}

void serialEvent() {
   int cmd = bluetooth.read();
   Serial.println(cmd);
   if (cmd == 1 ) { //Start Calibration
     turn_left();
   } else if (cmd == 0) {  //Start Drive Mode
     while (bluetooth.available() < 3) { /* wait */ }
     turnTime=bluetooth.read();
     driveTime=bluetooth.read();
     dir=bluetooth.read();
     drive=true;

   } else if (cmd == 2){  //Stop Calibration
     motor_stop();
    // vangle=360*rotations/time;
   }
      
}

/*
void calibrate(){
  time = millis()-currentTime;
  turn_left();
}

/*
double findAngle(double x, double y){
 double theta = (atan((y-currentY)/(x-currentX)))*(180/PI);
 double angle=theta-startAngle;
  startAngle=theta;
  return angle;
}
/*
double findMag(double x, double y){
  return sqrt(sq(x-currentX)+sq(y-currentY));
}
*/
void lowerPen(boolean lower)
{
  if(lower)
  myservo.write(80);
  else
  myservo.write( 90);
}

void turnMotor(float time, int dir)
{
  int startTime=millis();
  while(millis()-startTime <time){
  if(dir==0){
    turn_left();
  }
  else if (dir == 1){
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
//delay(25);
}

void drive_forward(int time){
  int currentTime=millis();
  while((millis()-currentTime)<(time*100)){
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
