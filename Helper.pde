class Helper {
  PFont font;

  int lastDebounced = 0;
  int refreshSpeed = 500;
  Helper() { 
    font = createFont("Menlo",12,true); // STEP 2 Create Font
  }
  
  void debugText(String text) {
    int currentTime = millis();
    if (currentTime < lastDebounced + refreshSpeed) {
      return;
    }
    lastDebounced = currentTime;
    // draw rectangle at bottom of screen
    fill(0);
    noStroke();
    rect(0,  height - 30, width, height);
    
    // select text color
    fill(100);
    textFont(font,12);
    
    text(text, 5, height - 13);  
  }
}