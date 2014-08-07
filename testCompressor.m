%compressor curve points:
px = [-90 -82.35 -75.29 -30.36 6];
py = [-113 -113 -99.84 -7.36 -4.44];
px_knee = [-40 -35 -30 -25 -20 -15 -10];
py_knee = [-28 -20 -13 -10 -9 -8 -7];

fname = 'testCompressor2.xlsx';
arr = xlsread(fname);
Vin = arr(:, 1);
Vout_exp = arr(:, 2);
[Vout_theory, X_dB, Y_dB] = Compressor(Vin, px, py, 1, px_knee, py_knee);

figure
plot(Vin, Vout_exp, 'b', Vin, Vout_theory, 'r');
leg = legend('ADAU 1701', 'MATLAB model');
set(leg, 'fontsize', 15);
set(gca, 'fontsize', 15);
xlabel('Vin/V', 'fontsize', 15);
ylabel('Vout/V', 'fontsize', 15);

figure
plot(X_dB, Y_dB);
