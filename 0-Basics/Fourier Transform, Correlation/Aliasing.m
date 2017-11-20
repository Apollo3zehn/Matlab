clc
clear
close all

fs      = 100;
fa      = 1000;
Time    = 0 : 1/fa : 1;

AH1 = subplot(3, 1, 1);
AH2 = subplot(3, 1, 2);
AH3 = subplot(3, 1, 3);

[b, a] = butter(6, (fs/2)/(fa/2), 'z');

for Frequency = 1 : 1 : 150
    
    cla(AH1)
    cla(AH2)
    cla(AH3)

    hold(AH1, 'on')
    Data = sin(2*pi * Frequency * Time);
    plot(AH1, Time, Data)    
    ShortData = Data(1 : fa/fs : end);
    ShortTime = Time(1 : fa/fs : end);
    plot(AH1, ShortTime, ShortData, '.k')
    hold(AH1, 'off')
    
    hold(AH2, 'on')
    Length = length(ShortData);
    FftData = abs(fft(ShortData)) / Length;
    plot(AH2, linspace(1, fs, Length), FftData)
    plot(AH2, [fs/2; fs/2], [0; 1], 'r')
    text(10, 0.8, sprintf('f_s = %d Hz        f = %3d Hz', fs, Frequency), 'Parent', AH2)
    title(AH2, 'unfiltered data')
    ylim(AH2, [0 1])
    xlim(AH2, [0 fs])
    hold(AH2, 'on')
    
    hold(AH3, 'on')
    Length = length(ShortData);
    Data = filter(b, a, Data);
    ShortData = Data(1 : fa/fs : end);
    FftData = abs(fft(ShortData)) / Length;
    plot(AH3, linspace(1, fs, Length), FftData)
    plot(AH3, [fs/2; fs/2], [0; 1], 'r')
    title(AH3, 'low pass filtered data (6th order, f_c = 50 Hz)')
    ylim(AH3, [0 1])
    xlim(AH3, [0 fs])
    hold(AH3, 'on')
        
    pause(0.1)
    
end
