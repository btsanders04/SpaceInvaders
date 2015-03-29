public class Defender{

  int xPos=100;
  int size=100;
  int yPos=height-size;
  PImage ship;
  boolean killed=false;
  Bullet b;
  public Defender(){
    ship = loadImage("spaceship-new.png");
  }
  
  public void updateDefender(){
    if(a.b!=null){
    if(isCollision(xPos+size/2,yPos+size/2,a.b.xPos,a.b.yPos)){
      killed=true;
      }
   else{
    moveDefender();
     image(ship,xPos,yPos,size,size); 
      if(b!=null){ 
       b.updateBullet(true);
      }
     }
    }
   else{
     moveDefender();
       image(ship,xPos,yPos,size,size); 
        if(b!=null){ 
         b.updateBullet(true);
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
      else if(key==' '){
        b= new Bullet(xPos+size/2,yPos);
      }
    }
  }
}
