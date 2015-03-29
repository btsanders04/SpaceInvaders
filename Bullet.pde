public class Bullet {

  int xPos;
  int yPos;
  boolean hit=false;
  
  
  public Bullet(int x, int y){
    xPos=x;
    yPos=y;
  }
  
  public void updateBullet(boolean isD){
    if(!hit){
      if(onScreen() && !hit){
        int dy =10;
      if(isD){
        yPos-=dy;
        stroke(0,0,255);
      }
      else {
        yPos+=dy;
        stroke(255,0,0);
      }
      strokeWeight(3);
      line(xPos,yPos,xPos,yPos+dy);
      }
    }  
  }
  
  private boolean onScreen(){
    if(xPos>=0 && xPos <= bg.width){
      if(yPos>=0 && yPos <= bg.height){
        return true;
      }
    }
    return false;
  }
  
  public void destroyBullet(){
     hit=true;
  }

}
