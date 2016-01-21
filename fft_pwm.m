%generate signal
Fsig = 1000;
Fs = 500000;
tstop_s = 1;
t = 0:1/Fs:tstop_s;
len = max(size(t));
signal_len = len;
base_signal = 1.5*cos(2*pi*Fsig*t);
figure();

%pulse width modulation
Fswth = 40000;
t_off = 0;
swth = 2.5*sawtooth(2*pi*Fswth*t) + 2.5;

%pwm(input, sawtooth, high, Vdc, fout, Fs, max_dutycycle)
%Vdc is offset voltage added on to input
Vdc = 2.5;
Xpwm = pwm(base_signal, swth, 5.0, Vdc, Fswth, Fs, 0.99);

XF = abs(fft(Xpwm))/len;
len_2 = round(ceil(len)/2);
XF = XF(1:len_2);
w = linspace(0, Fs/2, len_2);

figure();
plot(t, base_signal + Vdc, t, Xpwm, t, swth);
title('PWM_f = 40kHz, signal_f = 1kHz');
xlabel('t');
ylabel('signals');

figure();
plot(w, XF);
xlabel('Frequency', 'Fontsize', 20);
ylabel('Magnitude', 'Fontsize', 20);
