// Anzahl Boxen pro Reihe und Spalte
int numBoxes = 5;

void setup() 
{
  // Fenstergroesse 700x700 und 3D Renderer
  size(700, 700, P3D); 

  // Ändere Farbmodus in HSB mit
  // H von 0 - 360
  // S von 0 - 100
  // B von 0 - 100
  colorMode(HSB, 360, 100, 100);
  
  // Standard Farbmodus waere RGB mit
  // R von 0 - 255
  // G von 0 - 255
  // B von 0 - 255
  // colorMode(RGB, 255, 255, 255);
}


void draw()
{
  // Loesche vorheriges Bild
  clear();
  
  // Anzahl der Millisekunden seit Start des Programms
  int m = millis();
  
  // keine Flaechen zeichnen
  noFill();
  
  // Kantenfarbe
  stroke(120, 100, 100);
  
  // Kantendicke
  strokeWeight(1);
  
  // Abstand der Boxen
  float abstand = width/((float)numBoxes+1);
 
  // Zeichne Boxen 
  for (int j = 0; j < numBoxes; j++) { // Zeile   
    for (int i = 0; i < numBoxes; i++) { // Spalte
      
      // Faerbung der Boxen abhaengig von Zeit, Zeile und Spalte
      //stroke((m+i*4+j*6) % 360, 100, 100);
      
      // Zufällige Färbung der Boxen
      //stroke(random(360) % 360, 100, 100);
      
      // Transformation (translate, rotate) gilt nur für die Box, die zwischen pushMatrix
      // und popMatrix gezeichnet wird
      pushMatrix();
      
      // verschiebe Box entsprechend momentaner Zeile und Spalte
      translate((i+1)*abstand, (j+1)*abstand);
      
      // rotiere Box abhaengig von Mausposition
      rotateX(mouseY/100.0 % 360);
      rotateY(mouseX/100.0 % 360);
      
      // Zeichne Box mit Groesse abstand/1.2
      box(abstand/1.2);
    
      popMatrix();
    }
  }

}