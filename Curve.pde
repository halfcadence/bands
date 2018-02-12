class Curve {
  float xStart, yStart, xEnd, yEnd; // start and end points
  float x1,y1,x2,y2; // first and second control points
  float hue;
  float opacity;
  
  Curve(xStart, yStart, xEnd, yEnd, x1, y1, x2, y2, hue, opacity) {
    this.xStart = xStart;
    this.yStart = yStart;
    this.xEnd = xEnd;
    this.yEnd = yEnd;
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.hue = hue;
    this.opacity = opacity;
  }
}