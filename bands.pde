import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim; // audio package
AudioPlayer song; //plays one song
AudioSample sample;
FFT fft; // song analyzer

// volume score to determine some variable of curve
float volumeScore = 0;
float oldVolumeScore = volumeScore;
float scoreChangeRate = 25; // maximum slope of score change

Curve curve; // curve drawing object
Helper helper;

void setup()
{
  size(750,450);
  smooth();
  minim = new Minim(this); // allow minim to load files from data directory
  colorMode(HSB, 100);

  song = minim.loadFile("03 memories of ourselves with each other (ft.basil).mp3");
  song.play(0);
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  
  curve = new Curve();
  helper = new Helper();
}

float maxVolume = -1;
float minVolume = -1;

void draw()
{
  fft.forward(song.mix);
  oldVolumeScore = volumeScore; // save old volume score
  volumeScore = 0;
  //calculate new score
  for(int i = 0; i < fft.specSize(); i++)
  {
    volumeScore += fft.getBand(i);
    //println(fft.getBand(i));
  }
  volumeScore = volumeScore / fft.specSize();
  if (volumeScore > maxVolume || maxVolume == -1) {
    maxVolume = volumeScore;
    println("Range: " + minVolume + " -- " + maxVolume);
  }
  if (volumeScore < minVolume || minVolume == -1) {
    minVolume = volumeScore;
    println("Range: " + minVolume + " -- " + maxVolume);
  }
  // perhaps slow down rate of change
  curve.setVolumeScore(volumeScore);
  curve.update();
}