%perform pulse width modulation
%X = input sig to be modulated
%swth = sawtooth wave to be used as comparator
%Vdc = offset V added on to input sig

function [Y] = pwm(X, swth, high, Vdc, fsig, fswth)
n = length(X);
Y = high*ones(n, 1);

for i=1:n;
    t = (i-1)/fsig;
    i_swth = 1 + round(t*fswth);
        
    if swth(i_swth) < abs(X(i)+Vdc)
        Y(i) = 0;
    end
        
end
end
