// Jon Froehlich
// http://makeabilitylab.io

const int TOTAL_DIGITAL_INPUTS = 4;
const int  inversePin = 9;
const int  forwardPin = 10;
const int  playpausePin = 11;
const int  backPin = 12;

// global variables will change:
int buttonPushCounter[4] = {};                     //the counter to track the number of button presses in a loop
int buttonState[4] = {};                           //current state of the button
int lastButtonState[4] = {};                       //previous state of the button

void setup() {
  pinMode(inversePin, INPUT);                      //sets button as an input
  pinMode(forwardPin, INPUT);                      //sets button as an input
  pinMode(playpausePin, INPUT);                    //sets button as an input
  pinMode(backPin, INPUT);                         //sets button as an input
  Serial.begin(9600);
}

void loop() {
  // Go through all of the digital pins and print them to serial in a comma separated list
  for (int digitalInPin = 9; digitalInPin < (9 + TOTAL_DIGITAL_INPUTS); digitalInPin++) {
    buttonState[digitalInPin - inversePin] = digitalRead(digitalInPin);

    //
    //I used arduino code for setting up the button state change detection.
    //https://www.arduino.cc/en/Tutorial/StateChangeDetection

    // compare the buttonState to its previous state
    if (buttonState[digitalInPin - inversePin] != lastButtonState[digitalInPin - inversePin]) {
      // if the state has changed, increment the counter
      if (buttonState[digitalInPin - inversePin] == HIGH) {
        // if the current state is HIGH then the button was just pressed:
        buttonPushCounter[digitalInPin - inversePin]++; //increment the button push counter
      }
    }

    // read the pushbutton input pin:
    buttonState[digitalInPin - inversePin] = digitalRead(digitalInPin);    //it is either on or off

    // save the current state as the last state, for next time through the loop:
    lastButtonState[digitalInPin - inversePin] = buttonState[digitalInPin - inversePin];
  }

  //tilt ball switch
  if (buttonState[0] == 0) {
    Serial.print ("0");
    Serial.print(",");
  }
  else if (buttonState[0] == 1) {
    Serial.print ("1");
    Serial.print(",");
  }

  // << button
  Serial.print(buttonPushCounter[1]);
  Serial.print(",");

  // play / pause button
  Serial.print(buttonPushCounter[2]);
  Serial.print(",");

  // >> button
  Serial.print(buttonPushCounter[3]);
  
  Serial.println();
  
  delay(30);
}







