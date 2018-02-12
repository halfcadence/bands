import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;

Minim minim; // audio package
AudioPlayer song; //plays one song
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
  
  analyzeUsingAudioSample("03 memories of ourselves with each other (ft.basil).mp3");

  song = minim.loadFile("03 memories of ourselves with each other (ft.basil).mp3");
  song.play(0);
  println("buffer size: " + song.bufferSize() + ", sample rate: " + song.sampleRate());
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  curve = new Curve();
  helper = new Helper();
}

float maxVolume;
float minVolume;

void draw()
{
  minVolume = -1;
  maxVolume = -1;
  fft.forward(song.mix);
  oldVolumeScore = volumeScore; // save old volume score
  volumeScore = 0;
  //calculate new score
  for(int i = 0; i < fft.specSize(); i++)
  {
    volumeScore += fft.getBand(i);
  }
  volumeScore = volumeScore / fft.specSize();
  if (volumeScore > maxVolume || maxVolume == -1) {
    maxVolume = volumeScore;
    // println("Range: " + minVolume + " -- " + maxVolume);
  }
  if (volumeScore < minVolume || minVolume == -1) {
    minVolume = volumeScore;
    // println("Range: " + minVolume + " -- " + maxVolume);
  }
  // perhaps slow down rate of change
  curve.setVolumeScore(volumeScore);
  curve.update();
}

void analyzeUsingAudioSample(String songName)
{
   minVolume = -1;
   maxVolume = -1;
    
  AudioSample song = minim.loadSample(songName);
   
  float[] leftChannel = song.getChannel(AudioSample.LEFT); // maybe should get all audio?
   
  float[] fftSamples = new float[song.bufferSize()];
  FFT fft = new FFT(song.bufferSize(), song.sampleRate() );
  
  // now we'll analyze the samples in chunks
  int totalChunks = (leftChannel.length / song.bufferSize()) + 1;
 
  for(int chunkIdx = 0; chunkIdx < totalChunks; ++chunkIdx)
  {
    int chunkStartIndex = chunkIdx * song.bufferSize();
   
    // the chunk size will always be fftSize, except for the 
    // last chunk, which will be however many samples are left in source
    int chunkSize = min( leftChannel.length - chunkStartIndex, song.bufferSize() );
   
    // copy first chunk into our analysis array
    System.arraycopy( leftChannel, // source of the copy
               chunkStartIndex, // index to start in the source
               fftSamples, // destination of the copy
               0, // index to copy to
               chunkSize // how many samples to copy
              );
      
    // if the chunk was smaller than the fftSize, we need to pad the analysis buffer with zeroes        
    if ( chunkSize < song.bufferSize() )
    {
      // we use a system call for this
      java.util.Arrays.fill( fftSamples, chunkSize, fftSamples.length - 1, 0.0 );
    }
    
    // now analyze this buffer
    fft.forward( fftSamples );
    
    volumeScore = 0;
    // and copy the resulting spectrum into our spectra array
    for(int i = 0; i < fft.specSize(); i++)
    {
      volumeScore += fft.getBand(i);
    }
    volumeScore = volumeScore / fft.specSize();
    if (volumeScore > maxVolume || maxVolume == -1) {
      maxVolume = volumeScore;
      println("                    max: " + maxVolume);
    }
    if (volumeScore < minVolume || minVolume == -1) {
      minVolume = volumeScore;
      println("min: " + minVolume);
    }
  }
  println("analysis finished");
  song.close(); 
}