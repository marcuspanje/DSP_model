%top level control for signal processing simulation

%input signal
Fs = 90000; %sampling frequency
t = 0:1/Fs:10;
%function for linear gain
LinGain = @(X, gain) X*gain;
lent = length(t);
%function to generate signal
%f = frequency, A = max ampl, phi = phase in degrees
makeSignal = @(f, A, phi) A*sin(2*pi*f*t + degtorad(phi));
X1 = makeSignal(80, 10, 90);
X2 = makeSignal(2500, 1, 0);
X3 = makeSignal(20000, 10, 0);

X = X2;

Xa = LinGain(X, 3);

%function for bandpass filtering
%BPassFilter(X, N, F3dB1, F3dB2, Fs)
%X = input signal, N = order, Fs = sampling freq
F3dB1 = 800;
F3dB2 = 7200;
Xb = BPassFilter(Xa, 2, F3dB1, F3dB2, Fs);

Xc = LinGain(Xb, 6);

%compressor curve points:
px = [-90 -82.35 -75.29 -30.36 6];
py = [-113 -113 -99.84 -7.36 -4.44];
px_knee = [-40 -35 -30 -25 -20 -15 -10];
py_knee = [-28 -20 -13 -10 -9 -8 -7];

%function for audio compression. 
%Compressor(X, px, py, softKnee, px_knee,py_knee)
%px, py = pts along compression curve
%pxy_knee = graduated pts along threshold pt for soft knee
Xd = Compressor(Xc, px, py, 1, px_knee, py_knee);

%pulse width modulation
f_c = 40000;
lb = 0;
ub = 3;
t_offset = 0;
Vdc = 1;
swth = fit_sawtooth(t, t_offset, f_c, lb, ub);
Xe = pwm(Xd, swth, 4.73, Vdc);
Xf = pwm(X, swth, 4.73, Vdc);
dc = 2*ones(length(t), 1);
cstpwm = pwm(dc, swth, 4.73, 0);
l2 = (lent/2);
subplot(311)
plot(linspace(-Fs/2, Fs/2, length(Xf)), fftshift(abs(fft(Xf)))/l2)
subplot(312)
plot(linspace(-Fs/2, Fs/2, length(swth)), fftshift(abs(fft(cstpwm)))/l2)
subplot(313)
plot(linspace(-Fs/2, Fs/2, length(X)), fftshift(abs(fft(X)))/l2)

figure;
plot(t, swth)
