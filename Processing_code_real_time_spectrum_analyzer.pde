/*
     Arduino - Processing Real Time Spectrum Analyzer

This program is intended to do a FFT on incoming audio signal for a line-in input on PC 
The program is based on http://processing.org/learning/libraries/forwardfft.html
The FFT results are sent to two arduinos via a string of 32 integers
More information, including full parts list and videos of the final product can be seen on 12vtronix.com
Youtube video sample: https://www.youtube.com/watch?v=X35HbE7k3DA

           Created: 22nd Sep 2013 by Stephen Singh
     Last Modified: 10th May 2014 by Stephen Singh
     
     Variables with the <-O-> symbol indicates that it can be adjusted for the reason specified

*/
 
import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.serial.*; 
 
Serial port1; 
Serial port2;
 
Minim minim;
AudioInput in;
FFT fft;

int buffer_size = 4096; 
float sample_rate = 200000;

int freq_width = 250; // <-O-> set the frequency range for each band over 400hz. larger bands will have less intensity per band. smaller bands would result in the overall range being limited

//arrays to hold the 64 bands' data
int[] freq_array = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
float[] freq_height = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

void setup()
{
  size(200, 200);

  minim = new Minim(this);
  port1 = new Serial(this, "COM26" , 115200); // <-O-> set baud rate and port for first RGB matrix
  port2 = new Serial(this, "COM42" , 115200); // <-O-> set baud rate and port for second RGB matrix
 
  in = minim.getLineIn(Minim.MONO,buffer_size,sample_rate);
 
  // create an FFT object that has a time-domain buffer 
  // the same size as line-in's sample buffer
  fft = new FFT(in.bufferSize(), in.sampleRate());
  // Tapered window important for log-domain display
  fft.window(FFT.HAMMING);
}


void draw()
{
for(int k=0; k<64; k++){
freq_array[k] = 0;
}

  // perform a forward FFT on the samples in input buffer
  fft.forward(in.mix);
  
  
  freq_height[0] = fft.calcAvg((float) 0, (float) 30);
  freq_height[1] = fft.calcAvg((float) 31, (float) 60);
  freq_height[2] = fft.calcAvg((float) 61, (float) 100);
  freq_height[3] = fft.calcAvg((float) 101, (float) 150);
  freq_height[4] = fft.calcAvg((float) 151, (float) 200);
  freq_height[5] = fft.calcAvg((float) 201, (float) 250);
  freq_height[6] = fft.calcAvg((float) 251, (float) 300);
  freq_height[7] = fft.calcAvg((float) 301, (float) 350);
  freq_height[8] = fft.calcAvg((float) 351, (float) 400);
  
  for(int n = 9; n < 64; n++)
  {
  freq_height[n] = fft.calcAvg((float) (351+(freq_width*(n-9))), (float) (500+(freq_width*(n-9))));
  }
  
  freq_height[64] = (fft.calcAvg((float) 20, (float) 60));
  
  
  // <-O-> Log scaling function. Feel free to adjust x and y
  
  float x = 8;
  float y = 3;
  for(int j=0; j<64; j++){    
    freq_height[j] = freq_height[j]*(log(x)/y);
    x = x + (x); 
  }
  

   

// Amplitude Ranges  if else tree
    for(int j=0; j<65; j++){    
    if (freq_height[j] < 2000 && freq_height[j] > 180){freq_array[j] = 16;}
    else{ if (freq_height[j] <= 180 && freq_height[j] > 160){freq_array[j] = 15;}
    else{ if (freq_height[j] <= 160 && freq_height[j] > 130){freq_array[j] = 14;}
    else{ if (freq_height[j] <= 130 && freq_height[j] > 110){freq_array[j] = 13;}
    else{ if (freq_height[j] <= 110 && freq_height[j] > 90){freq_array[j] = 12;}
    else{ if (freq_height[j] <= 90 && freq_height[j] > 70){freq_array[j] = 11;}
    else{ if (freq_height[j] <= 70 && freq_height[j] > 60){freq_array[j] = 10;}
    else{ if (freq_height[j] <= 60 && freq_height[j] > 50){freq_array[j] = 9;}
    else{ if (freq_height[j] <= 50 && freq_height[j] > 40){freq_array[j] = 8;}
    else{ if (freq_height[j] <= 40 && freq_height[j] > 30){freq_array[j] = 7;}
    else{ if (freq_height[j] <= 30 && freq_height[j] > 20){freq_array[j] = 6;}
    else{ if (freq_height[j] <= 20 && freq_height[j] > 15){freq_array[j] = 5;}
    else{ if (freq_height[j] <= 15 && freq_height[j] > 11){freq_array[j] = 4;}
    else{ if (freq_height[j] <= 11 && freq_height[j] > 8){freq_array[j] = 3;}
    else{ if (freq_height[j] <= 8 && freq_height[j] > 5){freq_array[j] = 2;}
    else{ if (freq_height[j] <= 5 && freq_height[j] > 2){freq_array[j] = 1;}
    else{ if (freq_height[j] <= 2 && freq_height[j] > 0){freq_array[j] = 0;}
  }}}}}}}}}}}}}}}}}
  
  // organize and send the data 
  
    String sta = "M";
    String aa = str(freq_array[0]);
    String bb = str(freq_array[1]);
    String cc = str(freq_array[2]);
    String dd = str(freq_array[3]);
    String ee = str(freq_array[4]);
    String ff = str(freq_array[5]);
    String gg = str(freq_array[6]);
    String hh = str(freq_array[7]);
    String ii = str(freq_array[8]);
    String jj = str(freq_array[9]);
    String kk = str(freq_array[10]);
    String ll = str(freq_array[11]);
    String mm = str(freq_array[12]);
    String nn = str(freq_array[13]);
    String oo = str(freq_array[14]);
    String pp = str(freq_array[15]);
    String qq = str(freq_array[16]);
    String rr = str(freq_array[17]);
    String ss = str(freq_array[18]);
    String tt = str(freq_array[19]);
    String uu = str(freq_array[20]);
    String vv = str(freq_array[21]);
    String ww = str(freq_array[22]);
    String xx = str(freq_array[23]);
    String yy = str(freq_array[24]);
    String zz = str(freq_array[25]);
    String aaa = str(freq_array[26]);
    String bbb = str(freq_array[27]);
    String ccc = str(freq_array[28]);
    String ddd = str(freq_array[28]);
    String eee = str(freq_array[30]);
    String fff = str(freq_array[31]);
    
    
    String xaa = str(freq_array[32]);
    String xbb = str(freq_array[33]);
    String xcc = str(freq_array[34]);
    String xdd = str(freq_array[35]);
    String xee = str(freq_array[36]);
    String xff = str(freq_array[37]);
    String xgg = str(freq_array[38]);
    String xhh = str(freq_array[39]);
    String xii = str(freq_array[40]);
    String xjj = str(freq_array[41]);
    String xkk = str(freq_array[42]);
    String xll = str(freq_array[43]);
    String xmm = str(freq_array[44]);
    String xnn = str(freq_array[45]);
    String xoo = str(freq_array[46]);
    String xpp = str(freq_array[47]);
    String xqq = str(freq_array[48]);
    String xrr = str(freq_array[49]);
    String xss = str(freq_array[50]);
    String xtt = str(freq_array[51]);
    String xuu = str(freq_array[52]);
    String xvv = str(freq_array[53]);
    String xww = str(freq_array[54]);
    String xxx = str(freq_array[55]);
    String xyy = str(freq_array[56]);
    String xzz = str(freq_array[57]);
    String xaaa = str(freq_array[58]);
    String xbbb = str(freq_array[59]);
    String xccc = str(freq_array[60]);
    String xddd = str(freq_array[61]);
    String xeee = str(freq_array[62]);
    String xfff = str(freq_array[63]);
    String com = ",";
    String newl = "\n";
    
    String send1 = sta + aa + com + bb + com + cc + com + dd + com + ee + com + ff + com + gg + com + hh + com + ii + com + jj + com + kk + com + ll + com + mm + com + nn + com + oo + com + pp + com + qq + com + rr + com + ss + com + tt + com + uu + com + vv + com + ww + com + xx + com + yy + com + zz + com + aaa + com + bbb + com + ccc + com + ddd + com + eee + com + fff + newl;
    port1.write(send1);
    
    String send2 = sta + xaa + com + xbb + com + xcc + com + xdd + com + xee + com + xff + com + xgg + com + xhh + com + xii + com + xjj + com + xkk + com + xll + com + xmm + com + xnn + com + xoo + com + xpp + com + xqq + com + xrr + com + xss + com + xtt + com + xuu + com + xvv + com + xww + com + xxx + com + xyy + com + xzz + com + xaaa + com + xbbb + com + xccc + com + xddd + com + xeee + com + xfff + newl;
    port2.write(send2);
}
 
 
void stop()
{
  // always close Minim audio classes when you finish with them
  in.close();
  minim.stop();
 
  super.stop();
}


