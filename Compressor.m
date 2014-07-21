%simulate an audio compressor
%X = input signal, Y - output signal
%px0, py0 - row vector of x,y pts along compression curve
%softKnee - (1/0). If 1, then px_knee, py_knee are  
%more gradual points near threshold for smoother curve

function [Y, X_dB, Y_dB] = Compressor(X, px0, py0, softKnee, px_knee, py_knee) 

n = numel(X);
Vref = 2.5;
X_dB = zeros(n, 1);
Y = zeros(n, 1);
Y_dB = zeros(n, 1);

for i = 1:n
    if X(i) ~= 0
        X_dB(i) = 20*log10(abs(X(i))/Vref);
  %      fprintf('X(%d) = %f, X_dB(%d) = %f\n', i, X(i), i, X_dB(i));   
    end
end
px = px0;
py = py0;

if softKnee
%insert knee points right before last xy pt on curve
    np = numel(px0);
    px = [px0(1, 1:np-2) px_knee px0(np)];
    py = [py0(1, 1:np-2) py_knee py0(np)];
end

Y_dB = Compress_dB(X_dB, px, py);

for i = 1:n
    if X(i) == 0
        Y(i) = 0;
    elseif X(i) < 0
         Y(i) = -Vref*10^(Y_dB(i)/20);
    else 
         Y(i) = Vref*10^(Y_dB(i)/20);
    end
end

end

%perform compression in the dB domain
function Y_dB = Compress_dB(X_dB, px, py)
np = numel(px);
nx = numel(X_dB);
Y_dB = zeros(nx, 1);

%generate matrix of slopes based on points
slope = zeros(np-1, 1);
for i = 1:np-1
    slope(i) = (py(i+1)-py(i))/(px(i+1)-px(i));
end

%for each region, find yvalue based on xvalue and slope
%for that region: y = m(x-x0) + y0
for i = 1:nx
    %for points of X below px, make Y the first value
    if X_dB(i) <= px(1)
        Y_dB(i) = py(1);
    else
        for j = 1:np-1
            if X_dB(i) > px(j) && X_dB(i) <= px(j+1)
                Y_dB(i) = py(j) + slope(j)*(X_dB(i)-px(j));
            %if X_dB exceeds max value, set Y_dB to max value
            elseif (j == np-1) && (X_dB(i) > px(j+1))
                Y_dB(i) = py(np);
            end
        end
    end
end

end
