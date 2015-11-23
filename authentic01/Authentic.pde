
class Authentic {

  int x;
  int y;
  int width;
  int height;

  PGraphics drawing;
  PGraphics mask;

  PFont letterFont;
  char letter;

  Authentic(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;

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
    float cornerRadius = 12;
    g.beginDraw();
    g.fill(0);
    g.rect(0, 0, width, height);
    g.fill(255);
    g.rect(0, 0, width, height, cornerRadius);
    g.endDraw();
  }

  void redraw() {
    drawing = createGraphics(width, height, P2D);

    PGraphics g = drawing;
    drawOutline(g);
    drawBackground(g);
    drawWaveBlock(g);
    drawLetter(g);
  }

  private void drawOutline(PGraphics g) {
    g.beginDraw();
    g.stroke(128);
    g.noFill();
    g.rect(0, 0, width, height);
    g.endDraw();
  }

  private void drawBackground(PGraphics g) {
    LinearGradient grad = new LinearGradient(
      0.54 * width,
      1.2 * height,
      0.49 * width,
      -0.4 * height);
    grad.addColorStop(0, 0xffda6ab4);
    grad.addColorStop(1, 0xff4d92e8);
    grad.fillRect(g, 0, 0, width, height, false);
  }

  private void drawLetter(PGraphics g) {
    g.beginDraw();
    g.fill(0xff4d92e8);
    g.textFont(letterFont);
    g.text(letter, 0.6 * width, 1 * height);
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
    canvas.tint(255, 16);
    canvas.blendMode(ADD);
    canvas.image(g, 0, 0);
    canvas.endDraw();
  }

  private char getRandomLetter() {
    String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return alphabet.charAt(floor(random(alphabet.length())));
  }

  void draw(PGraphics g) {
    drawing.mask(mask);
    g.image(drawing, x, y);
  }
}
