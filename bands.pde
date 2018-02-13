import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;

Minim minim; // audio package
Song[] album; // song controller
int currentSong;
final int numSongs = 2;
CurveDrawer drawer; // CurveDrawer drawing object
Helper helper;

enum Mode {PLAY, PAUSE};
Mode currentMode;

void setup()
{
  // setup the screen
  size(960,540);
  //fullScreen();
  smooth();
  colorMode(HSB, 100);

  minim = new Minim(this); // allow minim to load files from data directory
  
  currentMode = Mode.PAUSE;
  
  helper = new Helper();

  // initialize album
  album = new Song[numSongs];
  album[0] = new Song("01 lonely boy with a toy ukulele.mp3");
  album[1] = new Song("02 i stand alone in this empty hall.mp3");
  //album[2] = new Song("03 memories of ourselves with each other (ft.basil).mp3");
  //album[3] = new Song("04 again.mp3");
  //album[4] = new Song("05 HOGGINTHEGAME.mp3");
  //album[5] = new Song("06 i sat with you with cigarettes and beer looking at the stars.mp3");
  //album[6] = new Song("07 octn,tomppa - this time.mp3");
  
  currentSong = 0;
  drawer = new CurveDrawer(album[currentSong].getSeeds(), album[currentSong].getMaxVolume());
}

void draw()
{
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
  album[currentSong].pause();
  currentSong = trackNum;
  drawer.removeCurrentCurve();
  drawer.seed(album[currentSong].getSeeds(), album[currentSong].getMaxVolume());

  album[currentSong].play(0);
}

void keyPressed() {
  switch (key) {
    case 'm':
      drawer.modeCycle();
      return;
    case '9':
      album[currentSong].play(album[currentSong].getLength() / 10 * 9);
      return;
    case 'd':
      drawer.toggleDebug();
      return;
    case 'p':
    case ' ':
      currentMode = (currentMode == Mode.PLAY) ? Mode.PAUSE : Mode.PLAY;
      drawer.pause();
      if (currentMode == Mode.PAUSE) {
        album[currentSong].pause();
      } else {
        album[currentSong].loop();
      }
      return;
    default:
      break;
  }
  
  switch (keyCode) {    
    case RIGHT:
      switchToTrack((currentSong + 1) % numSongs);
      return;
    case LEFT:
      if (album[currentSong].position() >= 2000)
        switchToTrack(currentSong);
      else
        switchToTrack((currentSong - 1 + numSongs) % numSongs);
      return;
    default:
      break;
  }
}