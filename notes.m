# parameters
fBase = 27.5              # frequency of base A note (A440 = note 48)
fileName = 'notes3Hz.wav' # output sampled data file name
noteHold = 5.0/8.0        # seconds to hold each note (Andante)
rate = 44100.0            # sample rate
beginNote = 0             # start with A27.5 note
numbNotes = 25            # 2 octaves including final
fBeat = 3                 # beat frequency
dutyFactor = 1.0/16.0     # ON portion of strobe cycle
minmax = 32000/32768      # avoid saturation because 2's compliment sucks

# initialize
samplesPerNote = round(rate*noteHold)
nSamples = samplesPerNote*numbNotes
vL = vR = zeros( nSamples, 1); # vectors of samples
phaseL = phaseR = 0.0;    # phases, in circles (mult by 2*pi for trig)

# generate left & right vectors of samples
n = 1; # sample number
note = 0;
while note < numbNotes
  f = 2**(note/12) * fBase;  # frequency for the current note
  while n <= (note+1)*samplesPerNote
    ##### left channel #######################
    vL(n) = minmax * sin( 2*pi*phaseL ); # left channel voltage
    phaseL += f / rate;   # increment the left channel phase
    while (phaseL > 1.0) phaseL -= 1.0; endwhile # phaseL wrap
    ##### right channel ######################
    if (phaseR < dutyFactor)
      vR(n) = -minmax;
    else
      vR(n) = minmax;
    endif
    phaseR += (f + fBeat) / rate;  # increment the right channel phase
    while (phaseR > 1.0) phaseR -= 1.0; endwhile # phaseR wrap
    n += 1;
  endwhile # n
  note += 1;
endwhile # note
audiowrite(fileName, [vL, vR], rate)

graphics_toolkit('gnuplot') # make graphics work on Windows platform
if (!exist("figHandle")) figHandle = figure(); endif # avoid new graphs
abscissa = 1:nSamples;
plot(abscissa/rate, vL,"g", abscissa/rate, vR,"r"), grid on
title('Chirps'), xlabel('TIME (sec)'), drawnow();