
class Authentic {

  int x;
  int y;
  int width;
  int height;
  float cornerRadius;

  PGraphics drawing;
  PGraphics mask;

  PFont letterFont;
  char letter;

  Authentic(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;

    cornerRadius = 12;

    init();
  }

  void init() {
    initLetter();
    initMask();
    redraw();
  }

  private void initLetter() {
    // http://www.dafont.com/super-retro-m54.font
    letterFont = createFont("Super Retro Italic M54.ttf", 168 * height / 150);
    letter = getRandomLetter();
  }

  private void initMask() {
    mask = createGraphics(width, height, P2D);
    drawMask(mask);
  }

  private void drawMask(PGraphics g) {
    g.beginDraw();
    g.pushStyle();
    g.fill(0);
    g.rect(0, 0, width, height);
    g.fill(255);
    g.rect(0, 0, width, height, cornerRadius);
    g.popStyle();
    g.endDraw();
  }

  void redraw() {
    initLetter();

    drawing = createGraphics(width, height, P2D);

    PGraphics g = drawing;
    drawBackground(g);
    drawRect(g);
    drawWaveBlock(g);
    drawClouds(g);
    drawLetter(g);
  }

  private void drawBackground(PGraphics g) {
    PGraphics bg = createGraphics(width, height, P2D);

    LinearGradient grad = new LinearGradient(
      0.54 * width,
      1.2 * height,
      0.49 * width,
      -0.4 * height);
    grad.addColorStop(0, 0xffda6ab4);
    grad.addColorStop(1, 0xff4d92e8);
    grad.fillRect(bg, 0, 0, width, height, false);
    bg.mask(mask);

    g.beginDraw();
    g.pushStyle();
    g.image(bg, 0, 0);
    g.popStyle();
    g.endDraw();
  }

  private void drawRect(PGraphics g) {
    g.beginDraw();
    g.pushStyle();
    g.fill(232, 152, 181, 160);
    g.noStroke();
    g.rect(0, 0.2 * height, 0.7 * width, 0.74 * height);
    g.popStyle();
    g.endDraw();
  }

  private void drawWaveBlock(PGraphics canvas) {
    drawWavyLines(canvas, 0);
    drawWavyLines(canvas, random(8, 14));
  }

  private void drawWavyLines(PGraphics canvas, float slope) {
    PGraphics g = createGraphics(width, height, P2D);

    int segmentWidth = 12;
    int segmentHeight = 2;
    float lineHeight = 1.5;
    int numLines = floor((height + segmentHeight + slope) / lineHeight);
    WavyLine wavyLine = new WavyLine(segmentWidth, segmentHeight);

    g.beginDraw();
    g.stroke(255);
    g.strokeWeight(0.5);
    g.noFill();
    for (int i = 0; i < numLines; i++) {
      wavyLine.draw(g, 0, i * lineHeight, width, i * lineHeight - slope);
    }
    for (int i = 0; i < numLines; i++) {
      wavyLine.draw(g, 0, i * lineHeight, width, i * lineHeight);
    }
    g.endDraw();

    PGraphics mask = createGraphics(width, height, P2D);
    mask.beginDraw();
    mask.fill(0);
    mask.rect(0, 0, width, height);
    mask.fill(255);
    mask.rect(0, 0.2 * height, width, 0.74 * height);
    mask.endDraw();
    g.mask(mask);

    canvas.beginDraw();
    canvas.pushStyle();
    canvas.tint(255, 16);
    canvas.blendMode(ADD);
    canvas.image(g, 0, 0);
    canvas.popStyle();
    canvas.endDraw();
  }

  private void drawClouds(PGraphics canvas) {
    PGraphics g = createGraphics(width, height, P2D);
    PImage clouds = loadImage("clouds.jpg");

    float w = clouds.width;
    float h = clouds.height;

    float drawW;
    float drawH;
    if (h / w > height / width) {
      drawW = width;
      drawH = drawW * h / w;
    }
    else {
      drawH = height;
      drawW = drawH * w / h;
    }

    g.beginDraw();
    g.pushStyle();
    g.imageMode(CENTER);
    g.image(clouds, width/2, height/2, drawW, drawH);
    g.popStyle();
    g.endDraw();

    g.mask(mask);

    canvas.beginDraw();
    canvas.pushStyle();
    canvas.blendMode(ADD);
    canvas.tint(32);
    canvas.image(g, 0, 0);
    canvas.popStyle();
    canvas.endDraw();
  }

  private void drawLetter(PGraphics canvas) {
    PGraphics g = createGraphics(width, height, P2D);

    int segmentWidth = 17;
    int segmentHeight = 2;
    float lineHeight = 4;
    int numLines = floor((height + segmentHeight) / lineHeight);
    WavyLine wavyLine = new WavyLine(segmentWidth, segmentHeight);

    g.beginDraw();
    g.noStroke();
    g.fill(155, 123, 203);
    g.rect(0, 0, width, height);
    g.stroke(168, 123, 236);
    g.strokeWeight(1);
    g.noFill();
    for (int i = 0; i < numLines; i++) {
      wavyLine.draw(g, 0, i * lineHeight, width, i * lineHeight);
    }
    g.endDraw();

    PGraphics mask = createGraphics(width, height, P2D);
    mask.beginDraw();
    mask.fill(0);
    mask.rect(0, 0, width, height);
    mask.fill(255);
    mask.textFont(letterFont);
    mask.text(letter, 0.6 * width, 1 * height);
    mask.endDraw();

    g.mask(mask);

    canvas.beginDraw();
    canvas.pushStyle();
    canvas.image(g, 0, 0);
    canvas.popStyle();
    canvas.endDraw();
  }

  private char getRandomLetter() {
    String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return alphabet.charAt(floor(random(alphabet.length())));
  }

  void draw(PGraphics g) {
    g.image(drawing, x, y);
  }
}
