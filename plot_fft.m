%t_stop = 1;
%Fs = 40000;
%t = 0:1/Fs:t_stop;
%X = cos(2*pi*1000*t) + 2*cos(2*pi*2000*t);

function [w, M] = plot_fft(X, Fs)
Y = fft(X);
len_t = max(size(X));
Y_n = 2*abs(Y)/len_t;
len_t_2 = round(ceil(len_t)/2);
Y_n = Y_n(1:len_t_2);
w = linspace(0, Fs/2, len_t_2); 
figure();
plot(w, Y_n);
