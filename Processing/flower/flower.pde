import processing.sound.*;

/*
  Random
  My Nguyen

  Expects a string of comma-delimted Serial data from Arduino:
  ** field is 0 or 1 as a string (switch)
  ** 2nd field is 0-4095 (LDR) —— NOT YET IMPLEMENTED
  
  
    Will change the background color when the button gets pressed
    Will change size/shape of 'ball' based on the potentiometer
    
 */
 

// Importing the serial library to communicate with the Arduino 
import processing.serial.*;  
SoundFile file;

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
// data[0] = "1" or "0"                  -- BUTTON
// data[1] = 0-4095, e.g "2049"          -- POT VALUE
String [] data;

int switchValue;
int potValue;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 2;

// animated ball
int minPotValue = 0;
int maxPotValue = 4095;    // will be 1023 on other systems
int minBallSize = 0;
int maxBallSize = 50;
//int ballDiameter = 20;
int hBallMargin = 40;    // margin for edge of screen
int xBallMin;        // calculate on startup
int xBallMax;        // calc on startup
float xBallPos;        // calc on startup, use float b/c speed is float
int yBallPos;        // calc on startup
int direction = -1;    // 1 or -1
int counter=0;

void setup ( ) {
  size (800,  600);    
  smooth();
  noStroke();
  file = new SoundFile(this, "Rock_Intro_3.mp3");
  file.play();
  // List all the available serial ports
  printArray(Serial.list());
  
  // Set the com port and the baud rate according to the Arduino IDE
  myPort  =  new Serial (this, "/dev/cu.SLAB_USBtoUART",  115200); 
  
  // settings for drawing the ball
  ellipseMode(CENTER);
  xBallMin = hBallMargin;
  xBallMax = width - hBallMargin;
  xBallPos = width/2;
  yBallPos = height/2;
} 


// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
   
    
    // This removes the end-of-line from the string 
    inBuffer = (trim(inBuffer));
    
    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
   
   // we have TWO items — ERROR-CHECK HERE
   if( data.length >= 2 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
   }
  }
} 

//-- change background to red if we have a button

void draw ( ) {  
  rectMode(CENTER);
  // every loop, look for serial information
  checkSerial();
  
  drawBackground();
  changeBgnBall();
  drawBall();
} 


// if input value is 1 (from ESP32, indicating a button has been pressed), change the background
void drawBackground() {
   if( switchValue == 1 )
    background( 255 );
  else
    background(0); 
}

//-- animate ball left to right, use potValue to change speed
void drawBall() {
    //fill(255,0,0);
    
     // set centre point
  translate(width/2, height/2);
  // rotate canvas using frame count
  rotate(radians(frameCount));
  // draw 5 petals, rotating after each one
  fill(#c6ff89); // green
  for (int i = 0; i < 5; i++) {
    //ellipse(xBallPos, -40, potValue, potValue );
    ellipse(0, -40, potValue, potValue );
    rotate(radians(72));
  }
  // centre circle
 fill(#fff9bb); // light yellow
  ellipse(0, 0, potValue, potValue );
  
    //ellipse( xBallPos, yBallPos, potValue, potValue );
    float speed = map(potValue, minPotValue, maxPotValue, minBallSize, maxBallSize);
    
    //-- change speed
    //xBallPos = xBallPos + (speed * direction);
    
    //-- make adjustments for boundaries
  //adjustBall();
}

//-- check for boundaries of ball and make adjustments for it to "bounce"
void adjustBall() {
  if( potValue > 200 ) {
    rect(100, 100, 100, potValue);
    rect(700, 500, 100, potValue);
  }
}

void changeBgnBall()
{
float r = random(255); // r is a random number between 0 - 255
float g = random(255); // g is a random number between 0 - 255
float b = random(255); // b is a random number between 0 - 255
  if(potValue<=100&& potValue>=10){
   background(r,g, b);
  }
   if(potValue>=100){
   fill(r, g, b);
  }
  
  if(potValue<=10){
   rotateFlower();
  }
}

void rotateFlower() {
  // set centre point
  translate(width/2, height/2);
  // rotate canvas using frame count
  rotate(radians(frameCount));
  // draw 5 petals, rotating after each one
  fill(#c6ff89); // green
  for (int i = 0; i < 5; i++) {
    ellipse(0, -40, 50, 50);
    rotate(radians(72));
  }
  // centre circle
  fill(#fff9bb); // light yellow
  ellipse(0, 0, 50, 50);
}
