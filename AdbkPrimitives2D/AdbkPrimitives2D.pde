// Zeichne in Processing vorhandene 2D Formen in einem 3x3 Grid

// Zellengroesse
float dx;
float dy;

// normalisierte Mauskoordinate (zwischen 0 und 1)
float normalMouseX;
float normalMouseY;

void setup() {
  // Fenstergroesse
  size(600,600); 
  
  // Berechne Zellengroesse for 3x3 Grid
  dx = width/3.0;
  dy = height/3.0;
}


void draw() {

  clear();
  background(255);
  
  // normalisiere Mauskoordinaten
  normalMouseX = mouseX/(float)width;
  normalMouseY = mouseY/(float)height;

  // Kantenfarbe
  stroke(0);
  // Kantendicke
  strokeWeight(3);
  
  
  // Gitter zeichnen
  // horizontale Linien
  line(0, dy, width, dy);
  line(0, 2*dy, width, 2*dy);
  // vertikale Linien
  line(dx, 0, dx, height);
  line(2*dx, 0, 2*dx, height);
  
  
  drawPoint();
  drawTriangle();
  drawRect();
  
  drawQuad();
  drawEllipse();
  drawArc();
  
  drawLine();
  
  
}


void drawPoint() {
  point(normalMouseX*dx, normalMouseY*dy);
}

void drawTriangle() {
  fill(255, 255, 0);
  triangle(dx, dy, normalMouseX*dx + dx, 0, 2*dx, normalMouseY*dy); 
}

void drawRect() {
  fill(255, 0, 0);
  rect(2*dx, normalMouseY*dy, normalMouseX*dx, dy - normalMouseY*dy, width/50.0); 
}

void drawQuad() {
  fill(0, 255, 255);
  quad(0, 1.5*dy, normalMouseX*dx, dy, dx, normalMouseY*dy + dy, 0.5*dx, 2*dy); 
}

void drawEllipse() {
  fill(255, 0, 255);
  ellipse(1.5*dx, 1.5*dy, normalMouseX*dx, dy - normalMouseY*dy); 
}

void drawArc() {
  fill(0, 255, 0);
  arc(2.5*dx, 1.5*dy, dx*0.7, dy*0.7, radians(0), normalMouseX*radians(360.0)); 
}

void drawLine() {
  line(0, height, mouseX, mouseY);//3 + 2*dy); 
}