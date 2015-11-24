
int numRows;
int margin;
ArrayList<Authentic> authentic;

FileNamer fileNamer;

void setup() {
  size(800, 600, P2D);
  
  numRows = 3;
  margin = 5;
  
  authentic = new ArrayList<Authentic>();
  for (int i = 0; i < numRows; i++) {
    authentic.add(new Authentic(
      margin,
      i * height / numRows + margin,
      width - 2 * margin,
      height / numRows - 2 * margin));
  }

  fileNamer = new FileNamer("output/export", "png");
}


void redraw() {
  for (int i = 0; i < numRows; i++) {
    authentic.get(i).redraw();
  }
}

void draw() {
  background(0);
  for (int i = 0; i < numRows; i++) {
    authentic.get(i).draw(this.g);
  }
}

void keyReleased() {
  switch (key) {
    case ' ':
      redraw();
      break;
    case 's':
      save(fileNamer.next());
      break;
  }
}