%perform pulse width modulation
%X = input sig to be modulated
%swth = sawtooth wave to be used as comparator
%Vdc = offset V added on to input sig

%function [Y] = pwm(X, swth, high, Vdc, t, t_off, f, Fs)
Fc = 500000;
tfine = 0:1/Fc:1;
n = length(tfine);
X = zeros(n, 1);
f = 48000;
t_off = 0;
fit_sawtooth = @(t, t_off, f, lb, ub) sawtooth(2*pi*f*(t-t_off))*(ub+lb)/2 + (ub+lb)/2;
swth = fit_sawtooth(tfine, t_off, f, 0, 3);
Vdc = 0;
high = 5;

Y = zeros(n, 1);
max_Dc = 70; % maximum duty cycle for dead time control
max_high_t = max_Dc/(100*f);
max_high_i = max_high_t*Fc;
i_off = t_off * Fc;
i_period = Fc/f;
high_count = 0;
stay_low = 0;
i_start_period = 0;
for i=1:n;
   %get start of a period
    if rem(i-1-i_off, i_period) == 0
        high_count = 0;
        stay_low = 0;
        i_start_period = i;
    end
    %condition for high
    if (swth(i) > X(i)+Vdc) && (X(i) + Vdc >= 0)
        Y(i) = high;
        high_count = high_count + 1;
            
        if high_count > max_high_i
            stay_low = 1;
            Y(i) = 0;
            high_count = 0;
           
         end

        if stay_low == 1
            Y(i)=0;
        end
   
    end
        
        
end
index = 1:n;
plot(index, swth, index, Y, index, X)

