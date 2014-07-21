%plot a fft of a function, X is input signal
subplot(511);
plot(linspace(-Fs/2, Fs/2, length(X)), fftshift(abs(fft(X))));
%plot(t, X);
xlabel('f/Hz');
ylabel('Input signal');
a = axis;

subplot(512);
plot(linspace(-Fs/2, Fs/2, length(Xa)), fftshift(abs(fft(Xa))));
%plot(t, Xa);
xlabel('f/Hz');
ylabel('Gain=3');
%axis(a);

subplot(513);
plot(linspace(-Fs/2, Fs/2, length(Xb)), fftshift(abs(fft(Xb))));
%plot(t, Xb);
xlabel('f/Hz');
ylabel('Bandpass filter');
%axis(a);

subplot(514);
plot(linspace(-Fs/2, Fs/2, length(Xc)), fftshift(abs(fft(Xc))));
%plot(t, Xc);
xlabel('f/Hz');
ylabel('Gain=6');
%axis(a);

subplot(515);
plot(linspace(-Fs/2, Fs/2, length(Xd)), fftshift(abs(fft(Xd))));
%plot(t, Xd);
xlabel('f/Hz');
ylabel('Compressed');
%axis(a);
