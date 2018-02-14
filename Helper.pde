class Helper {
  PFont debugFont;
  PFont mainFont;
  long lastDebounced = 0;
  int refreshSpeed = 500;
  String text;
  Helper() { 
    debugFont = createFont("Menlo",12,true); // STEP 2 Create Font
    mainFont = createFont("CircularStd-Book", 12 ,true); // STEP 2 Create Font
  }
  
  void debugText(String text) {
    long currentTime = millis();
    if (currentTime < lastDebounced + refreshSpeed) {
      drawText();
    }
    else {
      lastDebounced = currentTime;
      this.text = text;
      drawText();
    }
  }
  void drawTitle(int darkness) {
    // select text color
    fill(darkness);
    textFont(mainFont, 24);
    
    pushMatrix();
    translate(width / 2, height / 2);
    textAlign(CENTER, CENTER);

    text("[ SPACE ]", 0, 0);
    popMatrix();
  }
  private void drawText() {
    // draw rectangle at bottom of screen
    fill(0);
    noStroke();
    rect(0,  height - 30, width, height);
    
    // select text color
    fill(100);
    textFont(debugFont,12);
    textAlign(LEFT);
    
    println("drawing text: " + text);
    text(text, 5, height - 13);  
  }
}