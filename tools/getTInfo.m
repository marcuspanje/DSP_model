function [duty_cycles, start_T, end_high, end_T, T] = getTInfo(n_periods, t, Vo)
j = 1;

duty_cycles = zeros(n_periods, 1);
start_T = zeros(n_periods, 1);
end_high = zeros(n_periods, 1);
end_T = zeros(n_periods, 1);
T = zeros(n_periods, 1);

if Vo(j, 1) < 2.3
%move index to start of next  high
    while Vo(j, 1) < 2.3
        j=j+1;
    end
else 
    while Vo(j, 1) > 2.3
        j = j+1;
    end
    while Vo(j, 1) < 2.3
        j = j+1;
    end
end
    
    

%get duty cycle for each period
%a period is the distance in indices between a point and its 
%next period point, not (one before) the next period point. 
%in cts time, they are the same, but not in discrete.
for i = 1:n_periods
%advance j till end of high
    start_T(i) = j;
    while Vo(j, 1) > 2.3
        j=j+1;
    end

    end_high(i) = j;

%advance j till end of period
    while Vo(j, 1) < 2.3
        j=j+1;
    end
    end_T(i) = j; 
    T(i) = end_T(i)+ - start_T(i);
    duty_cycles(i) = (end_high(i)-start_T(i))/T(i);
end

