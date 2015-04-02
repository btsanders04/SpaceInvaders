#include <Bounce2.h>
int firePin = 10;
int reloadPin = 9;
int speakerPin = 6;
Bounce bouncer1 = Bounce();
Bounce bouncer2 = Bounce();
int fire;
int reload;
int serial;
//byte[] bytes = new int[4];
void setup () {
  pinMode(firePin, INPUT_PULLUP);
  pinMode(reloadPin, INPUT_PULLUP);
  pinMode(speakerPin, OUTPUT);
  bouncer1 .attach( firePin );
  bouncer2 .attach( reloadPin );
  bouncer1 .interval(5);
  bouncer2 .interval(5);

  Serial.begin(9600);
  //Serial.println('Y');
}


void loop () {
  bouncer1.update();
  if (bouncer1.fell() == 1){
   fire = 1;
  }
  
  bouncer2.update();
  if (bouncer2.fell() == 1){
   reload = 1;
  }
  
  int posx = analogRead(A0)/4;
  int posy = analogRead(A1)/4;
  if(Serial.available()>0) {
  serial = Serial.read();

  //int fire = digitalRead(firePin);
  //int reload = digitalRead(reloadPin);
  
  if(serial == 0){
  Serial.write(posx);
  Serial.write(posy);
  Serial.write(fire);
  if(fire == 1){
    playNote('C', 30);
    playNote('b', 30);
    playNote('a', 30);
    playNote('g', 30);
  }
  fire=0;
  Serial.write(reload);
  
     if(reload == 1){
    playNote('c', 30);
    playNote('d', 30);
    playNote('e', 30);
    playNote('f', 30);
  }
  reload=0;
  }/*
  if(serial == 1){
  Serial.write((byte)posy/4);
  }
 */
 // Serial.write((String)49);
 
 

  
  /*
  if(serial == 2){
  Serial.write((byte)fire); 
 // Serial.print(fire);
  fire = 0;
  }
  if(serial == 3){
  Serial.write((byte)reload);
  reload = 0;
  }
  */
 
    }
}

void playNote(char note, int duration) {
  char names[] = { 
    'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C'   };
  int tones[] = { 
    1915, 1700, 1519, 1432, 1275, 1136, 1014, 956   };

  // play the tone corresponding to the note name
  for (int i = 0; i < 8; i++) {
    if (names[i] == note) {
      playTone(tones[i], duration);
    }
  }
}

void playTone(int tone, int duration) {
  for (long i = 0; i < duration * 1000L; i += tone * 2) {
    digitalWrite(speakerPin, HIGH);
    delayMicroseconds(tone);
    digitalWrite(speakerPin, LOW);
    delayMicroseconds(tone);

  }
}




