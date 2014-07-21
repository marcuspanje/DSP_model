
Fs = 44000;
t = 0:1/Fs:2;
makeSound = @(A, f) A*sin(2*pi*f*t);
f1 = 10;
f2 = 100;
X1 = makeSound(1, f1);
X2 = makeSound(10, f2);
X = zeros(1, numel(X1));
for i = 1:numel(X)
    X(i) = X1(i)*X2(i);
end

Z = Y(1, 1:Fs/f1);
plot(t, X);

%reduce the matrix to get the max level

%sound([X Y], Fs);
%Compressor();
