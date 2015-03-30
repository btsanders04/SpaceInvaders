#include <Bounce2.h>

int firePin = 9;
int reloadPin = 8;
Bounce bouncer1;
Bounce bouncer2;

void setup () {
  bouncer1 = Bounce();
  bouncer2 = Bounce();
  pinMode(firePin, INPUT);
  pinMode(reloadPin, INPUT);
  bouncer1 .attach( firePin );
  bouncer2 .attach( reloadPin );
  bouncer1 .interval(5);
  bouncer2 .interval(5);

  Serial.begin(9600);
  Serial.println('Y');
}


void loop () {
  // if(Serial.available()>0) {
  int pos = analogRead(A0);
  Serial.print(pos);
  Serial.print(",");
  delay(1);
  bouncer1.update();
  int fire = bouncer1.read();
  Serial.print(fire); 
  Serial.print(",");
  delay(1);
  bouncer2.update();
  int reload = bouncer2.read();
  Serial.println(reload);
  //  }
}



