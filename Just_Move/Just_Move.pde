import processing.serial.*;
Serial myPort;
int x;
int y;
int counter=0;
float currentX=0;
float currentY=0;
float startAngle=0.0;
Serial bluetooth;


//size of paper
int pLength;
int pWidth;

//Command string that comes from the Arduino
int cmd;

//background img
PImage bg;

//if pen is down or not;
int penDown;

//tells arduino how much to move
float turnTime;
float driveTime=1;
int dir;

//size of queue
int dataSize=1000000;
float[][] data = new float[dataSize][4];

//iterate through the queue based on new data being written in 
int writepointer = 0;
//iterate through queue based on data being read by robot
int readpointer=0;

//baseline location for buttons
int yLocation;
int xLocation;

//determines which page is currently shown
int state = 0;

//calibration angle
float vangle=0;

//the timer associated with calibrate. used to determine how long scribbler takes to make [rotations]
float time=96000;

//current Time calculated in calibration to set relative timer
float currentTime=0;

//number of rotations of scribbler used with [time] to determine calibration
int rotations=5;


//true in order to initialize each page, otherwise false
boolean setup=true;

//determines if Start button is either [START] or [STOP]
boolean goPressed=false;

//Calibration button on start Page
Button calibrate;

//Drawing button on Start page
Button drawNow;

//Start Button on Calibration page
Button go;

//Stop Button on Calibration Page
Button stop;

//Back button on Calibration page
Button back;

Button forward;
Button backward;
Button turnLeft;
Button turnRight;
Button penToggle;

byte test = 0;


void setup(){
  bg=loadImage("scribbles.jpg");
 // background(255);
  size(bg.width,bg.height);
  yLocation=height/4;
  xLocation=width/2;
 // myPort = new Serial(this, "COM17");
  bluetooth = new Serial(this, "COM23");
  vangle=3600/time;
  calibrate=new Button(5,"Calibrate",xLocation, height-2*yLocation, 24);
  drawNow= new Button(30,"Begin Drawing", xLocation, height-yLocation, 24);
  go = new Button(34,"Start", xLocation,height-2*yLocation, 24);
  back = new Button(50,"Finish", xLocation,height-3*yLocation,24);
 
  //println(location);
}



void draw(){
 // println(state);
  //start page
  switch(state){
  
    
 case 0 :{
    if(setup){
      background(bg);
      setup=false;
    }
    startPage();
  }
  break;
  
  
  //calibration page
  case 1: {
    if(setup){
       time=0;
       setup=false;
    }
    background(bg);
    drawCal();
    
    
  }
  break;

  //draw page
  case 2: {
    //println(setup);
    if(setup){
    background(100);
    setup=false;
    }
   
    paint();
  }
  break;
  
  } 
  
  //System.out.println("X: " + x + " Y: " + y + " Pen: " + penDown);
}



//draws the start page
void startPage(){
  
  textAlign(CENTER);
  textSize(24);
  String t="Welcome to Scribble";
  
  pushMatrix();
  fill(100);
  rectMode(CENTER);
  rect(xLocation,height-3*yLocation,xLocation + textWidth(t)/2, 2*(textAscent()));
  fill(0);
  text(t,xLocation, height-3*yLocation);
  popMatrix();
  textAlign(BASELINE);
  calibrate.drawButton();
  drawNow.drawButton();
   
}



//draws the draw page
void paint(){
 int xLoc=width/2;
 int yLoc=height/2;
 println(xLoc);
 println(yLoc);
  forward=new Button(5,"Forward",xLoc,30, 24);
  backward= new Button(30,"Backward", xLoc, height-30, 24);
  turnLeft= new Button(34,"Left",30,yLoc, 24);
  turnRight = new Button(50,"Right",width-40,yLoc,24);
  penToggle = new Button(70,"Toggle Pen", xLoc,yLoc+20,24);
  forward.drawButton();
  backward.drawButton();
  turnLeft.drawButton();
  turnRight.drawButton();
  penToggle.drawButton();
  stroke(0);
}





//determines the necessary page based on button clicks
void mousePressed(){
  if(state!=2){
  //System.out.println(calibrate.rectOver);
  if (calibrate.rectOver){
    state=1;
    setup=true;
    calibrate.rectOver=false;
 //   println("BUTToN PRESSED");
  }
  else if(drawNow.rectOver){
   bluetooth.write(0);
   bluetooth.write(0);
   bluetooth.write(0);
   bluetooth.write(0);
   bluetooth.write(0);
    state=2;
    setup=true;
  }
  else if(go.rectOver){
   if(goPressed){
   //  //bluetooth.write("HELLO");
    bluetooth.write(2);
  //  println("WRITING 1");
     go = new Button(34,"Start", go.rectX,go.rectY, go.textSize);
    
   }
   else{
     bluetooth.write(1);
 //    println("Calibrate");
     go=new Button(3, "Stop", go.rectX, go.rectY, go.textSize);
   }
    currentTime=millis();
    goPressed=!goPressed;
  }
  else if(back.rectOver){
    state=0;
   // println(currentTime);
    setup=true;
  }
  }
  else{
    if(bluetooth.available()>0){
      bluetooth.read();
    if(forward.rectOver){
      bluetooth.write(0);
      bluetooth.write(0);
      bluetooth.write(200);
      bluetooth.write(0);
      bluetooth.write(penDown);
    }
    else if(turnLeft.rectOver){
      bluetooth.write(0);
      bluetooth.write(100);
      bluetooth.write(0);
      bluetooth.write(0);
      bluetooth.write(penDown);
    }
    else if(turnRight.rectOver){
      bluetooth.write(0);
      bluetooth.write(100);
      bluetooth.write(0);
      bluetooth.write(1);
      bluetooth.write(penDown);
    }
    else if(penToggle.rectOver){
      penDown=1-penDown;
      bluetooth.write(0);
      bluetooth.write(0);
      bluetooth.write(0);
      bluetooth.write(0);
      bluetooth.write(penDown);
    }
    else if(backward.rectOver){
      bluetooth.write(0);
      bluetooth.write(0);
      bluetooth.write(0);
      bluetooth.write(0);
      bluetooth.write(penDown);
    }
    }
  }
}

//draws the calibration page
void drawCal(){
  textAlign(CENTER);
   textSize(24);
  String t = "Rotate " + rotations + " times";
   pushMatrix();
  fill(100);
  rectMode(CENTER);
  rect(xLocation,height-3.5*yLocation,xLocation + textWidth(t)/2, 2*(textAscent()));
  fill(0);
  text(t,xLocation, height-3.5*yLocation);
  popMatrix();
  textAlign(BASELINE);
 go.drawButton();
 back.drawButton();
  if(goPressed){
    
    time = (millis()-currentTime)/1000;
    drawTimer(time);
    
    
    //special byte to tell arduino to calibrate
   
    //send arduino code to turn in place
  }
  else{
    drawTimer(time);
    vangle=(360*rotations)/time;
  }
    
}

//draws the Timer on the calibration page
void drawTimer(float time){
  textAlign(CENTER);
   pushMatrix();
  fill(100);
  rectMode(CENTER);
  rect(xLocation,height-yLocation,xLocation + textWidth((char)time)/2, 2*(textAscent()));
  fill(0);
  text(time,xLocation, height-yLocation);
  popMatrix();
  textAlign(BASELINE);
}



//for arduino code

float calibrate(float time){
  return rotations*360/time;
}



float findAngleTime(int x, int y){
 
 float theta = (atan(((float)y-currentY)/((float)x-currentX)))*(180/PI);
 float angle=theta-startAngle;
 if(angle<0){
   angle=Math.abs(angle);
   data[writepointer][2]=0;
 }
 else data[writepointer][2]=1;
 startAngle=theta;
//  println(angle*vangle);
  return angle/vangle;
}




float findMagTime(double x, double y){
 // println((sqrt(sq((float)(x-currentX))+sq((float)(y-currentY))))*driveTime);
  return (sqrt(sq((float)(x-currentX))+sq((float)(y-currentY))))/driveTime;
}


void bluetoothEvent(){
  if(bluetooth.available()>0){
  cmd = bluetooth.read();
  }
//  println(cmd);
  if(cmd == 1 || cmd == 0){
    bluetooth.write(0);
    if(readpointer<writepointer){
       readpointer++;
     //  println("ReadPointer ++");
    }
    bluetooth.write((int)data[readpointer][0]);
    bluetooth.write((int)data[readpointer][1]);
  
  //  bluetooth.write((int)turnTime);
  //  bluetooth.write((int)driveTime);
    bluetooth.write((int)data[readpointer][3]); 
   println(data[readpointer][0] + " " + data[readpointer][1] + " " + data[readpointer][3]);
  }
  if(readpointer>=dataSize){
    readpointer=0;
  }
}





