%pulse width modulation with duty cycle range: 0 - max_Dc %
%X = input sig to be modulated
%swth = sawtooth wave to be used as comparator
%Vdc = offset V added on to input sig
%f=freq of pulse wave, Fs=samplin freq, max_dc=max duty cycle [0, 1]
%max_dc provides dead time control (DTC) by preventing 100% duty cycle. 
 
function [Y] = pwm(X, swth, high, Vdc, f, Fs, max_dc)
n = length(X);
Y = zeros(n, 1);
max_high_t = max_dc/f;
max_high_i = round(max_high_t*Fs);
high_count = 0;
stay_low = 0; %switch to stay low till end of period

for i=1:n
    %get start of period and reset switches for DTC
    if (i > 1) && (swth(i) < swth(i-1)) 
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
