String   myString;

void setup() {
  // Fenstergroesse 700x700
  size(700, 700);
  
  // Textgroesse
  textSize(20);
  
  // Textfarbe (gelb)
  fill(255, 255, 153);
  
  // Hintergrundfarbe (schwarz)
  background(0);
  
  // rufe die draw() Funktion nur einmal(!!) auf
  noLoop();
}


void draw() {
  
  // erweitere die Zeichenkette 'myString'
  // um die Zeichenketten der einzelnen Limit-Funktionen
  myString = byteLimits() + "\n";
  myString += shortLimits() + "\n";
  myString += intLimits() + "\n";
  myString += longLimits() + "\n";
  myString += floatLimits() + "\n";
  myString += doubleLimits();
  
  // zeichne 'myString' an Position x=10,y=50
  text(myString, 10, 50);
}


String byteLimits() {
  String s = "byte:\n- minimum value: " + Byte.MIN_VALUE + "\n- maximum value: " + Byte.MAX_VALUE;
  return s;
}

String shortLimits() {
  return "short:\n- minimum value: " + Short.MIN_VALUE + "\n- maximum value: " + Short.MAX_VALUE;
}

String intLimits() {
  return "int:\n- minimum value: " + Integer.MIN_VALUE + "\n- maximum value: " + Integer.MAX_VALUE;
}

String longLimits() {
  return "long:\n- minimum value: " + Long.MIN_VALUE + "\n- maximum value: " + Long.MAX_VALUE;
}

String floatLimits() {
  return "float:\n- minimum value > 0: " + Float.MIN_VALUE + "\n- maximum value: " + Float.MAX_VALUE;
}

String doubleLimits() {
  return "double:\n- minimum value > 0: " + Double.MIN_VALUE + "\n- maximum value: " + Double.MAX_VALUE;
}