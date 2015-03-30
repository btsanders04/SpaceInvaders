import processing.serial.*;
Serial myPort;

PImage bg;
int colBox=20;
//Alien a;
int startAlien=30;
Defender d;
boolean keyReleased=true;
int armadaSize=10;
Alien[] armada = new Alien[armadaSize];
boolean startScreen=true;

void setup(){
  bg = loadImage("space-background.jpg");  
  size(bg.width,bg.height);
 // myPort = new Serial(this, "COM17");
//  a = new Alien(50,10);
  setupArmada();
  d = new Defender();
}


void draw(){
  image(bg,0,0,width,height);
  if(startScreen){
    runStartUp();
  }
  else{
    
    for(Alien a: armada){
    if(a!=null){
      if(a.killed){
        a=null;
      }
      else{
      a.updateAlien();
      }
    }
    }
    if(d!=null){
      if(d.killed){
        d=null;
      }
      else{
      d.updateDefender();
      }
    }
    //else{
    //  gameOver();
   // }
  }
}

public void setupArmada(){
  for(int i=0;i<armadaSize;i++){
    armada[i]=new Alien(startAlien,10);
    startAlien+=100;
  }
}


public boolean isCollision(int xShip, int yShip, int xBul, int yBul){
    if(Math.abs(xShip-xBul)<=colBox){
      if(Math.abs(yShip-yBul)<=colBox){
      //  collisionCin();
        //b.destroyBullet();
        return true;
      }
    }
    return false;
  }

public void keyReleased(){
  keyReleased=true;
}

public boolean bulletOnScreen(Bullet b){
      if(b.yPos>=0 && b.yPos <= bg.height){
        return true;
      }
    return false;
  }
  
public void runStartUp(){
  if(key==' '){
    startScreen=false;
  }
  textSize(50);
  text("Welcome to Invaders of Space", width/4,height/3); 
  textSize(30);
  text("Press 'SPACE' to begin your conquest", width/3, height/2);
  
  
}  

  

/*void serialEvent(Serial thePort) {
int xdata = thePort.read();
x = (int) map(xdata,0,255,0,width);

}
*/

