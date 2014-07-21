x = 0:1:10;
f = 1;
w = 2*pi*f;
y = 5*sin(w*x);
z = abs(fft(y));

len = size(z);
len = len(2);

freqs = 0:0.5/10:0.5;
plot(freqs, z);
