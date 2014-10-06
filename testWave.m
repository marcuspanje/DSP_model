%top level control for signal processing simulation

%function to generate signal
%f = frequency, A = max ampl, phi = phase in degrees
[X, Fs] = audioread('siren.wav');
%T = 0.125 s %signal period
endtime = 3;
%Fs = 48000;
%Fs = round(1.07*realFs);
t = 0:1/Fs:endtime;
X = X(1:numel(t));
makeSignal = @(f, A, phi) A*sin(2*pi*f*t + degtorad(phi));
%X = makeSignal(1000, 1.5, 0);

%function for linear gain
LinGain = @(X, gain) X*gain;
X = LinGain(X, 4);

%Interpolate signal to increase sampling freq, for  u/s freq
Fs_fine = 300000;
tfine = 0:1/Fs_fine:endtime; 
Xfine = interp1(t, X, tfine, 'spline');  

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
n = 60000;
[dc, startT, endLo, endT, T] = getTInfo_lo(n, tfine, Xpwm);
plot(tfine, swth, tfine, Xpwm, t, X + Vdc);
xlabel('Time/s', 'fontsize', 15);
ylabel('Voltage/V', 'fontsize', 15);
title('PWM', 'fontsize', 15);
set(gca, 'fontsize', 15);

%scale to get 1 period, and from 0 to 400
startPeriod = 6500;
endPeriod = 11500;
dc_scaled = dc(startPeriod:endPeriod);
dc_scaled = round(dc_scaled*400);
n_dc_scaled = numel(dc_scaled);

figure;
plot(1:n_dc_scaled, dc_scaled);

%write points to file
file = fopen('dc_data', 'w');
fprintf(file, '%s', '{');
for i = 1:n_dc_scaled-1
    fprintf(file, '%d, ', dc_scaled(i));
    if mod(i, 10) == 0
        fprintf(file, '%s\n', '');
    end
end
fprintf(file, '%d}', dc_scaled(n_dc_scaled));
fclose(file);
