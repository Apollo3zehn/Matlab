%% Settings

clc
clear
format bank

N = 3
X = round(100 * rand(N, 1))
Y = round(100 * rand(N, 1))

%% Mean (Population)
% $$E\left(X\right)$$

%% Mean (Sample)
% $$\overline{X} = \frac{1}{N}\sum_{i=1}^N X_i$$

%% Covariance (Population)
% $$\sigma\left(X,Y\right) = E\left(\left(X-E\left(X\right)\right) \cdot \left(Y-E\left(Y\right)\right)\right) = E\left(X\cdot Y\right) - E\left(X\right)\cdot E\left(Y\right)$$

%% Covariance (Sample)
% $$s^2\left(X, Y\right) = \frac{1}{N-1} \sum_{i=1}^N\left(X_i-\overline{X}_j\right)\left(Y_i-\overline{Y}_k\right)$$

Z       = cov(X, Y)

Z(1, 1) = sum(((X - mean(X)) .* (X - mean(X)))) / (N-1);
Z(1, 2) = sum(((X - mean(X)) .* (Y - mean(Y)))) / (N-1);
Z(2, 1) = sum(((Y - mean(Y)) .* (X - mean(X)))) / (N-1);
Z(2, 2) = sum(((Y - mean(Y)) .* (Y - mean(Y)))) / (N-1)

%% Variance (Population)
% $$\sigma\left(X,X\right) = E\left(\left(X-E\left(X\right)\right) \cdot \left(X-E\left(X\right)\right)\right) = E\left(\left(X-E\left(X\right)\right)^2\right) = \sigma(X)^2$$

%% Variance (Sample)
% $$s^2\left(X\right) = \frac{1}{N-1} \sum_{i=1}^N\left(X_i-\overline{X}\right)^2$$

Z = cov(X, X)
Z = var(X)
Z = std(X).^2

Z = sum(((X - mean(X)).*2)) / (N-1);

%% Correlation Coefficient (Population)
% $$\rho_{X,Y} = \frac{\sigma\left(X,Y\right)}{\sigma\left(X\right) \cdot \sigma\left(Y\right)}$$

%% Correlation Coefficient (Sample)
% $$r_{X,Y} = \frac{s^2\left(X,Y\right)}{s\left(X\right)\cdot s\left(Y\right)}$$

Z = corrcoef(X, Y)

Z = cov(X, Y) ./ [std(X) * std(X), std(X) * std(Y);
                  std(Y) * std(X), std(Y) * std(Y)]

%% Cross-Covariance (Population)
% $$\gamma_{X,Y}\left(t,\tau\right) = E\left(\left(X\left(t\right)-E\left(X\right)\right) \cdot \left(Y\left(t+\tau\right)-E\left(Y\right)\right)\right)$$

%% Cross-Covariance (Sample, deterministic)
% $$ C_{XY}\left(t\right) = \sum_{\tau = 0}^{t-1}\left(X(\tau)-\overline{X}\right) \cdot \left(Y^\ast\left( t-\tau\right)-\overline{Y}\right)$$
% 
% $$ C_{XY} = \left(X-\overline{X}\right) \star \left(Y-\overline{Y}\right) = \mathcal{F}^{-1}\left\{\mathcal{F}\left\{X-\overline{X}\right\} \cdot \mathcal{F}\left\{Y^\ast-\overline{Y}\right\}\right\}$$

PaddedLength                    = numel(X) + numel(Y) - 1;

Z                               = zeros(1, PaddedLength);
X_Conv                          = X;
X_Conv(N + 1 : PaddedLength)	= mean(X);
Y_Conv                          = flipdim(Y, 1);
Y_Conv(N + 1 : PaddedLength)    = mean(Y);
for t = 1 : PaddedLength
    for tau = 1 : t    
        Covariance  = (X_Conv(tau) - mean(X)) * (Y_Conv(t - tau + 1) - mean(Y));
        Z(t)        = Z(t) + Covariance;
    end    
end

Z

Z               = conv(X - mean(X), flipdim(Y - mean(Y), 1)).'

Z               = xcov(X, Y).'

Z               = xcorr(X - mean(X), Y - mean(Y)).'

Z               = fftshift(ifft(fft(X - mean(X), PaddedLength) .* conj(fft(Y - mean(Y), PaddedLength)))).'

%% Cross-Correlation (Population)
% $$\rho_{X,Y}\left(t,\tau\right) = \frac{\gamma_{X,Y}\left(t,\tau\right)}{\sigma(X) \cdot \sigma(Y)}$$

%% Cross-Correlation (Sample, deterministic)
% $$ R_{XY}\left(t\right) = \sum_{\tau = 0}^{t-1}X(\tau) \cdot Y^\ast\left( t-\tau\right))$$
% 
% $$ R_{XY} = X \star Y = \mathcal{F}^{-1}\left\{\mathcal{F}\left\{X\right\} \cdot \mathcal{F}\left\{Y^\ast\right\}\right\}$$

Z = xcorr(X, Y)

%% Cross-Correlation (Sample, deterministic, normalized)
% $$R_{XY} = \frac{1}{N-1}\frac{C_{XY}}{\sqrt{s^2\left(X\right)} \cdot \sqrt{s^2\left(Y\right)}} = \frac{C_{XY}}{\left|\left|X\right|\right| \cdot \left|\left|Y\right|\right|}$$

PaddedLength    = numel(X) + numel(Y) - 1;

Z             	= xcov(X, Y, 'coeff').'

Z               = fftshift(ifft(fft(X - mean(X), PaddedLength) .* conj(fft(Y - mean(Y), PaddedLength))) / (std(X) * std(Y)) / (N-1)).'

Z               = fftshift(ifft(fft(X - mean(X), PaddedLength) .* conj(fft(Y - mean(Y), PaddedLength))) / (norm(X - mean(X)) * norm(Y - mean(Y)))).'

Z               = corrcoef(X, Y).'

%% Cross Power Spectral Density
% $$S_{XY} = \mathcal{F}\left\{R_{XY}\right\}$$
%
% $$G_{XY} = \left\{\begin{array}{cc} \hphantom{1}\,S_{XY} & \textrm{if }f=0 \\ 2\,S_{XY} & \textrm{if }f>0 \end{array}\right.\;\;\;\;\;\;\;\textrm{for }0\leq f\leq \frac{f_s}{2}$$

%% Coherence
% $$C_{XY}\left(f\right) = \frac{\left|G_{X,Y}\left(f\right)\right|^2}{G_{X,X}\left(f\right) \cdot G_{Y,Y}\left(f\right)}$$
