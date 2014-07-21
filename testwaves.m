Fs = 48000;
t = 0:1/Fs:1;
F_swth = 500000;
t_swth = 0:1/F_swth:1;

X = 1*sin(2*pi*1000*t);
%fit_sawtooth(t, t_offset, frequency, lower_bound, upper_bound)
%generates sawtooth wave with given parameters
fit_sawtooth = @(t, t_off, f, lb, ub) sawtooth(2*pi*f*(t-t_off))*(ub+lb)/2 + (ub+lb)/2;
swth = fit_sawtooth(t, 0, 40000, 0, 3);



plot(t, swth)
