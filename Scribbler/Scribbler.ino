

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

//determines if the pen is up or down
int penToggle=1;
int previousPen;

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
 
  bluetoothSerial();

  if(drive){
    
     
     turnMotor(turnTime, dir);
     delay(10);
     drive_forward(driveTime);
     delay(10);
     lowerPen(penToggle);
     delay(10);
     bluetooth.write(1);
     
   //  Serial.print("SEND ");
   //  Serial.println(1);
 }
   

}


//communication with the bluetooth. Reads in a command
//0 --> waits for 4 pieces of data
//      sets time to turn first
//      sets time to drive forward second
//      sets the direction to turn third
//      and sets the state of the pen fourth
//1 --> calibration. turns left
//2 --> tells the motors to turn off
void bluetoothSerial() {
 
  while(bluetooth.available()<1){}
//  if(bluetooth.available()){
   int cmd = bluetooth.read();
   if(cmd>3){
    // Serial.print("CMD ");
    // Serial.println(cmd);
   //  bluetooth.read();
     cmd=0;
   }
  // Serial.print("CMD ");
  // Serial.println(cmd);
   if (cmd == 1 ) { //Start Calibration
   //  automaton();
     turn_left();
     drive=false;
   }
    else if (cmd == 0) {  //Start Drive Mode
     while (bluetooth.available() < 4) { /* wait */ }
     
     turnTime=bluetooth.read();
     if(turnTime>100){
      // Serial.print("TURN ");
      // Serial.println(turnTime);
     // Serial.println(turnTime);
       turnTime=0;
      // Serial.println();
     }

     driveTime=bluetooth.read();
     if(driveTime>100){
     //  Serial.print("DRIVE ");
      // Serial.println(driveTime);
       driveTime=0;
     //  Serial.println(driveTime);
     //         Serial.println();
     }
     dir=bluetooth.read();
     if(dir>1){
     //  Serial.print("DIRECTION ");
     //  Serial.println(dir);
       dir=0;
      // Serial.println(dir);
     //  Serial.println();
     }
     previousPen=penToggle;
     penToggle=bluetooth.read();
     if(penToggle>1){
     //  Serial.print("PEN ");
     //  Serial.println(penToggle);
     
     //  Serial.println(penToggle);
        penToggle=0;
     //  Serial.println();
     }
  /*  
     Serial.println("DATA");  
     Serial.println(turnTime);
     Serial.println(driveTime);
     Serial.println(dir);
     Serial.println(penToggle);
     Serial.println();*/
      while(bluetooth.available()>0){
     //  Serial.print("EXTRA :");
       Serial.println(bluetooth.read());
     }
     drive=true;

   } else if (cmd == 2){  //Stop Calibration
     motor_stop();
     drive=false;
   }
   
    
//  }
      
}

//hardcoded driving. it does indeed work
void automaton(){
  for(int i=0;i<10;i++){
  drive_forward(1000);
  delay(10);
  turnMotor(400, 0);
  delay(10);
  motor_stop();
  delay(10);
  }
  
  drive_forward(1000);
}


//tells the servo to raise or lower the pen
void lowerPen(int lower)
{
  if(lower==0)
  myservo.write(80);
  else
  myservo.write( 90);
}

//turns the motor in the specified direction for the given time
void turnMotor(float time, int dir)
{
  int startTime=millis();
  while((millis()-startTime )< time){
  if(dir==0){
    turn_left();
  }
  else if (dir == 1){
   turn_right();
  }
  }
  motor_stop();
}

//stop the motors
void motor_stop(){
digitalWrite(motor_left[0], LOW);
digitalWrite(motor_left[1], LOW);

digitalWrite(motor_right[0], LOW);
digitalWrite(motor_right[1], LOW);
//delay(25);
}

//turns both motors on and driving forward for the given time
void drive_forward(int time){
  int currentTime=millis();
  while((millis()-currentTime)<time){
digitalWrite(motor_left[0], HIGH);
digitalWrite(motor_left[1], LOW);

digitalWrite(motor_right[0], HIGH);
digitalWrite(motor_right[1], LOW);
  }
  motor_stop();
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

