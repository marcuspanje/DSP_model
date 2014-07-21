Fs = 48000;
t = 0:1/Fs:5;

f = 1000;
swth = sawtooth(2*pi*f*t);
plot(t, swth);
