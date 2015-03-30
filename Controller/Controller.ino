#include <Bounce2.h>

int firePin = 7;
int reloadPin = 5;
//Bounce bouncer1;
//Bounce bouncer2;

void setup () {
  //bouncer1 = Bounce();
  //bouncer2 = Bounce();
  pinMode(firePin, INPUT);
  pinMode(reloadPin, INPUT);
 // bouncer1 .attach( firePin );
  //bouncer2 .attach( reloadPin );
  //bouncer1 .interval(10);
  //bouncer2 .interval(10);

  Serial.begin(9600);
  Serial.println('Y');
}


void loop () {
  // if(Serial.available()>0) {
  int pos = analogRead(A0);
  //bouncer1.update();
  //int fire = bouncer1.rose();
  int fire = digitalRead(firePin);
   //bouncer2.update();
  //int reload = bouncer2.rose();
  int reload = digitalRead(reloadPin);
  Serial.print(pos);
  Serial.print(",");
  delay(1);
  Serial.print(fire); 
  Serial.print(",");
  delay(1);
  Serial.println(reload);
  
  fire = 0;
  reload = 0;
  //  }
}



