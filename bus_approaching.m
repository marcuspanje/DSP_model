%top level control for signal processing simulation

%function to generate signal
%f = frequency, A = max ampl, phi = phase in degrees
[X, Fs] = wavread('bus_approaching_short.wav');
%T = 0.125 s %signal period
endtime = (numel(X)-1)/Fs;
t = 0:1/Fs:endtime;

%function for linear gain
LinGain = @(X, gain) X*gain;
X = LinGain(X, 4);

%function for bandpass filtering
%BPassFilter(X, N, F3dB1, F3dB2, Fs)
%X = input signal, N = order, Fs = sampling freq
F3dB1 = 800;
F3dB2 = 10000;
Xfilter = BPassFilter(X, 2, F3dB1, F3dB2, Fs);

%Interpolate signal to increase sampling freq, for  u/s freq
Fs_fine = 300000;
tfine = 0:1/Fs_fine:endtime; 
Xfine = interp1(t, Xfilter, tfine, 'spline');  

%pulse width modulation
%fit_sawtooth(t, t_offset, frequency, lower_bound, upper_bound)
%generates sawtooth wave with given parameters

Fswth = 40000;
t_off = 0;
makeSawtooth = @(t, t_off, f, lb, ub) sawtooth(2*pi*f*(t-t_off))*(ub+lb)/2 + (ub+lb)/2;
swth = makeSawtooth(tfine, t_off, Fswth, 0, 5);

%pwm(input, sawtooth, high, Vdc, fpulse, Fs, max_dutycycle)
%Vdc is offset voltage added on to input
Vdc = 2.5;
Xpwm = pwm(Xfine, swth, 5.0, Vdc, Fswth, Fs_fine, 0.9);

%analyze pwm
n = endtime*Fswth-1;
[dc, startT, endLo, endT, T] = getTInfo_lo(n, tfine, Xpwm);
plot(tfine, swth, tfine, Xpwm, t, X + Vdc);
xlabel('Time/s', 'fontsize', 15);
ylabel('Voltage/V', 'fontsize', 15);
title('PWM', 'fontsize', 15);
set(gca, 'fontsize', 15);

%get dc_data
%scale to get 1 period, and from 0 to 400
dc_scaled = round(dc*400);
n_dc_scaled = numel(dc_scaled);

figure;
plot(1:n_dc_scaled, dc_scaled);

%write points to file
file = fopen('busapproachingshortdata.txt', 'w');
fprintf(file, '%s', '{');
for i = 1:n_dc_scaled-1
    fprintf(file, '%d, ', dc_scaled(i));
    if mod(i, 10) == 0
        fprintf(file, '%s\n', '');
    end
end
fprintf(file, '%d}', dc_scaled(n_dc_scaled));
fclose(file);



