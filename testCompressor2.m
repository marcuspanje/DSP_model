Fs = 48000;
t = 0:1/Fs:1;
makeSignal = @(A, f, phi)A*sin(2*pi*f*t + phi);
X = makeSignal(10, 100, 0);
x = [-90 -5 6];
y = [-90 -5 6];

[Y, XdB, YdB] = Compressor(X, x, y, 0, 0, 0);

subplot(411)
plot(linspace(-Fs/2, Fs/2,  length(X)), fftshift(abs(fft(X))));

subplot(412)
plot(t, X);

subplot(413)
plot(linspace(-Fs/2, Fs/2, length(X)), fftshift(abs(fft(Y))));

subplot(414)
plot(t, Y)
