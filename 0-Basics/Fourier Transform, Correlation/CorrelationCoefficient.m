function [] = CorrelationCoefficient()

    clear
    
    IsStatisticsToolboxAvailable    = license('test', 'Statistics_Toolbox');
    IsSignalToolboxAvailable        = license('test', 'Signal_Toolbox');

    clc

    x               = rand(100000, 1);
    y               = rand(100000, 1);
    PaddedLength  	= numel(x) + numel(y) - 1;
    
    %% Built in methods:
    
    % manual method, calculate the squared residuals
    tic
    Coefficients    = polyfit(x, y, 1);
    FittedCurve     = polyval(Coefficients, x);
    Residuals       = y - FittedCurve;
    SSresid         = sum(Residuals .^ 2);
    SStotal         = (length(y) - 1) * var(y);
    R2              = 1 - SSresid/SStotal;
    fprintf('1.  R² = %.15f - ', R2); toc; disp(' ')
    
    % convolution where lag is 0, y is conjugated, calculation in frequency domain, normalized
    tic
    R2 = fftshift(ifft(fft(x - mean(x), PaddedLength) .* conj(fft(y - mean(y), PaddedLength))) / (norm(x - mean(x)) * norm(y - mean(y)))) .^ 2;
    R2 = R2(round(end / 2), 1);
    fprintf('2.  R² = %.15f - ', R2); toc; disp(' ')
        
    % convolution where lag is 0, y is reversed, calculation in frequency domain, normalized
    tic
    R2 = (ifft(fft(x - mean(x), PaddedLength) .* fft(flipdim(y, 1) - mean(y), PaddedLength)) / (norm(x - mean(x)) * norm(y - mean(y)))) .^ 2;
    R2 = R2(round(end / 2), 1);
    fprintf('3.  R² = %.15f - ', R2); toc; disp(' ')
    
    % convolution where lag is 0, y is reversed, calculation in time domain (very slow), normalized
    tic
    R2 = (conv(x - mean(x), flipdim(y, 1) - mean(y)) / (norm(x - mean(x)) * norm(y - mean(y)))) .^ 2;
    R2 = R2(round(end / 2), 1);
    fprintf('4.  R² = %.15f - ', R2); toc; disp(' ')
    
    % corrcoef
    tic
    R2 = corrcoef(x, y)^2; 
    R2 = R2(1, 1) - 1;
    fprintf('5.  R² = %.15f - ', R2); toc; disp(' ')

    % covariance normalized by standard deviation
    tic
    R2 = (cov(x, y) / (std(x) * std(y))).^2 ;
    R2 = R2(2, 1);
    fprintf('6.  R² = %.15f - ', R2); toc; disp(' ')

    % covariance normalized by root of variance (for standard deviation and 
    % variance see http://en.wikipedia.org/wiki/Bessel's_correction)
    tic
    R2 = (cov(x, y) / sqrt(cov(x) * cov(y))).^2 ;
    R2 = R2(2, 1);
    fprintf('7.  R² = %.15f - ', R2); toc; disp(' ')

    %% Statistics toolbox:

    if IsStatisticsToolboxAvailable
    
        % corr
        tic
        R2 = corr(x, y) ^ 2;
        fprintf('8.  R² = %.15f - ', R2); toc; disp(' ')

        % convert covariance to correlation coefficient
        tic
        R2 = corrcov(cov(x, y)) .^ 2 ;
        R2 = R2(2, 1);  
        fprintf('9.  R² = %.15f - ', R2); toc; disp(' ')

    end
    
    %% Signal processing toolbox:

    if IsSignalToolboxAvailable
    
        % normalized cross covariance where the lag is 0
        tic
        R2 = xcov(x, y , 'coeff') .^ 2;
        R2 = R2(round(end / 2), 1);
        fprintf('10. R² = %.15f - ', R2); toc; disp(' ')

        % normalized cross correlation where lag is 0 and the mean is subtracted from each input
        tic
        R2 = xcorr(x - mean(x), y - mean(y), 'coeff') .^ 2;
        R2 = R2(round(end / 2), 1);
        fprintf('11. R² = %.15f - ', R2); toc; disp(' ')

        % cross correlation where lag is 0, the mean is subtracted from each input and the coefficients are normalized
        tic
        R2 = (xcorr(x - mean(x), y - mean(y)) / (norm(x - mean(x)) * norm(y - mean(y)))) .^ 2;
        R2 = R2(round(end / 2), 1);
        fprintf('12. R² = %.15f - ', R2); toc; disp(' ')

    end
        
end

