
class Alien {
  PImage img;
  int size = 100;
  int xPos;
  int yPos;
  boolean moveRight=false;
  boolean canShoot=true;
  boolean killed=false;
  int bulletTimer=0;
  Bullet b;
  public Alien(int x, int y)
  {
    xPos=x;
    yPos=y;
   img = loadImage("alienship.png"); 
  }

  public void updateAlien(){
    if(d!=null){
    if(d.b!=null){
    if(isCollision(xPos+size/2,yPos+size/2,d.b.xPos,d.b.yPos)){
      killed=true;
    //  b.destroyBullet();
      }
    else{
    image(img,xPos,yPos,size,size);
    moveHorizontal();
    shoot();  
      }
    }
    else{
    image(img,xPos,yPos,size,size);
    moveHorizontal();
    shoot();
    }    
    }
    else{
    image(img,xPos,yPos,size,size);
    moveHorizontal();
    shoot();
    }    
  }
  
  private void moveHorizontal(){
    int dx=1;
  //  System.out.println(xPos);
    if(xPos <= 0){
      moveRight=true;
      this.moveVertical();
    }
    else if(xPos >= bg.width-size){
      moveRight=false;
      this.moveVertical();
    }
    if(moveRight){
      xPos+=dx;
    }
    else xPos-=dx;
  }
  
  private void moveVertical(){
    int dy=10;
    yPos+=dy;
  }
  
  private void shoot(){
    if(bulletTimer>100){
      canShoot=true;
    }
    if(canShoot && inRange()){
      b = new Bullet(xPos+size/2, yPos+size/2);
      canShoot=false;
      bulletTimer=0;
    }
    bulletTimer++;
    if(b!=null){
    b.updateBullet(false);
    }
  }
  
  
  public boolean inRange(){
    //System.out.println(d.xPos);
    if(d!=null){
    if(Math.abs(this.xPos - d.xPos) <=10){
      return true;
    }
    else{
      return false;
    }
    }
    return false;
  }
  
}

