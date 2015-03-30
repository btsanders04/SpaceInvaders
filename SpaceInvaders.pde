import processing.serial.*;
Serial myPort;

PImage bg;
int colBox=20;
Alien a;
Defender d;
boolean keyReleased=true;

void setup(){
  bg = loadImage("space-background.jpg");  
  size(bg.width,bg.height);
 // myPort = new Serial(this, "COM17");
  a = new Alien(50,10);
  d = new Defender();
}


void draw(){
  
  image(bg,0,0,width,height);
  if(a!=null){
    if(a.killed){
      a=null;
    }
    else{
    a.updateAlien();
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

/*void serialEvent(Serial thePort) {
int xdata = thePort.read();
x = (int) map(xdata,0,255,0,width);

}
*/

