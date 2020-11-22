import processing.video.*;  //import the Processing video palyback library (required if playing video)
import processing.serial.*; // import the serial port library
Serial myPort;  // create a new variable of type Serial called myPort (can be called anything)

Movie videoA, videoB, videoC;   //defining variables of type Movie


float sensorValue1 = 0;  //we use float instaed of int to have smoother graphics/motion in Processing
float sensorValue2 = 0;
void setup() {
  size(360, 640);    //dimensions of the video files
  //make sure that the port number used below matches the one from your Arduino port
  myPort = new Serial (this, "/dev/cu.usbmodem141301", 9600); //set up the serial port
  myPort.bufferUntil ('\n'); //read data until recieving a Newline command
//for videos  
  videoA = new Movie (this, "videoA.mov"); //initializing the Movie variables
  videoA.loop();                           //play the video in loop
  videoB = new Movie (this, "videoB.mov");
  videoB.loop();
  videoC = new Movie (this, "videoC.mov");
  videoC.loop();
}

void draw() {
  background (255);
  //VIDEO CONTROLS
  if (sensorValue1 < 125) { //place the first video here 
   // float r = map(sensorValue1, 0, 255, 0.2, 1.5);
   // videoA.speed(r);
    image (videoA, 0, 0);
  } 
  else if (sensorValue1 < 301) { //place the second video here
   // float r = map(sensorValue1, 0, 255, 0.2, 1.5);
   // videoB.speed(r);
   image (videoB, 0, 0);
  } 
    else if (sensorValue1 > 300) { //place the second video here
   // float r = map(sensorValue1, 0, 255, 0.2, 1.5);
   // videoC.speed(r);
   image (videoC, 0, 0);
  } 
  println(sensorValue1);
  
}
 
void movieEvent(Movie video) { video.read(); } //required function to playback existing videos
 
void serialEvent (Serial port) { //this function constantly listens to the serial port
  sensorValue1 = int (port.readStringUntil('\n'));
  sensorValue2 = int (port.readStringUntil('\n'));//gets values from the serial port until it sees a newline command
}                                             //and cast (change) from String format to float
