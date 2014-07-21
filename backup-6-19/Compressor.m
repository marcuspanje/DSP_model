%simulation of a compressor

%input_start = initial input dB
%input_end  = ending output dB
%thresh1 = threshold point 1 in dB
%thresh2 = threshold point 2 in dB
%ratio1 = ratio between thresh1 and thresh2
%ratio2 = ratio betweeen thresh2 and end
function Y = Compressor(t1, t2, r1, r2);

input_start = -90;
input_end = 6;
output_start0 = -113;
thresh1 = -t1;
thresh2 = -t2;
ratio1 = r1;
ratio2 = r2;

%X = input, Y = output
X = input_start:0.5:input_end;
Y = zeros(1, numel(X));

%Region 0 is a flat line, so obtain first value of X, and offset. 
X0 = X(X <=thresh1);
sz0 = numel(X0);
for i = 1:sz0
    Y(i) = output_start0;
end

%For region 1 and 2,  ratio1 and ratio2 are the inverse of the gradient
%of line continuing from previous region
X1 = X(X <= thresh2);
output_start1 = Y(sz0);%start output from last value of prev region
sz1 = numel(X1);
for i = sz0:sz1
    Y(i) = (X(i) - thresh1)/ratio1 + output_start1;
end

X2 = X(X > thresh2);
sz2 = numel(X2);
output_start2 = Y(sz1);

for i = sz1:sz1+sz2
    Y(i) = (X(i) - thresh2)/ratio2 + output_start2;
end

plot(X, Y);    

