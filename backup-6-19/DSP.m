%top level control for processing simulation

%input signal
Fs = 48000; %sampling frequency
t = 0:1/Fs:3;

%anon function to generate signal
%f = frequency, A = max ampl, phi = phase in degrees
makeSignal = @(f, A, phi) A*sin(2*pi*f*t + degtorad(phi));
X1 = makeSignal(80, 10, 90);
X2 = makeSignal(2500, 5, 0);
X3 = makeSignal(20000, 10, 0);

X = X1 + X2 + X3;

%function for bandpass filtering
%BPassFilter(X, N, F3dB1, F3dB2, Fs)
% X = input signal, N = order, Fs = sampling freq
F3dB1 = 800;
F3dB2 = 7200;
Y = BPassFilter(X, 2, F3dB1, F3dB2, Fs);

subplot(311);
plot(linspace(-Fs/2, Fs/2, length(X)), fftshift(abs(fft(X))));
a = axis;
xlabel('frequency/Hz');
ylabel('X - unfiltered');

subplot(312);
plot(linspace(-Fs/2, Fs/2, length(Y)), fftshift(abs(fft(Y))));
axis(a);
xlabel('frequency/Hz');
ylabel('Y - filtered');

subplot(313);
plot((1:length(X))/Fs, X, (1:length(Y))/Fs, Y);
xlabel('time/s');
legend('X', 'Y');

X_1 = makeSignal(2000, 5, 0);
X_2 = makeSignal(2000, 50, 0);
all = [X_1 X_2];
sound(all, Fs);