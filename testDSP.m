%input signal
%Fs = 48000; %sampling frequency
%t = 0:1/Fs:3;
%function for linear gain
LinGain = @(X, gain) X*gain;

fname = 'evalBoardTest.xlsx';
arr = xlsread(fname);
X = arr(:, 1);
Xc_exp = arr(:, 2);
%function to generate signal
%f = frequency, A = max ampl, phi = phase in degrees
makeSignal = @(f, A, phi) A*sin(2*pi*f*t + degtorad(phi));
%X1 = makeSignal(80, 0.2, 0);
%X2 = makeSignal(2500, 0.1, 0);
%X3 = makeSignal(10000, 0.2, 0);
%X = X1 + X2 + X3;
%X = X1 + X3;

Xa = LinGain(X, 3);

%function for bandpass filtering
%BPassFilter(X, N, F3dB1, F3dB2, Fs)
%X = input signal, N = order, Fs = sampling freq
F3dB1 = 800;
F3dB2 = 7200;
%Xb = BPassFilter(Xa, 2, F3dB1, F3dB2, Fs);

Xb = LinGain(Xa, 6);

%compressor curve points:
px = [-90 -82.35 -75.29 -30.36 6];
py = [-113 -113 -99.84 -7.36 -4.44];
px_knee = [-40 -35 -30 -25 -20 -15 -10];
py_knee = [-28 -20 -13 -10 -9 -8 -7];

%function for audio compression. 
%Compressor(X, px, py, softKnee, px_knee,py_knee)
%px, py = pts along compression curve
%pxy_knee = graduated pts along threshold pt for soft knee
[Xc, X_dB, Y_dB]  = Compressor(Xb, px, py, 1, px_knee, py_knee);
figure;
plot(X_dB, Y_dB, '.')
figure;
plot(X, Xc_exp, 'r', X, Xc, 'b');
legend('exp', 'theory');
xlabel('Vin / V');
ylabel('Vout / V');
