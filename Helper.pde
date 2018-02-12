class Helper {
  PFont font;
  Helper() { 
    font = createFont("Circular Std",16,true); // STEP 2 Create Font
  }
  
  void debugText(String text) {
    // draw rectangle at bottom of screen
    fill(0);
    noStroke();
    rect(0,  height - 30, width, height);
    
    // select text color
    fill(100);
    textFont(font,16);
    
    text(text, 5, height - 10);  
  }
}