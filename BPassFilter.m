function Y = BPassFilter(X, N, F3dB1, F3dB2, Fs)
%X is input signal
d = fdesign.bandpass('N,F3dB1,F3dB2', N, F3dB1, F3dB2, Fs);
Hd = design(d);
%fvtool(Hd);

Y = filter(Hd, X);
end
