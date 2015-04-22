import processing.serial.*;
Serial myPort;
int x;
int y;


//background img
PImage bg;

//if pen is down or not;
boolean penDown;

//size of queue
int dataSize=10000;
byte[][] data = new byte[dataSize][3];

//iterate through the queue based on new data being written in 
int writepointer = 0;
//iterate through queue based on data being read by robot
int readpointer=0;

//baseline location for buttons
int yLocation;
int xLocation;

//determines which page is currently shown
int state = 0;

//the timer associated with calibrate. used to determine how long scribbler takes to make [rotations]
float time=0;

//current Time calculated in calibration to set relative timer
float currentTime=0;

//number of rotations of scribbler used with [time] to determine calibration
int rotations=10;


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


void setup(){
  bg=loadImage("scribbles.jpg");
 // background(255);
  size(bg.width,bg.height);
  yLocation=height/4;
  xLocation=width/2;
 // myPort = new Serial(this, "COM17");
  calibrate=new Button(5,"Calibrate",xLocation, height-2*yLocation, 24);
  drawNow= new Button(30,"Begin Drawing", xLocation, height-yLocation, 24);
  go = new Button(34,"Start", xLocation,height-2*yLocation, 24);
  back = new Button(50,"Finish", xLocation,height-3*yLocation,24);
  //println(location);
}



void draw(){
  
  //start page
  if(state==0){
    if(setup){
      background(bg);
      setup=false;
    }
    startPage();
  }
  
  
  //calibration page
  if(state==1){
    if(setup){
       time=0;
       setup=false;
    }
    background(bg);
    drawCal();
    
    
  }

  //draw page
  if(state==2){
    println(setup);
    if(setup){
    background(100);
    setup=false;
    }
   
    paint();
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
  stroke(0);
  
  if(writepointer>=dataSize){
    writepointer=0;
  }
  if(mousePressed){
    x = mouseX;
    y = mouseY;
    penDown=true;
    data[writepointer][0]=(byte)(x/8);
    data[writepointer][1]=(byte)(y/8);
    if(penDown){
    data[writepointer][2]=1;
    }
    else data[writepointer][2]=0;
   // println(data[writepointer][0] + " " + data[writepointer][1] + " " +  data[writepointer][2] + " " 
   // + findAngle(data[writepointer][0], data[writepointer][1]));
    writepointer++;
    line(x,y,pmouseX,pmouseY);
  
  }
  else penDown=false;
}


//determines the necessary page based on button clicks
void mousePressed(){
  if(state!=2){
  //System.out.println(calibrate.rectOver);
  if (calibrate.rectOver){
    state=1;
    setup=true;
    calibrate.rectOver=false;
  }
  else if(drawNow.rectOver){
    state=2;
    setup=true;
  }
  else if(go.rectOver){
   if(goPressed){
     go = new Button(34,"Start", go.rectX,go.rectY, go.textSize);
    
   }
   else{
     go=new Button(3, "Stop", go.rectX, go.rectY, go.textSize);
   }
    currentTime=millis();
    goPressed=!goPressed;
  }
  else if(back.rectOver){
    state=0;
   // println(currentTime);
    calibrate(time);
    setup=true;
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
    
    //send arduino code to turn in place
    
    
  }
  else{
    
    drawTimer(time);
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


float currentX=0;
float currentY=0;
double startAngle=0.0;

double findAngle(byte x, byte y){
 
 double theta = (atan(((float)y-currentY)/((float)x-currentX)))*(180/PI);
 double angle=theta-startAngle;
//  startAngle=theta;
  return angle;
}

void serialEvent(Serial thePort){
  thePort.read();
  if(readpointer>=dataSize){
    readpointer=0;
  }
   for(int i=0; i<3; i++){
     myPort.write(data[readpointer][i]);
   }
   readpointer++;
}





