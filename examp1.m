graphics_toolkit('gnuplot')
figHandle = 0
figHandle = figure()
minmax = 32000/32768
nsecs = 10
rate = 11025.0
phasel = 0.0;    # left channel phase in circles (mult by 2*pi for trig)
phaser = 0.0;    # right channel phase
fbeginl = 30   # beginning frequency of left channel
fendl = 100     # ending frequency of left channel
fbeat = 3      # beat frequency
dutyfactor = 1.0/16.0
fbeginr = fbeginl + fbeat  # beginning frequency of right channel
fendr = fendl + fbeat      # ending frequency of right channel
nsamples = int32(nsecs*rate)
vl = zeros( nsamples, 1);
vr = zeros( nsamples, 1);
for n = 1:nsamples
  fracdone = n/double(nsamples);
  vl(n) = minmax * sin( 2*pi*phasel );
  phasel += ((1.0-fracdone)*fbeginl + (fracdone)*fendl) / rate;
  while (phasel > 1.0)
    phasel -= 1.0;
  endwhile
  if (phaser < dutyfactor)
    vr(n) = -minmax;
  else
    #vr(n) = minmax * dutyfactor / (1.0 - dutyfactor);
    vr(n) = minmax;
  endif
  phaser += ((1.0-fracdone)*fbeginr + (fracdone)*fendr) / rate;
  while (phaser > 1.0)
    phaser -= 1.0;
  endwhile
  #pause()
endfor
n = 1:nsamples;
#plot( n/rate, vl ), grid on %<--- plot a sinusoid
plot(n/rate, vl,"g", n/rate, vr,"r"), grid on
title('Chirps')
xlabel('TIME (sec)')
drawnow();
audiowrite('beat3Hz.wav',[vl, vr],rate)