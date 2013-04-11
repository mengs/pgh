/*
 
 Meng Shi Mar 26, 2013
 lolaee@gmail.com
 Master Student @ Tangible Interaction Design, Code Lab, CMU
 
 */

import processing.opengl.*;
import codeanticode.glgraphics.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;


import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.providers.*;

import controlP5.*;


//-----------------------------   global variables    -----------------------------------

de.fhpotsdam.unfolding.Map map;

ControlP5 cp5;
PFont p = createFont("Helvetica Neue Medium", 12);
PFont myFont = createFont("Georgia", 13);
//control variables
String query = "";
// Show all or not to show
boolean  When_I_Work = false;
boolean  When_I_Dream = false;
boolean  scroll = false;
boolean  About_This_Project=false;
// position related variables
float posx;
float posy;
String mx_time;
float mx_num ;
int displayRatio;


// About Info variables
int myColor;
int c1, c2;
float n, n1;
PVector velocity;




Location PLocation;

SpecialStop homeLocation;
SpecialStop workLocation;

ArrayList<Stop> allbusStop;
ArrayList<SpecialStop> the61cStop;

FloatTable allbusData;
FloatTable the61cData;

FloatTable whenIworkData;
FloatTable whenIdreamData;

String[] aboutString;
String[] whenIworkString;
String[] whenIdreamString;


ArrayList<Memegon> whenIwork;
ArrayList<Memegon> whenIdream;

// initially set selected to -1
int selectedSpecialstop = -1;
int selectedstop = -1;
int special_r = 3;
int specialCounter;




//-----------------------------   setup    -----------------------------------

public void setup() {
  // basic setup
  size(1440, 900, GLConstants.GLGRAPHICS);


  // map setup
  noStroke();
  PLocation = new Location(40.44f, -79.98f);
  homeLocation = new SpecialStop(-3, "\" I sleep and dream here! \"", 40.429415, -79.918102, 8);
  workLocation= new SpecialStop(-2, "\" I work and turn dreams into reality here! \"", 40.443289, -79.943304, 8);

  allbusStop = new ArrayList<Stop>();
  the61cStop= new ArrayList<SpecialStop>();
  whenIwork= new ArrayList<Memegon> ();
  whenIdream= new ArrayList<Memegon>();

  map = new de.fhpotsdam.unfolding.Map(this, 0, 0, width, height, new OpenStreetMap.CloudmadeProvider(MapDisplayFactory.OSM_API_KEY, 92214) );
  map.setTweening(true);
  map.zoomToLevel(13);
  map.panTo(PLocation);

  // add interactions to map
  MapUtils.createDefaultEventDispatcher(this, map);


  //control P5 setting
  cp5 = new ControlP5(this);
  controlP5setting();

  allbusData = new FloatTable("PAT_Stops_txt.txt");
  the61cData = new FloatTable("PAT_61c.txt");

  whenIworkData = new FloatTable("work.txt");
  whenIdreamData = new FloatTable("dream.txt");

  loadData(allbusStop, allbusData);
  loadSpecialData(the61cStop, the61cData);

  aboutString= new String[] {
    "Pittsburgh and Me", "", "Visualizting Locational Information", "and My Daily life", "", 
    "", "A Data Generative Art Project", "Spring 2013 CITC@CMU", "Source Code", "https://github.com/mengs/pgh"
  };

  whenIworkString= new String[] {
    "Work", "", "Code", "Communication", "Make", "Poem", "Design", "Demo", "Play", "Mash", "Revenge"
  };
  whenIdreamString= new String[] {
    "Dream", "", "Peace", "Joy", "Happiness", "Poem", "Love", "Intangibles", "Mystery"
  };

  loadMemegonData(whenIwork, whenIworkString, whenIworkData);
  loadMemegonData(whenIdream, whenIworkString, whenIdreamData);
}


//-----------------------------   setup: Function: loadData   -----------------------------------

public void loadData(ArrayList<Stop> stops, FloatTable data) {
  for ( int i = 0; i<data.getRowCount(); i++) {
    float temp_lat = data.getFloat(i, 0); 
    float temp_lon = data.getFloat(i, 1);
    String temp_name = data.getRowName(i);
    Stop temp_stop = new Stop ( i, temp_name, temp_lat, temp_lon, 3);
    stops.add(temp_stop);
  }
}

public void loadSpecialData(ArrayList<SpecialStop> stops, FloatTable data) {
  for ( int i = 0; i<data.getRowCount(); i++) {
    float temp_lat = data.getFloat(i, 0); 
    float temp_lon = data.getFloat(i, 1);
    String temp_name = data.getRowName(i);
    if (temp_lon>=-79.963853 && temp_lon<=-79.923402) {
      SpecialStop temp_stop = new SpecialStop ( i, temp_name, temp_lat, temp_lon, special_r);
      stops.add(temp_stop);
    }
  }
}
public void loadMemegonData(ArrayList<Memegon> memearray, String[] memeString, FloatTable data) {
  for ( int i = 0; i<data.getRowCount(); i++) {
    float weight = data.getFloat(i, 0);
    String meme = memeString[i+2];
    Memegon temp_meme= new Memegon(meme.toUpperCase(), weight);
    memearray.add(temp_meme);
  }
}

//-----------------------------   END >> setup: Function: loadData   -----------------------------------

//-----------------------------   setup: Function: controlP5setting   ----------------------------------
public void controlP5setting() {

  cp5.setControlFont(p);

  cp5.addToggle("About_This_Project")
    .setPosition(50, height-65)
      .setSize(180, 30)
        .setColorForeground(0xffBF2A2A)//hover color
          .setColorBackground(0xffBF2A2A)//default color
            .setColorActive(0xafBF2A2A)
              .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                ; 
  cp5.addToggle("When_I_Work")
    .setPosition(250, height-65)
      .setSize(180, 30)
        .setColorForeground(0xffBF2A2A)//hover color
          .setColorBackground(0xffBF2A2A)//default color
            .setColorActive(0xafBF2A2A)
              .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                ; 
  cp5.addToggle("When_I_Dream")
    .setPosition(450, height-65)
      .setSize(180, 30)
        .setColorForeground(0xffBF2A2A)//hover color
          .setColorBackground(0xffBF2A2A)//default color
            .setColorActive(0xafBF2A2A)
              .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                ; 


  textFont(p);   
  displayRatio=5;
}

//-----------------------------  END >> setup: Function: controlP5setting   --------------------------

//-----------------------------------------------   draw   -------------------------------------------

public void draw() {

  background(0);

  map.draw();

  // display all the bus stops acoording to traffic level
  // display Ration represent the traffic level

  for (int i=0; i<allbusStop.size(); i++) {
    if (displayRatio==0) {
      displayRatio=5;
    }
    if (i % displayRatio == 0) {
      allbusStop.get(i).display();
    }
  }

  // control the traffic level by scroll bar
  // using mouseY position to map the display ration

  if (mx_num<3 ) {
    for (int i=0; i<the61cStop.size(); i++ ) {
      the61cStop.get(i).display();
    }
    specialCounter=(int)map(mx_num, 0, 3, 0, 11);
    float tempR=the61cStop.get(specialCounter).r;
    the61cStop.get(specialCounter).r=6;
    the61cStop.get(specialCounter).display();
    the61cStop.get(specialCounter).r=random(3, 5)/2;
  }  
  else if (mx_num>=15) {
    for (int i=0; i<the61cStop.size(); i++ ) {
      the61cStop.get(i).display();
    }
    specialCounter=(int)map(mx_num, 15, 18, 11, 0);
    float tempR=the61cStop.get(specialCounter).r;
    the61cStop.get(specialCounter).r=6;
    the61cStop.get(specialCounter).display();
    the61cStop.get(specialCounter).r=random(3, 5)/2;
  }

  //display specialstop home and work


  // mouseover interactions

  workLocation.bigDisplay(10, 0xffD92929);
  homeLocation.bigDisplay(10, 0xff6ECAC7); //RGB: 242,171,0

  homeLocation.onMouseOver(mouseX, mouseY);

  workLocation.onMouseOver(mouseX, mouseY);


  for (int i = allbusStop.size()-1; i >= 0; i--) {
    if (allbusStop.get(i).onMouseOver(mouseX, mouseY)) {
      break; // if stop is hovered on, break the loop so it doesn't fire for other stop
    }
  }


  // draw the bar
  drawUI();
  displaymemegon();
  //update control event
  controlEventCenter();
}

//----------------------------- End >> draw -----------------------------------

//----------------------------- draw: Function: drawUI -----------------------------------


public void drawUI() {
  stroke(0xffBF2A2A);
  fill(0xffBF2A2A);
  //  fill(0xffffffff);
  //    fill(sqrt(pointer*3)*pointer, abs(255-pointer*2.1), sqrt(300)*pointer/255); 
  rect(width/2+65, height-53, 5, 5);
  rect(width-80, height-53, 5, 5);
  line(width/2+65, height-53, width-80, height-53);
  line(width/2+65, height-48, width-80, height-48);

  textSize(10);
  textAlign(RIGHT, CENTER);
  text("WAKE_UP", width/2+60, height-53);
  textAlign(LEFT, CENTER);
  text("SLEEP", width-70, height-53);
}



//----------------------------- END >> draw: Function: drawUI -----------------------------------

//----------------------------- draw: Function: displayThoughts -----------------------------------
public void displayThoughts() {
  if (selectedSpecialstop !=-1) {
    fill(255, 0, 0);
    rect(width/2, height/2, 200, 200);
  }
}


//----------------------------- END >> draw: Function: displayWork -----------------------------------


//----------------------------- draw: Function: controlEventCenter -----------------------------------



public void controlEventCenter() {
  // about scrolling
  // if the mouse fall into target areas trigger scrolling
  if (mouseX>=width/2+60 && mouseX<=width-75 && mouseY>=height-90) {
    scroll = true;
  } 
  else {
    scroll= false;
  }

  // if trigger the scrolling, get position

  if ( scroll==true) {
    posx= width/2-80;
    posy= height/2-100;
    float mx=constrain(mouseX, width/2+65, width-80);
    mx_num = map(mx, width/2+65, width-80, 0, 18);

    displayRatio=(int)abs(mx_num-10)*2+3;

    if (mx_num<=2) {
      mx_time = "8am";
    }
    else if (mx_num<=6) {
      mx_time = "12pm";
    }

    else if (mx_num<=10) {
      mx_time = "4pm";
    }
    else if (mx_num<=14 ) { 
      mx_time = "8pm";
    }
    else if (mx_num<=17) { 
      mx_time = "12am";
    }

    else {
      mx_time = "2am";
    }

    fill(0xffBF2A2A);
    //    rect(width/2+65,height-53,mouseX-width/2-65,  5);
    rect(mx, height-53, 5, 5);//(width/2+65, height-53,(width/2+65, height-53
    textAlign(CENTER, BOTTOM);
    fill(0xffBF2A2A);
    text(mx_time, mx, height-60);
  }

  //about the project toggle button
  if (About_This_Project==true) {
    doToggleUI(About_This_Project, 50, height-65, aboutString );
  }
  if (When_I_Work==true) {
    doToggleUI(About_This_Project, 250, height-65, whenIworkString );
  }
  if (When_I_Dream==true) {
    doToggleUI(About_This_Project, 450, height-65, whenIdreamString );
  }
}

//----------------------------- END >> draw: Function: controlEventCenter -----------------------------------

//----------------------------- Control >> draw: doToggleUI -----------------------------------

public void doToggleUI( boolean toggleID, int posx, int posy, String[] toggleString) {
  pushMatrix();
  translate(posx, posy);
  int lineheight = 15;
  myColor = color(255, 200);
  fill(myColor);
  noStroke();
  rect(0, -200, 180, 200);

  for (int i=0;i<toggleString.length;i++) {
    if (i==0) {
      textSize(10);
    }
    else {
      textSize(8);
    }
    fill(0);
    textAlign(LEFT);
    text(toggleString[i], 13, -165+lineheight*i);
  }
  popMatrix();
  textSize(13);
}
//----------------------------- END >> Control >> draw: doToggleUI --------------------------------

//----------------------------- memegon >> draw: displaymemegon -----------------------------------


void displaymemegon() {
  float posx=0;
  float posy=0;
  // special location home index =-3
  // special location work index =-2;
  if (selectedSpecialstop != -1) {
    if (selectedSpecialstop == -3) {
      homeLocation.getPVecter();
      posx= homeLocation.mover.x;
      posy= homeLocation.mover.y;

      CircleDisplay(posx, posy, 0xff6ECAC7, whenIdream);
    }
    if (selectedSpecialstop == -2) {
      workLocation.getPVecter();
      posx= workLocation.mover.x;
      posy= workLocation.mover.y;
      CircleDisplay(posx, posy, 0xffD92929, whenIwork);
    }
  }
}

void CircleDisplay(float posx, float posy, int circleColor_, ArrayList<Memegon> whenIdo) {
  float startAngle = 0;
  //draw the ellipse
  noStroke();
  for (int i=0; i<whenIdo.size();i++) {
    Memegon tempMeme=whenIdo.get(i);
    String tm = tempMeme.meme;
    float tw = tempMeme.weight;
    
    fill(circleColor_, tw*255*3.9);
    arc(posx, posy, 255, 255, startAngle, startAngle+2*PI*tw);
    pushMatrix();
    translate(posx+cos(startAngle)*180, posy-sin(startAngle)*180);
    fill(circleColor_);
    textAlign(CENTER, CENTER);
    textFont(p);
    text(tm, 0, 0);
    popMatrix();
    startAngle=startAngle+2*PI*tw;
  }
  noSmooth();
}


//----------------------------- END: memegon >> draw: displaymemegon -----------------------------------


//----------------------------- draw: Function: mousePressed -----------------------------------

void mousePressed() {
  // check if mouse clicked on stop
  if (homeLocation.onMousePressed(mouseX, mouseY)) {
    workLocation.isPressed = false;
  }
  if (workLocation.onMousePressed(mouseX, mouseY)) {
    homeLocation.isPressed = false;
  }
}

//----------------------------- END >> draw: Function: mousePressed -----------------------------------

//--------------------------------- draw: Function: keyPressed ----------------------------------------

// key interaction to zoom in/out the map, loading tiles

public void keyPressed() {
  if (key == 'p') {
    map.panTo(PLocation);
  }

  if (key == '+') {
    map.zoomLevelIn();
  }
  if (key == '-') {
    map.zoomLevelOut();
  }
}

