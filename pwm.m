%perform pulse width modulation
%X = input sig to be modulated
%swth = sawtooth wave to be used as comparator
%Vdc = offset V added on to input sig

function [Y] = pwm(X, swth, high, Vdc)
n = length(X);
Y = high*ones(n, 1);

for i=1:n;
    if (swth(i) < X(i)+Vdc)||(X(i) + Vdc < 0)
        Y(i) = 0;
    end
end
end
