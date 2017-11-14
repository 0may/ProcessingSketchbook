class Particle {
  
  // Position
  float x;
  float y;
  
  // Velocity
  float dx;
  float dy;
  
  // Color
  color col;
  
  // Radius
  float radius;
  
  // Konstruktor
  Particle(float xstart, float ystart, color c) {
    x = xstart;
    y = ystart;
    col = c; 
    
    dx = 0;
    dy = 0;
    
    radius = 20;
  }
  
  
  void moveTo(float targetX, float targetY, float force) {
      
    float diffX = targetX - x;
    float diffY = targetY - y;
    
    float d = sqrt(diffX*diffX + diffY*diffY);
    
    dx += force/d * diffX;
    dy += force/d * diffY;
    
  }
  
  
  void update() {
    x = x + dx;
    y = y + dy;
    
    dx = 0;
    dy = 0;
  }
  
  void draw() {
    noStroke();
    fill(col);
    ellipse(x, y, radius, radius);  
  }
  
}