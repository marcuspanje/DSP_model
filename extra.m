%code to plot spectrograph of filter/unfiltered in DSP.m

freqs = linspace(-Fs/2, Fs/2, n);
amplXg1 = fftshift(abs(fft(Xgain1))/n);
amplXfilter = fftshift(abs(fft(Xfilter))/n);

subplot(211);
plot(freqs, amplXg1)
legend('before filter');
xlabel('Frequency/Hz', 'fontsize', 13)
ylabel('Amplitude/V', 'fontsize', 13);
xlim([0 10000]);
ylim([0 0.05]);
title('Spectrograph of audio signal', 'fontsize', 15);

subplot(212)
plot(freqs, amplXfilter)
legend('after filter');
xlabel('Frequency/Hz', 'fontsize', 13)
ylabel('Amplitude/V', 'fontsize', 13);
%xlim([0 10000]);
%ylim([0 0.05]);
allaxes = findall(0, 'type', 'axes');
set(allaxes, 'fontsize', 10);
linkaxes(allaxes);
