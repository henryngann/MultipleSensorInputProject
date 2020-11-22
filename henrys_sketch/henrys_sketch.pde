import processing.serial.*;
import processing.video.*;
Serial myPort;
Movie videoA, videoB, videoC;   //defining variables of type Movie
int linefeed = 10;   // Linefeed in ASCII
int numSensors = 2;  // we will be expecting for reading data from four sensors
int sensors[];       // array to read the 4 values
int pSensors[];      // array to store the previuos reading, usefur for comparing
// actual reading with the last one

void setup() {
  size(360, 640);
  // List all the available serial ports in the output pane.
  // You will need to choose the port that the Wiring board is
  // connected to from this list. The first port in the list is
  // port #0 and the third port in the list is port #2.
  println(Serial.list());

  myPort = new Serial(this,"/dev/cu.usbmodem141301", 9600);
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil(linefeed);
  //
  videoA = new Movie (this, "videoA.mov"); //initializing the Movie variables
  videoA.loop();                           //play the video in loop
  videoB = new Movie (this, "videoB.mov");
  videoB.loop();
  videoC = new Movie (this, "videoC.mov");
  videoC.loop();
}

void draw() {
  if ((pSensors != null)&&(sensors != null)) {

    // if valid data arrays are not null
    // compare each sensor value with the previuos reading
    // to establish change

    for (int i=0; i < numSensors; i++) {
      float f = sensors[i] - pSensors[i];  // actual - previous value
      if (f > 0) {
      //  println("sensor "+i+" increased by "+f);  // value increased
      }
      if (f < 0) {
      //  println("sensor "+i+" decreased by "+f);  // value decreased
      }
    }

    // now do something with the values read sensors[0] .. sensors[3]
if (sensors[0] < 125) { //place the first video here 
    float r = map(sensors[1], 0, 255, 0.2, 1.5);
    videoA.speed(r);
    image (videoA, 0, 0);
  } 
  else if (sensors[0] < 301) { //place the second video here
    float r = map(sensors[1], 0, 255, 0.2, 1.5);
    videoB.speed(r);
   image (videoB, 0, 0);
  } 
    else if (sensors[0] > 300) { //place the second video here
    float r = map(sensors[1], 0, 255, 0.2, 1.5);
    videoC.speed(r);
   image (videoC, 0, 0);
  } 
  }

}
void movieEvent(Movie video) { video.read(); }
void serialEvent(Serial myPort) {

  // read the serial buffer:
  String myString = myPort.readStringUntil(linefeed);

  // if you got any bytes other than the linefeed:
  if (myString != null) {

    myString = trim(myString);

    // split the string at the commas
    // and convert the sections into integers:

    pSensors = sensors;
    sensors = int(split(myString, ','));

    // print out the values you got:

    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
      print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
    }

    // add a linefeed after all the sensor values are printed:
    println();

  }
}
