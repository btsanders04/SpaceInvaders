public class Defender{

  int xPos=100;
  int size=100;
  int yPos=height-size;
  PImage ship;
  boolean killed=false;
  int round = 0;
  int clip=5;
  int capacity=0;
Bullet[] bullets=new Bullet[clip*2];
  //Bullet b;
  public Defender(){
    ship = loadImage("spaceship-new.png");
  }
  
  public void updateDefender(){
    for(Alien a: armada){
     if(a!=null){
      if(a.b!=null){
      if(isCollision(xPos+size/2,yPos+size/2,a.b.xPos,a.b.yPos)){
        killed=true;
        a.b = null;
        }
      }
     }
    }
     moveDefender();
     drawClip();
       image(ship,xPos,yPos,size,size); 
       for(int i=0; i<bullets.length;i++){
        if(bullets[i]!=null){
          if(bulletOnScreen(bullets[i])){ 
           bullets[i].updateBullet(true);
          }
          else {
            bullets[i]=null;
          }
        }
       }
    }

  public void moveDefender(){
    if(keyPressed){
      if(key=='a' && xPos >=0)
      {
        xPos-=5;
      }
      else if(key=='d' && xPos <= bg.width){
        xPos+=5;
      }
      else if(key==' ' && keyReleased){
        if(capacity<bullets.length/2){
        bullets[round]=new Bullet(xPos+size/2,yPos);
        round++;
        capacity++;
        keyReleased=false;
        }
      }

      else if(key=='r' && keyReleased){
        reload();
        keyReleased=false;
        }
      }
     
    }
  
  private void drawClip(){
    int dx=width-20;
    for(int i=0; i<clip-capacity;i++){
      stroke(0,0,255);
      line(dx,height-10,dx,height-20);
      dx-=10;
    }
  }
  
  private void reload(){  
   for(int i=0; i< bullets.length;i++){
     if(bullets[i]==null){
       round=i;
       capacity=0;
       break;
     }
   }
  }
    
  
}
