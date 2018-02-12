class Song {
  AudioPlayer player; //plays one song
  FFT playerFFT; // player analyzer
  
  // volume score to determine some variable of curve
  float volumeScore = 0;
  float oldVolumeScore = volumeScore;
  
  float maxVolume;
  float seed1, seed2; // seeds for bezier curve
  
  Song(String name) {
    seed1 = seed2 = -1.0;
    analyzeUsingAudioSample(name);
    player = minim.loadFile(name);
    playerFFT = new FFT(player.bufferSize(), player.sampleRate());
  }
  
  void play(int location) {
    player.play(location);
  }
  
  boolean isPlaying() {
    return player.isPlaying();
  }
  void update() {
    playerFFT.forward(player.mix);
    oldVolumeScore = volumeScore; // save old volume score
    volumeScore = 0;
    //calculate new score
    for(int i = 0; i < playerFFT.specSize(); i++)
    {
      volumeScore += playerFFT.getBand(i);
    }
    volumeScore = volumeScore / playerFFT.specSize();
  }
  
  float getVolumeScore() {
    return volumeScore;
  }
  float getMaxVolume() {
    return maxVolume;
  }
  int getLength() {
    return player.length();
  }
  float[] getSeeds() {
    float[] seeds = {seed1, seed2};
    return seeds;
  }
  
  private void analyzeUsingAudioSample(String songName)
  {
    maxVolume = -1;
      
    AudioSample song = minim.loadSample(songName);
     
    float[] leftChannel = song.getChannel(AudioSample.LEFT); // maybe should get all audio?
     
    float[] fftSamples = new float[song.bufferSize()];
    FFT fft = new FFT(song.bufferSize(), song.sampleRate() );
    
    // now we'll analyze the samples in chunks
    int totalChunks = (leftChannel.length / song.bufferSize()) + 1;
    
    for(int chunkIdx = 0; chunkIdx < totalChunks; ++chunkIdx)
    {
      if (chunkIdx == (totalChunks / 2)) {
      }
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
      }
    }
    seed1 = (float)(totalChunks % 100) / 100;
    seed2 = (maxVolume % 1);
    println("analysis finished");
    song.close(); 
  }
}