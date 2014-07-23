%pulse width modulation duty cycle range: 0 - max_Dc %
%X = input sig to be modulated
%swth = sawtooth wave to be used as comparator
%Vdc = offset V added on to input sig
%t_offset is time, f is freq of pulse wave,
%Fs is samplin frequency
%dead time control (DTC) prevents output from being constantly 
%by setting a maximum duty cycle
 
function [Y] = pwm(X, swth, high, Vdc, t, t_off, f, Fs)
n = length(X);
Y = zeros(n, 1);
max_Dc = 90; % maximum duty cycle for DTC - dead time control
max_high_t = max_Dc/(100*f);
max_high_i = max_high_t*Fs;
i_off = t_off * Fs;
i_period = Fs/f;
high_count = 0;
stay_low = 0; %switch to stay low till end of period

for i=1:n
    %get start of period to keep track of DTC
    if rem(i-1-i_off, i_period) == 0
        high_count = 0;
        stay_low = 0;
    end

    %condition for HI
    if (swth(i) > X(i)+Vdc) && (X(i) + Vdc >= 0)
        Y(i) = high;
        high_count = high_count + 1;
        
        %unless stopped by DTC: reached max duty cycle
        if high_count > max_high_i
            stay_low = 1;
            Y(i)=0;
            high_count = 0;
        end

        %stay low till end of period
        if stay_low == 1
            Y(i) = 0;
        end

    end
   
end
