import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;
import processing.serial.*;

Serial _serialPort;
int _data [] = new int[4];
int buttonPressRewind;
int buttonPressForward;
int buttonPlayPause;
int indexInverse = 0;
int indexRewind = 3;
int indexPlayPause = 2;
int indexForward = 1;


Minim minim; // audio package
Song[] album; // song controller
int currentSong;
final int numSongs = 7;
CurveDrawer drawer; // CurveDrawer drawing object
Helper helper;
enum Mode {PLAY, PAUSE};
Mode currentMode;

void setup()
{
  _serialPort = new Serial(this, Serial.list()[3], 9600);
  _serialPort.bufferUntil('\n');
  buttonPressRewind = _data[indexRewind];
  buttonPressForward = _data[indexForward];
  buttonPlayPause = _data[indexPlayPause];
  // setup the screen
  //size(960,540);
  fullScreen();
  smooth();
  colorMode(HSB, 100);
  
  minim = new Minim(this); // allow minim to load files from data directory
  
  currentMode = Mode.PAUSE;
  
  helper = new Helper();

  // initialize album
  album = new Song[numSongs];
  album[0] = new Song("01 lonely boy with a toy ukulele.mp3");
  album[1] = new Song("02 i stand alone in this empty hall.mp3");
  album[2] = new Song("03 memories of ourselves with each other (ft.basil).mp3");
  album[3] = new Song("04 again.mp3");
  album[4] = new Song("05 HOGGINTHEGAME.mp3");
  album[5] = new Song("06 i sat with you with cigarettes and beer looking at the stars.mp3");
  album[6] = new Song("07 octn,tomppa - this time.mp3");
  
  currentSong = 0;
  drawer = new CurveDrawer(album[currentSong].getSeeds(), album[currentSong].getMaxVolume());
}

void draw()
{
  println(_data);
  
  // arduino data
  // 0 Tilt Ball Switch (Pull-up Resistor)
  if (_data[indexInverse] == 1) drawer.setMode(0);
  else drawer.setMode(1);
  
  // 1 <<
  if (_data[indexRewind] > buttonPressRewind) {
    rewind();
    buttonPressRewind++;
  }
  
  if (_data[indexPlayPause] > buttonPlayPause) {
    playPause();
    buttonPlayPause++;
  }

  // 3 >>
  if (_data[indexForward] > buttonPressForward) {
    forward();
    buttonPressForward++;
  }

  keepTrackPlaying();
  if (currentMode == Mode.PLAY) {
    album[currentSong].update();
    drawer.setVolumeScore(album[currentSong].getVolumeScore());
  }
  drawer.update();
}

void keepTrackPlaying() {
  if (currentMode == Mode.PLAY && !album[currentSong].isPlaying()) {
    switchToTrack((currentSong + 1) % numSongs);
  }
}

void switchToTrack(int trackNum) {
  if (album[currentSong].isPlaying()) {
    album[currentSong].pause();
  }
  currentSong = trackNum;
  drawer.removeCurrentCurve();
  drawer.seed(album[currentSong].getSeeds(), album[currentSong].getMaxVolume());
  
  if (currentMode == Mode.PLAY) {
    album[currentSong].play(0);
  }
  //else
    //album[currentSong].cue(0);
}

void playPause() {
  currentMode = (currentMode == Mode.PLAY) ? Mode.PAUSE : Mode.PLAY;
  drawer.pause();
  if (currentMode == Mode.PAUSE) {
    album[currentSong].pause();
  } else {
    album[currentSong].loop();
  }
}

void rewind() {
  if (album[currentSong].position() >= 2000)
    switchToTrack(currentSong);
  else
    switchToTrack((currentSong - 1 + numSongs) % numSongs);
}

void forward() {
  switchToTrack((currentSong + 1) % numSongs);
}
void keyPressed() {
  switch (key) {
    case '0':
      drawer.setMode(0);
      return;
    case '1':
      drawer.setMode(1);
      return;
    case '9':
      album[currentSong].play(album[currentSong].getLength() / 10 * 9);
      return;
    case 'd':
      drawer.toggleDebug();
      return;
    case 'p':
    case ' ':
      playPause();
      return;
    default:
      break;
  }
  
  switch (keyCode) {    
    case RIGHT:
      forward();
      return;
    case LEFT:
      rewind();
      return;
    default:
      break;
  }
}

void serialEvent (Serial myPort) {
  try {
    String inString = _serialPort.readStringUntil('\n');
    inString = trim(inString);
    
    // Split the comma separated data into individual values
    _data = int(split(inString, ','));
  }
  catch(Exception e) {
    println(e);
  }
}