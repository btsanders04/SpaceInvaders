public class Defender{

  int xPos=100;
  int size=100;
  int yPos=height-size;
  PImage ship;
  boolean killed=false;
  int round = 0;
  Bullet[] bullets= new Bullet[5];
  //Bullet b;
  public Defender(){
    ship = loadImage("spaceship-new.png");
  }
  
  public void updateDefender(){
   if(a!=null){
    if(a.b!=null){
    if(isCollision(xPos+size/2,yPos+size/2,a.b.xPos,a.b.yPos)){
      killed=true;
      a.b.destroyBullet();
      }
    }
  }
     moveDefender();
       image(ship,xPos,yPos,size,size); 
       for(Bullet b: bullets){
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
        if(round<bullets.length){
        bullets[round]=new Bullet(xPos+size/2,yPos);
        round++;
        }
      }
      else if(key=='r'){
        //reload();
        }
      }
    }
  
  private void reload(){
    for(Bullet b: bullets){
      if(b==null){
        //b=
      }
    }
  }
  
}
