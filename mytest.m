Fs = 48000;
t = 0:1/Fs:1;
makeSignal = @(A, f, phi) A*sin(2*pi*f*t + phi);
X = makeSignal(1, 10, 0);
X2 = makeSignal(1, 10000, 0);
scale = 2.4e4;
subplot(411);
plot(t, X);
subplot(412);
plot(linspace(-Fs/2, Fs/2, length(X)), fftshift(abs(fft(X)))/scale);

subplot(413);
plot(t, X2);
subplot(414);
plot(linspace(-Fs/2, Fs/2, length(X2)), fftshift(abs(fft(X2)))/scale);
