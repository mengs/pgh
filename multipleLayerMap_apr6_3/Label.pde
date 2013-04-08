class Label {

  String txt;

  Label(String txt_) {
    txt = txt_;
  }

  void display(float x, float y) {

    // get text width
    float labelW = textWidth(txt);

    // check if label would go beyond screen dims
    if (x + labelW + 20 > width) {
      x -= labelW + 20;
    }

    // draw background
    fill(255);
    noStroke();
    rectMode(CORNER); 
    rect(x+7, y-25, labelW+15, 20); 
    textSize(10);
    textAlign(LEFT,CENTER);
    fill(0);
    text(txt, x+15, y-15);
  }
}

