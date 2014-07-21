%perform pulse width modulation
%X = input sig to be modulated
%swth = sawtooth wave to be used as comparator
%Vdc = offset V added on to input sig

function [Y] = pwm(X, swth, high, Vdc)
n = length(swth);
Y = high*ones(n, 1);

for i=1:n;
    if swth(i) < abs(X(i)+Vdc)
        Y(i) = 0;
    end
end
