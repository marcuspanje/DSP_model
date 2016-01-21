%top level control for signal processing simulation

%input signal
[X, Fs] = audioread('sound_files/PedWarning.wav');
n = max(size(X));
Fs = 44100;
endtime = (n-1)/Fs;
t = 0:1/Fs:endtime;
%X = X(1:n, 1);

%function to generate signal
%f = frequency, A = max ampl, phi = phase in radians
makeSignal = @(f, A, phi) A*sin(2*pi*f*t + phi);
%X = makeSignal(1000, 0.1, 0);

%function for linear gain
LinGain = @(X, gain) X*gain;


Xgain1 = LinGain(X, 2);

%function for bandpass filtering
%BPassFilter(X, N, F3dB1, F3dB2, Fs)
%X = input signal, N = order, Fs = sampling freq
F3dB1 = 200;
F3dB2 = 7000;
Xfilter = BPassFilter(Xgain1, 2, F3dB1, F3dB2, Fs);

Xgain2 = LinGain(X, 1.8);


%compressor curve points:
px = [-90 -82.35 -75.29 -30.36 6];
py = [-113 -113 -99.84 -7.36 -4.44];
px_knee = [-40 -35 -30 -25 -20 -15 -10];
py_knee = [-28 -20 -13 -10 -9 -8 -7];

%function for audio compression. 
%Compressor(X, px, py, softKnee, px_knee,py_knee)
%px, py = pts along compression curve
%pxy_knee = graduated pts along threshold pt for soft knee
%Xcompress = Compressor(Xgain2, px, py, 1, px_knee, py_knee);

Fc = 500000;
tfine = 0:1/Fc:endtime;
Xfine = interp1(t, Xgain2, tfine,'spline');
%X0 = zeros(1,length(tfine));

%pulse width modulation
%fit_sawtooth(t, t_offset, frequency, lower_bound, upper_bound)
%generates sawtooth wave with given parameters
Fswth = 40000;
t_off = 0;
fit_sawtooth = @(t, t_off, f, lb, ub) sawtooth(2*pi*f*(t-t_off))*(ub+lb)/2 + (ub+lb)/2;
swth = fit_sawtooth(tfine, t_off, Fswth, 0, 5.5);


%pwm(input, sawtooth, high, Vdc, fout, Fs, max_dutycycle)
%Vdc is offset voltage added on to input
Vdc = 2.5;
Xpwm = pwm(Xfine, swth, 4.73, Vdc, Fswth, Fc, 0.8);

plot(tfine, swth, tfine, Xpwm, t, X + Vdc);
xlabel('Time/s', 'fontsize', 15);
ylabel('Voltage/V', 'fontsize', 15);
title('PWM', 'fontsize', 15);
set(gca, 'fontsize', 15);

%analyze pwm
n = floor(endtime*Fswth-1);
[dc, startT, endLo, endT, T] = getTInfo_lo(n, tfine, Xpwm);

%get dc_data
%scale to get 1 period, and from 0 to 2400
dc_scaled = round(dc*2400);
n_dc_scaled = numel(dc_scaled);

figure;
plot(1:n_dc_scaled, dc_scaled);

%write points to file
file = fopen('PedDetectorData.txt', 'w');
fprintf(file, '%s', '{');
for i = 1:n_dc_scaled-1
    fprintf(file, '%d, ', dc_scaled(i));
    if mod(i, 10) == 0
        fprintf(file, '%s\n', '');
    end
end
fprintf(file, '%d}', dc_scaled(n_dc_scaled));
fclose(file);

