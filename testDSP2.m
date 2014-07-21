%input signal
Fs = 48000; %sampling frequency
t = 0:1/Fs:1;

%function for linear gain
LinGain = @(X, gain) X*gain;

%function to generate signal
%f = frequency, A = max ampl, phi = phase in degrees
makeSignal = @(f, A, phi) A*sin(2*pi*f*t + degtorad(phi));
X1 = makeSignal(10, 2, 0);
X2 = makeSignal(1000, 2 , 0);
X3 = makeSignal(20000, 2, 0);
scale = 23985;
X = X1 + X2;
%X = X3 + X1;

Xa = LinGain(X, 3);

%function for bandpass filtering
%BPassFilter(X, N, F3dB1, F3dB2, Fs)
%X = input signal, N = order, Fs = sampling freq
F3dB1 = 800;
F3dB2 = 7200;
Xb = BPassFilter(Xa, 2, F3dB1, F3dB2, Fs);

Xc = LinGain(Xa, 6);

%compressor curve points:
%px = [-90 -82.35 -75.29 -30.36 6];
%py = [-113 -113 -99.84 -7.36 -4.44];
px_knee = [-40 -35 -30 -25 -20 -15 -10];
py_knee = [-28 -20 -13 -10 -9 -8 -7];
px = [-90 -5 6];
py = [-90 -5 -5];

%function for audio compression. 
%Compressor(X, px, py, softKnee, px_knee,py_knee)
%px, py = pts along compression curve
%pxy_knee = graduated pts along threshold pt for soft knee
[Xd, Xd_dB, Yd_dB] = Compressor(X, px, py, 0, px_knee, py_knee);

figure;
plot(Xd_dB, Yd_dB, '.')

figure;
%plot a fft of a function, X is input signal
subplot(411);
plot(linspace(-Fs/2, Fs/2, length(X)), fftshift(abs(fft(X)))/scale);
xlabel('f/Hz');
ylabel('Input signal');
a = axis;

subplot(412);
plot(t, X, 'b', t, Xd, 'r');
xlabel('t/s');
ylabel('X');

subplot(413);
plot(linspace(-Fs/2, Fs/2, length(Xd)), fftshift(abs(fft(Xd)))/scale);
xlabel('f/Hz');
ylabel('Compressed');

subplot(414);
plot(t, Xd, '.');
xlabel('t/s');
ylabel('Xd-Compressed');

