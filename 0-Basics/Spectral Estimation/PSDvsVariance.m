clc
clear

Fs  = 10000;   
t   = 0 : 1/Fs : 10;  
t   = t(1 : 2^nextpow2(numel(t)) / 2);
N   = numel(t);
df  = Fs / N;

x = zeros(1, numel(Fs));
for i = 1 : 20
    f       = round(rand(1)*Fs/2); 
    phi     = rand(1)*pi; 
    random  = 30*rand(size(t));
    x = x + rand(1)*10 * (cos(2*pi*f*t) + sin(2*pi*f*t + phi)) + random - mean(random);
end

x = x - mean(x);

[Power, Frequency, ~] = SpectralAnalysis.WelchPowerSpectralDensity(x, [], ones(N, 1), 0, Fs, []);

PSDSum = sum(Power) * df;

fprintf('PSD sum: %.2f\nVariance: %.2f\nDifference: %.2f%%\n', PSDSum, var(x), (PSDSum - var(x))/var(x) * 100)