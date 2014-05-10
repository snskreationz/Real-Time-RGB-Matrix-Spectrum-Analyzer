/*
     Arduino - Processing Real Time Spectrum Analyzer

This program is intended output a FFT from a pc on a RGB matrix
The program is based on the adafruit RGB matrix library: https://learn.adafruit.com/32x16-32x32-rgb-led-matrix/
The FFT results in the complimentary processing code handles 64 bands so the code calls for 2 panels, but can be modified for only one easily
More information, including full parts list and videos of the final product can be seen on 12vtronix.com
Youtube video sample: https://www.youtube.com/watch?v=X35HbE7k3DA

           Created: 22nd Sep 2013 by Stephen Singh
     Last Modified: 10th May 2014 by Stephen Singh
     
     Variables with the <-O-> symbol indicates that it can be adjusted for the reason specified

*/



#include <avr/pgmspace.h>
#include <Adafruit_GFX.h>   // Core graphics library
#include <RGBmatrixPanel.h> // Hardware-specific library

#define CLK 8  // MUST be on PORTB!
#define LAT A3
#define OE  9
#define A   A0
#define B   A1
#define C   A2
// Last parameter = 'true' enables double-buffering, for flicker-free,
// buttery smooth animation.  Note that NOTHING WILL SHOW ON THE DISPLAY
// until the first call to swapBuffers().  This is normal.
RGBmatrixPanel matrix(A, B, C, CLK, LAT, OE, true);



// <-O-> the values after "matrix.Color333" represent the RGB values with 7 being the brightest value for that particular colour

void lightcolumns(int rownum, int amplitude)
{
  if(amplitude>15)  // <-O-> set the threshold for the band to turn red
  {
  for( int y = 0; y < amplitude; y++){
  matrix.drawPixel(rownum, y, matrix.Color333(7, 0, 0));
  }
  for(int y = amplitude; y <16; y++)
  {
  matrix.drawPixel(rownum, y, matrix.Color333(0, 0, 0));  
  }
  }
  
  else if(amplitude>13) // <-O-> set the threshold for the band to turn yellow
  {
  for( int y = 0; y < amplitude; y++){
  matrix.drawPixel(rownum, y, matrix.Color333(4, 4, 0));
  }
  for(int y = amplitude; y < 16; y++)
  {
  matrix.drawPixel(rownum, y, matrix.Color333(0, 0, 0));  
  }
  }
  
  else if(amplitude>9) // <-O-> set the threshold for the band to turn green
  {
  for( int y = 0; y < amplitude; y++){
  matrix.drawPixel(rownum, y, matrix.Color333(0, 5, 0));
  }
  for(int y = amplitude; y < 16; y++)
  {
  matrix.drawPixel(rownum, y, matrix.Color333(0, 0, 0));  
  }
  } 
  
  else
  {
  for( int y = 0; y < amplitude; y++){
  matrix.drawPixel(rownum, y, matrix.Color333(0, 0, 7));
  }
  for(int y = amplitude; y < 16; y++)
  {
  matrix.drawPixel(rownum, y, matrix.Color333(0, 0, 0));  
  }
  } 
}


void setup() 
{ 
  matrix.begin();  
  Serial.begin(115200);
  delay(1000);
}





void loop() {


if(Serial.read() == ('M')) 
{
    int led1 = Serial.parseInt();    
    int led2 = Serial.parseInt(); 
    int led3 = Serial.parseInt();  
    int led4 = Serial.parseInt(); 
    int led5 = Serial.parseInt(); 
    int led6 = Serial.parseInt();  
    int led7 = Serial.parseInt(); 
    int led8 = Serial.parseInt(); 
    int led9 = Serial.parseInt();    
    int led10 = Serial.parseInt(); 
    int led11 = Serial.parseInt();  
    int led12 = Serial.parseInt(); 
    int led13 = Serial.parseInt(); 
    int led14 = Serial.parseInt();  
    int led15 = Serial.parseInt(); 
    int led16 = Serial.parseInt(); 
    int led17 = Serial.parseInt();    
    int led18 = Serial.parseInt(); 
    int led19 = Serial.parseInt();  
    int led20 = Serial.parseInt(); 
    int led21 = Serial.parseInt(); 
    int led22 = Serial.parseInt();  
    int led23 = Serial.parseInt(); 
    int led24 = Serial.parseInt(); 
    int led25 = Serial.parseInt();  
    int led26 = Serial.parseInt(); 
    int led27 = Serial.parseInt();  
    int led28 = Serial.parseInt(); 
    int led29 = Serial.parseInt(); 
    int led30 = Serial.parseInt();  
    int led31 = Serial.parseInt(); 
    int led32 = Serial.parseInt(); 
    
    if (Serial.read() == '\n') 
    {     
      lightcolumns(31, led1);
      lightcolumns(30, led2);
      lightcolumns(29, led3);
      lightcolumns(28, led4);
      lightcolumns(27, led5);
      lightcolumns(26, led6);
      lightcolumns(25, led7);
      lightcolumns(24, led8);
      lightcolumns(23, led9);
      lightcolumns(22, led10);
      lightcolumns(21, led11);
      lightcolumns(20, led12);
      lightcolumns(19, led13);
      lightcolumns(18, led14);
      lightcolumns(17, led15);
      lightcolumns(16, led16);
      lightcolumns(15, led17);
      lightcolumns(14, led18);
      lightcolumns(13, led19);
      lightcolumns(12, led20);
      lightcolumns(11, led21);
      lightcolumns(10, led22);
      lightcolumns(9, led23);
      lightcolumns(8, led24);
      lightcolumns(7, led25);
      lightcolumns(6, led26);
      lightcolumns(5, led27);
      lightcolumns(4, led28);
      lightcolumns(3, led29);
      lightcolumns(2, led30);
      lightcolumns(1, led31);
      lightcolumns(0, led32);

      matrix.swapBuffers(false);
    }
  }
}
