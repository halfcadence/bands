import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;

Minim minim; // audio package
Song song; // song controller

CurveDrawer drawer; // CurveDrawer drawing object
Helper helper;

void setup()
{
  size(750,450);
  //fullScreen();
  smooth();
  minim = new Minim(this); // allow minim to load files from data directory
  colorMode(HSB, 100);
  
  song = new Song("03 memories of ourselves with each other (ft.basil).mp3");
  song.play(80000);
  drawer = new CurveDrawer(song.getSeeds(), song.getMaxVolume());
  helper = new Helper();
}

void draw()
{
  keepSongPlaying();
  song.update();
  drawer.setVolumeScore(song.getVolumeScore());
  drawer.update();
}

void keepSongPlaying() {
  if (!song.isPlaying()) {
    song.play(0);
    background(100);
  }
}

void keyPressed() {
  switch (key) {
    case '9':
      song.play(song.getLength() / 10 * 9);
      break;
    default:
      break;
  }
}