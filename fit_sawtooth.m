%input: t = time, t_offset = offset starting time for
%swth wave, f = freq of swth wave, lb, ub = lower and 
%swth wave
%output: swth wave eqn
function swth = fit_sawtooth(t,t_offset, f, lb, ub)

%start sawtooth wave at the end of the first high
scale = (ub+lb)/2;
swth = sawtooth(2*pi*f*(t-t_offset))*scale + scale;
