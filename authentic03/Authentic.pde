
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

  PFont titleFont;
  PFont heavyFont;
  PFont regularFont;
  PFont lightFont;
  PFont smallFont;

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
    initText();
    redraw();
  }

  private void initLetter() {
    // http://www.dafont.com/super-retro-m54.font
    letterFont = createFont("Super Retro Italic M54.ttf", 168 * height / 150);
    letter = 'E';
  }

  private void initMask() {
    mask = createGraphics(width, height, P2D);
    drawMask(mask);
  }

  private void initText() {
    titleFont = createFont("HelveticaNeue-Bold", 26 * 150 / height);
    heavyFont = createFont("Times", 20 * 150 / height);
    regularFont = createFont("HelveticaNeue-Bold", 18 * 150 / height);
    lightFont = createFont("Helvetica-Light", 20 * 150 / height);
    smallFont = createFont("HelveticaNeue-Bold", 14 * 150 / height);
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
    drawInterference(g);
    drawDolphin(g);
    drawText(g);
  }

  private void drawBackground(PGraphics g) {
    PGraphics bg = createGraphics(width, height, P2D);

    float x0 = 0.1 * width;
    float y0 = 0.2 * height;
    float innerRadius = 0;
    float outerRadius = 0.8 * width - x0;
    RadialGradient grad = new RadialGradient(x0, y0, innerRadius, x0 + 0.4 * width, y0, outerRadius);
    grad.addColorStop(0, 0xffad06a9);
    grad.addColorStop(0.3, 0xffad06a9);
    grad.addColorStop(0.7, 0xff461392);
    grad.addColorStop(1, 0xff4977ab);
    grad.fillRect(bg, 0, 0, width, height, false);
    bg.mask(mask);

    g.beginDraw();
    g.pushStyle();
    g.image(bg, 0, 0);
    g.popStyle();
    g.endDraw();
  }

  private void drawInterference(PGraphics g) {
    BezierFlower flower0 = new BezierFlower()
      .numPoints(3)
      .innerRadius(210)
      .outerRadius(470.0)
      .innerControlDistanceFactor(0.26649216)
      .outerControlDistanceFactor(0.17278907)
      .innerControlRotation(0.0)
      .outerControlRotation(0.0);

    BezierFlower flower1 = new BezierFlower()
      .numPoints(3)
      .innerRadius(210)
      .outerRadius(470.0)
      .innerControlDistanceFactor(0.26649216)
      .outerControlDistanceFactor(0.17278907)
      .innerControlRotation(0.0)
      .outerControlRotation(0.0);

    int numFlowers = 164;
    float xOffset = 1.5625;
    float yOffset = 0.0;
    float rotationOffset = 0.049087387;

    g.beginDraw();
    g.pushMatrix();
    g.pushStyle();

    g.translate(0.65 * width, 0.7 * height);
    g.rotate(0.02 * PI);

    g.noFill();
    g.stroke(0xff00a285, 210);
    g.strokeWeight(2);

    for (int i = 0; i < numFlowers; i++) {
      g.pushMatrix();
      g.scale(1.7 * i / numFlowers);

      flower0.draw(g);

      g.translate(xOffset, yOffset);
      g.rotate(rotationOffset);

      flower1.draw(g);

      g.popMatrix();
    }

    g.popStyle();
    g.popMatrix();
    g.endDraw();
  }

  private void drawDolphin(PGraphics g) {
    PImage dolphin = loadImage("dolphin_06_by_clipartcotttage-d7arfl9.png");
    float scale = (float)height / dolphin.height;
    g.beginDraw();
    g.tint(255);
    g.image(dolphin, 0.39 * width, 0.3 * height, scale * dolphin.width, scale * dolphin.height);
    g.endDraw();
  }

  private void drawText(PGraphics g) {
    g.beginDraw();
    g.pushStyle();
    g.fill(0x88111111);

    drawTitleText(g);
    drawFirstBarcode(g);
    drawSecondBarcode(g);
    drawProductKey(g);
    drawGenuineProduct(g);
    drawXLabel(g);

    g.popStyle();
    g.endDraw();
  }

  private void drawTitleText(PGraphics g) {
    float j = 1;
    g.textFont(titleFont);

    for (int i = 0; i < 4; i++) {
      g.text("SoftSoft Authwave 6 Extended", 0.05 * width + jitter(j), 0.16 * height + jitter(j));
      g.text("OEM Software", 0.05 * width + jitter(j), 0.28 * height + jitter(j));
    }
  }

  private void drawFirstBarcode(PGraphics g) {
    float j = 0.5;
    String label = "FQC-" + getRandomDigits(5);
    float margin = 4;

    g.noStroke();
    g.fill(255, 172);
    g.rect(0.09 * width - margin, 0.70 * height - margin, 0.29 * width + margin * 2, 0.16 * height + margin * 2);

    g.fill(0);

    drawBarcode(g, 0.09 * width, 0.72 * height, 0.29 * width, 0.09 * height);
    g.textFont(smallFont);

    for (int i = 0; i < 4; i++) {
      g.text(label, 0.09 * width + jitter(j), 0.87 * height + jitter(j));
    }
  }

  private void drawProductKey(PGraphics g) {
    float j = 0.3;
    String productKey = getRandomAlphanumeric(5) + "-" + getRandomAlphanumeric(5) + "-" + getRandomAlphanumeric(5);

    g.textFont(regularFont);

    for (int i = 0; i < 4; i++) {
      g.text("Product Key: " + productKey, 0.037 * width + jitter(j), 0.96 * height + jitter(j));
    }
  }

  private void drawSecondBarcode(PGraphics g) {
    float j = 0.5;
    String label = "00" + getRandomDigits(3) + "-" + getRandomDigits(3) + "-" + getRandomDigits(3) + "-" + getRandomDigits(3);
    float margin = 4;

    g.noStroke();
    g.fill(255, 172);
    g.rect(0.59 * width - margin, 0.77 * height - margin, 0.39 * width + margin * 2, 0.21 * height + margin * 2);

    g.fill(0);

    g.textFont(lightFont);
    drawBarcode(g, 0.61 * width, 0.77 * height, 0.37 * width, 0.11 * height);

    for (int i = 0; i < 4; i++) {
      g.text(label, 0.74 * width + jitter(j), 0.96 * height + jitter(j));
    }
  }

  private void drawBarcode(PGraphics g, float x, float y, float w, float h) {
    g.pushStyle();
    g.fill(0);
    g.noStroke();

    float currX = 0;
    float currW;
    while (currX < w) {
      currW = random(1, 3);
      g.rect(x + currX, y, currW, h);
      currX += currW + random(0.5, 2);
    }

    g.popStyle();
  }

  private void drawGenuineProduct(PGraphics g) {
    float j = 1;

    g.textFont(heavyFont);

    for (int i = 0; i < 4; i++) {
      g.text("Genuine Product", 0.64 * width + jitter(j), 0.24 * height + jitter(j));
    }
  }

  private void drawXLabel(PGraphics g) {
    float j = 1;
    String label = "X" + getRandomDigits(2) + "-" + getRandomDigits(5);

    g.pushMatrix();
    g.translate(0.97 * width, 0.63 * height);
    g.rotate(-PI/2);

    for (int i = 0; i < 4; i++) {
      g.textFont(lightFont);
      g.text(label, jitter(j), jitter(j));
    }

    g.popMatrix();
  }

  private String getRandomDigits(int n) {
    String s = "";
    for (int i = 0; i < n; i++) {
      s += floor(random(10));
    }
    return s;
  }

  private String getRandomAlphanumeric(int n) {
    String alphabet = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String s = "";
    for (int i = 0; i < n; i++) {
      s += alphabet.charAt(floor(random(alphabet.length())));
    }
    return s;
  }

  private float jitter(float n) {
    return random(-n, n);
  }

  void draw(PGraphics g) {
    //drawing.mask(mask);
    g.image(drawing, x, y);
  }
}
