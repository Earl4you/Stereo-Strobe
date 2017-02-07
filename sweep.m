graphics_toolkit('gnuplot') # make graphics work on Windows platform
if (!exist("figHandle"))  # avoid new graph window each time
  figHandle = figure()
endif

# parameters
filename = 'beat3Hz.wav'  # output sampled data file name
nsecs = 10                # recording length in seconds
rate = 11025.0            # sample rate
fbeginl = 30              # beginning frequency of left channel
fendl = 100               # ending frequency of left channel
fbeat = 3                 # beat frequency
dutyfactor = 1.0/16.0     # ON portion of strobe cycle
minmax = 32000/32768      # avoid saturation because 2's compliment sucks

# initialize
nsamples = int32(nsecs*rate)
fbeginr = fbeginl + fbeat # beginning frequency of right channel
fendr = fendl + fbeat     # ending frequency of right channel
vl = zeros( nsamples, 1);
vr = zeros( nsamples, 1);
phasel = 0.0;             # left channel phase in circles
                          # (mult by 2*pi for trig)
phaser = 0.0;             # right channel phase

# generate vectors of samples
for n = 1:nsamples
  fracdone = n/double(nsamples);       # fraction of sweep completed
  # left channel
  vl(n) = minmax * sin( 2*pi*phasel ); # left channel voltage
  # increment the left phase
  phasel += ((1.0-fracdone)*fbeginl + (fracdone)*fendl) / rate;
  while (phasel > 1.0)     # wrap the left phase
    phasel -= 1.0;
  endwhile
  # right channel
  if (phaser < dutyfactor)
    vr(n) = -minmax;
  else
    vr(n) = minmax;
  endif
  # increment the right channel phase
  phaser += ((1.0-fracdone)*fbeginr + (fracdone)*fendr) / rate;
  while (phaser > 1.0)     # wrap right channel phase
    phaser -= 1.0;
  endwhile
  #pause()
endfor
n = 1:nsamples;
plot(n/rate, vl,"g", n/rate, vr,"r"), grid on
title('Chirps')            # title on graph
xlabel('TIME (sec)')
drawnow();
audiowrite(filename, [vl, vr], rate)