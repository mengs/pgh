class Stop {

  int index;
  String name;
  float lat;
  float lon;
  float x;
  float y;
  PVector mover;

  boolean isHovered = false;
  boolean isPressed = false;


  Label label;
  de.fhpotsdam.unfolding.geo.Location loc;

  int counter;
  int endR;
  float growth;
  float r;


  // Name of the bus stop,latitude, longitude
  Stop(int index_, String name_, float lat_, float lon_, float r_) {

    index = index_;
    name= name_;
    lat = lat_;
    lon = lon_;
    r=r_*sin(index_);


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
      fill(0, 175, 155);
    } 
    else  if ((!isPressed) && (!isHovered)) {
      fill(0xffffffff, 190);
    } 

    else if (!isPressed) {
      fill(255);
    } 
    else if (!isHovered) {
      fill(0, 175, 155);
    } 
    else {
      fill(0, 175, 155);
    }


    //draw the ellipse
    smooth();
    noStroke();


    ellipse(x, y, r*2, r*2);
    noSmooth();

    if (counter < 10000) {
      r = r +  growth*0.35;
      if ((r < 0.3) || r > 3) {
        growth *= -1;
      }
    }

    counter++;

    // reset isHovered here
    isHovered = false;
  }

  boolean onMouseOver(float mx, float my) {
    if (dist(mx, my, x, y) < r*2+2) {
      isHovered = true; 

      // display label on hover
      label.display(mx, my);
      return true;
    } 
    else {
      return false;
    }
  }

  boolean onMousePressed(float mx, float my) {
    if (dist(mx, my, x, y) < r*2+2) {
      if (!isPressed) {

        isPressed = true;

        selectedstop = index;
      } 
      else {
        isPressed = false;
        selectedstop = -1;
      }
      return true;
    }
    return false;
  }

  void getPVecter() {
    float xy[] = map.getScreenPositionFromLocation(loc);
    x = xy[0];
    y = xy[1];
    mover = new PVector(x, y);
  }
}

