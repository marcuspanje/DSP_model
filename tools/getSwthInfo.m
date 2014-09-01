%analyze a pulse wave and get info on the swth wave used
%for comparison. 
%input: pulse_wave, no of periods to evaluate
%output: f = frequency, t_offset = time offset, meanT = 
%mean of the periods of the pulse(not usually needed)
function [f, t_offset, Vdc_i] = getSwthInfo(t, pulse, n_periods)
[dc, start_T, end_high, end_T, T] = getTInfo(n_periods, t, pulse);
steptime = t(2)-t(1);
meanT = mean(T);
f = 1/(steptime*meanT);
t_offset = t(end_high(1));
Vdc_i = start_T(1);

