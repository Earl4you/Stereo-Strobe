graphics_toolkit('gnuplot') # make graphics work on Windows platform
if (!exist("figHandle"))    # avoid new graph window each time
  figHandle = figure()
endif
minmax = 32000/32768        # avoid saturation because 2's compliment sucks
nsecs = 5                   # recording length in seconds
rate = 11025.0              # sample rate
phasel = 0.0;    # left channel phase in circles (mult by 2*pi for trig)
phaser = 0.0;    # right channel phase
fbeginl = 440   # beginning frequency of left channel
fendl = 440     # ending frequency of left channel
fbeat = 3      # beat frequency
dutyfactor = 1.0/32.0
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
title('Tones')
xlabel('TIME (sec)')
drawnow();
audiowrite('tones.wav',[vl, vr],rate)