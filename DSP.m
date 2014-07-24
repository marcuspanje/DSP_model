%top level control for signal processing simulation

%input signal
[X, Fs] = wavread('siren.wav');

t = 0:1/Fs:5;
X = X(1:length(t), 1);


%plot(t,X,'o',tfine,Xfine,'.');

%function for linear gain
LinGain = @(X, gain) X*gain;

lent = length(t);
%function to generate signal
%f = frequency, A = max ampl, phi = phase in degrees
makeSignal = @(f, A, phi) A*sin(2*pi*f*t + degtorad(phi));
X1 = makeSignal(80, 1, 90);
X2 = makeSignal(2500, 0.1, 0);
X3 = makeSignal(20000, 1, 0);

%X = X1 + X2 + X3;

Xa = LinGain(X, 3);

%function for bandpass filtering
%BPassFilter(X, N, F3dB1, F3dB2, Fs)
%X = input signal, N = order, Fs = sampling freq
F3dB1 = 800;
F3dB2 = 7200;
Xb = BPassFilter(Xa, 2, F3dB1, F3dB2, Fs);

Xc = LinGain(Xb, 3);

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


Fc = 500000;
tfine = 0:1/Fc:5;
Xfine = interp1(t,Xd,tfine,'spline');
X0 = zeros(1,length(tfine));
%plot(t, X);

%pulse width modulation
%fit_sawtooth(t, t_offset, frequency, lower_bound, upper_bound)
%generates sawtooth wave with given parameters
Fswth = 40000;
t_off = 0;
fit_sawtooth = @(t, t_off, f, lb, ub) sawtooth(2*pi*f*(t-t_off))*(ub+lb)/2 + (ub+lb)/2;
swth = fit_sawtooth(tfine, t_off, Fswth, 0, 3);

%pwm(input, sawtooth, max_amplidue, Vdc)
%Vdc is offset voltage added on to input
Xe = pwm(X0, swth, 4.73, 0, Fswth, Fc);
%Xf = pwm(X, swth, 4.73, 1);


%dc = 2*ones(lent, 1);
%cstpwm = pwm(dc, swth, 4.73, 0);
%l2 = (lent/2);
%subplot(311)
%plot(linspace(-Fs/2, Fs/2, length(Xf)), fftshift(abs(fft(Xf)))/l2)
%subplot(312)
%plot(linspace(-Fs/2, Fs/2, length(swth)), fftshift(abs(fft(cstpwm)))/l2)
%subplot(313)
%plot(linspace(-Fs/2, Fs/2, length(X)), fftshift(abs(fft(X)))/l2)

%figure;
%subplot(311)
%plot(tfine, Xfine);
%subplot(312)
%plot(t, Xc, t, Xd);
%subplot(313)
plot(tfine, swth, tfine, Xe, tfine, X0 + 0)


