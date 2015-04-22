import processing.serial.*;
Serial myPort;
int x;
int y;
boolean penDown;
int dataSize=10000;
byte[][] data = new byte[dataSize][3];
int writepointer = 0;
int readpointer=0;
int yLocation;
int xLocation;
int state = 0;
float time=0;
float currentTime=0;
boolean setup=true;
boolean goPressed=false;
Button calibrate;
Button drawNow;
Button go;
Button stop;
Button back;
void setup(){
  background(255);
  size(800,800);
  yLocation=height/4;
  xLocation=width/2;
 // myPort = new Serial(this, "COM17");
  calibrate=new Button(5,"Calibrate",xLocation, height-2*yLocation, 48);
  drawNow= new Button(30,"Begin Drawing", xLocation, height-yLocation, 48);
  go = new Button(34,"GO", xLocation,height-2*yLocation, 50);
  back = new Button(50,"Finish", xLocation,height-3*yLocation,60);
  //println(location);
}

void draw(){
  
  
  if(state==0){
    if(setup){
      background(100);
      setup=false;
    }
    startPage();
  }
  
  if(state==1){
    if(setup){
       //background(100);
       setup=false;
    }
    background(100);
    calibrate();
    
    
  }


  if(state==2){
    if(setup){
    background(100);
    setup=false;
    }
   
    paint();
  }
  
  
  
  //System.out.println("X: " + x + " Y: " + y + " Pen: " + penDown);
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

void startPage(){
  textAlign(CENTER);
  textSize(50);
  text("Welcome to Scribble",xLocation, height-3*yLocation);
  textAlign(BASELINE);
  calibrate.drawButton();
  System.out.println(calibrate.rectOver);
  drawNow.drawButton();
   
}

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
    println(data[writepointer][0] + " " + data[writepointer][1] + " " +  data[writepointer][2] + " " 
    + findAngle(data[writepointer][0], data[writepointer][1]));
    writepointer++;
    line(x,y,pmouseX,pmouseY);
  
  }
  else penDown=false;
}

void mousePressed(){
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
    go=new Button(3, "STOP", go.rectX, go.rectY, go.textSize);
    time=millis();
    goPressed=!goPressed;
  }
  else if(back.rectOver){
    state=0;
    setup=true;
  }
}

void calibrate(){
  
 go.drawButton();
 back.drawButton();
  if(goPressed){
    currentTime = (millis()-time)/1000;
    drawTimer(currentTime);
  }
  else{
    
    drawTimer(currentTime);
  }
    
}


void drawTimer(float time){
  textAlign(CENTER);
  text(time,xLocation,height-yLocation);
  textAlign(BASELINE);
}


