%perform reverse compression
Vref = 2.5;
fname = 'evalBoardTest.xlsx';
arr = xlsread(fname);
Vin = arr(:, 1);
Vout = arr(:, 2);
Vin_gained = Vin*18;
n = numel(Vin);
Vin_dB = zeros(n, 1);
Vout_dB = zeros(n, 1);
for i = 1:n
    Vin_dB(i) = 20*log10(Vin_gained(i)/Vref);
    Vout_dB(i) = 20*log10(Vout(i)/Vref);
end

plot(Vin_dB, Vout_dB);
