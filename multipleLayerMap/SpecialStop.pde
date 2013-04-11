class SpecialStop {

  int index;
  String name;
  float lat;
  float lon;
  float x;
  float y;
  PVector mover;

  boolean isHovered = false;
  boolean isPressed = false;
  String[] whenIdoString;

  Label label;
  de.fhpotsdam.unfolding.geo.Location loc;

  int counter;
  int endR;
  float growth;
  float r;
  float bigR;
  int bigColor;
  int circleColor;



  // Name of the bus stop,latitude, longitude
  SpecialStop(int index_, String name_, float lat_, float lon_, float r_ ) {

    index = index_;
    name= name_;
    lat = lat_;
    lon = lon_;
    r=r_;
    r=r_*cos(index_);


    growth = 0.35;

    //convert lat lons into a Location object
    loc = new de.fhpotsdam.unfolding.geo.Location(lat, lon);

    //create label
    label = new Label(name);
  }
  void mapCoords() {

    //get screen x y coordinates by translating lat lons
    float xy[] = map.getScreenPositionFromLocation(loc);
    x = xy[0];
    y = xy[1];
  }

  void display() {
    mapCoords();
    if (isHovered) {
      fill(0xfFFF866);
    } 
    else  if ((!isPressed) && (!isHovered)) {
      fill(0xffF2911B);
    } 

    else if (!isPressed) {
      fill(255);
    } 
    else if (!isHovered) {
      fill(0xffBF2A2A);
    } 
    else {
      fill(0xffBF2A2A);
    }



    //draw the ellipse
    smooth();
    noStroke();
    ellipse(x, y, r*2, r*2);
    noSmooth();

    if (counter < 10000) {
      r = r +  growth*0.38;
      if ((r < 0.5) || r > 3) {
        growth *= -1;
      }
    }

    counter++;

    // reset isHovered here
    isHovered = false;
  }
  //  ===
  
  void bigDisplay(float bigR_, int bigColor_) {
    bigColor=bigColor_;
    bigR=bigR_;
    mapCoords();
    //draw the ellipse
    smooth();
    noStroke();
    fill(bigColor);
    ellipse(x, y, bigR, bigR);
    noSmooth();


    // reset isHovered here
    isHovered = false;
    r=3;
  }



  //===
  boolean onMouseOver(float mx, float my) {
    if (dist(mx, my, x, y) < bigR) {
      isHovered = true; 
      r=bigR;

      // display label on hover
      label.display(mx, my);
      return true;
    } 
    else {
      return false;
    }
  }

  boolean onMousePressed(float mx, float my) {
    if (dist(mx, my, x, y) < bigR) {
      if (!isPressed) {

        isPressed = true;
        selectedSpecialstop = index;
      } 
      else {

        isPressed = false;
        selectedSpecialstop = -1;
      }

      return true;
    }
    return false;
  }

  void getPVecter() {
    mapCoords();
    mover = new PVector(x, y);
  }
}

