import processing.sound.*;

// Oszillator Objekte
SinOsc sineOscillator;
SawOsc sawOscillator;
SqrOsc squareOscillator;
TriOsc triangleOscillator;

float freqMin = 300;        // minimale Frequenz
float freqMax = 2000;       // maximale Frequenz
float frequency = freqMin;  // momentane Frequenz

float gainMin = 0.0;        // minimale Verstärkung
float gainMax = 0.5;        // maximale Verstärkung
float gain = gainMin;       // momentane Verstärkung

char currentKey = '1';      // zuletzt gedrückte Taste, legt den aktuellen Oszillator fest
char filterKey = '0';

String help;                // Hilfe Text

void setup() {
  size(800, 480);
    
  noSmooth();
  
  // Hilfe Text
  help = "Press 'key' to change oscillator signal:\n";
  help += "'1' for sine\n";
  help += "'2' for sawtooth\n";
  help += "'3' for square\n";
  help += "'4' for triangle";  
    
  // Oszillator Objekte anlegen (instanziieren)
  // und Verstärkung und Frequenz einstellen
  
  sineOscillator = new SinOsc(this);
  sineOscillator.amp(gain);
  sineOscillator.freq(frequency);
  
  sawOscillator = new SawOsc(this);
  sawOscillator.amp(gain);
  sawOscillator.freq(frequency);
  
  squareOscillator = new SqrOsc(this);
  squareOscillator.amp(gain);
  squareOscillator.freq(frequency);
  
  triangleOscillator = new TriOsc(this);
  triangleOscillator.amp(gain);
  triangleOscillator.freq(frequency);
  
  // starte den aktuellen Oszillator
  if (currentKey == '1') {
    sineOscillator.play();
  }
  else if (currentKey == '2') {
    sawOscillator.play();
  }
  else if (currentKey == '3') {
    squareOscillator.play();
  }
  else if (currentKey == '4') {
    triangleOscillator.play();
  }
}

void draw() {
  
  clear();
  background(0);
  stroke(255);
  strokeWeight(3);

  // setze Frequenz und Verstärkung abhängig von der Maus Position
  frequency = mouseX/(float)width * (freqMax - freqMin) + freqMin;
  gain = mouseY/(float)height * (gainMax - gainMin) + gainMin;


  // erneuere Frequenz und Verstärkung des ausgewählten Oszillators
  if (currentKey == '1') {
    sineOscillator.freq(frequency);
    sineOscillator.amp(gain);
    drawSine();
  }
  else if (currentKey == '2') {
    sawOscillator.freq(frequency);
    sawOscillator.amp(gain);
    drawSawtooth();
  }
  else if (currentKey == '3') {
    squareOscillator.freq(frequency);
    squareOscillator.amp(gain);
    drawSquare();
  }
  else if (currentKey == '4') {
    triangleOscillator.freq(frequency);
    triangleOscillator.amp(gain);
    drawTriangle();
  }
  
  // zeige Hilfe Text an
  text(help, 10, 10);
}

// Funktion zum Abfragen von Tastatureingaben
// Diese Funktion wird aufgerufen, sobald eine Taste losgelassen wird
void keyReleased() {
  
  // WENN die Taste ein der erlaubten Tasten ist UND wenn sie sich von der 
  // zuletzt gedrückten Taste unterscheidet
  // DANN stoppe den zuletzt benutzten Oszillator und starte den neu gewählten
  // mit aktuellen Parametern
  if ((key == '1' || key == '2' || key == '3' || key == '4') && key != currentKey) {
    
    if (currentKey == '1') {
      sineOscillator.stop(); 
    }
    else if (currentKey == '2') {
      sawOscillator.stop(); 
    }
    else if (currentKey == '3') {
      squareOscillator.stop(); 
    }
    else {
      triangleOscillator.stop(); 
    }
    
    if (key == '1') {
      sineOscillator.freq(frequency);
      sineOscillator.amp(gain);
      sineOscillator.play();
    }
    else if (key == '2') {
      sawOscillator.freq(frequency);
      sawOscillator.amp(gain);
      sawOscillator.play();
    }
    else if (key == '3') {
      squareOscillator.freq(frequency);
      squareOscillator.amp(gain);
      squareOscillator.play();
    }
    else {
      triangleOscillator.freq(frequency);
      triangleOscillator.amp(gain);
      triangleOscillator.play();
    }
    
    // speichere die aktuelle Taste
    currentKey = key;
  }
}


// --- Funktionen zum Zeichnen der verschiedenen Oszillator Signale ---

void drawSine() {

  for (int i = 0; i < width; i++) {
    point(i, height/2 - gain * height/2 * sin(i / (float)width * 2 * PI * frequency / freqMin));
  }
}


void drawSawtooth() {
  float v, vPrevious = 1.0;
  
  for (int i = 0; i < width; i++) {
    v = i / (float)width * frequency / freqMin;
    v = 2.0*(v - floor(v) - 0.5);
    
    if (i > 0 && vPrevious > v) {
      line(i-1, gain * height/2 * vPrevious + height/2, i, gain * height/2 * v + height/2);
    }
    else 
      point(i, gain * height/2 * v + height/2);

    vPrevious = v;
  }
}


void drawSquare() {
  float v, vPrevious = 1.0;
  
  for (int i = 0; i < width; i++) {
    v = step(sin(i / (float)width * 2 * PI * frequency / freqMin));
    
    if (vPrevious != v && i > 0) {
      line(i-1, height/2 - gain * height/2 * vPrevious, i, height/2 - gain * height/2 * v);
    }
    else {
      point(i, height/2 - gain * height/2 * v);
    }
    
    vPrevious = v;
  }
}


void drawTriangle() {
  float v;
  
  for (int i = 0; i < width; i++) {
    v = i / (float)width * frequency / freqMin * 2;
    
    if (cos(i / (float)width * 2 * PI * frequency / freqMin) >= 0.0) {
      v =  - v; 
    }
    
    
    v = 2*(v - floor(v) - 0.5);
    
    v -= step(sin(i / (float)width * 2 * PI * frequency / freqMin));
    

    point(i, gain * height/2 * v + height/2);
  }
}


float step(float v) {
  if (v >= 0.0) {
    return 1.0; 
  }
  else {
    return -1.0; 
  }
}