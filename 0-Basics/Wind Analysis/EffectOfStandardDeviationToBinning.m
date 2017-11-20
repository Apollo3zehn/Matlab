clc
clear 
close all

k               = 2;
A               = 6;

MinValueCount   = 100;
Bins            = 0 : 0.5 : 25;

HighStd      	= [];

for WindSpeed = Bins
    
    HighStd = [HighStd; WindSpeed + 1 * randn(floor(100000 * Distribution.WeibullPdf(WindSpeed, k, 1/A)), 1)];
    
end

LowStd  = SignalProcessing.MovingAverage(HighStd, 5);

%%
FH  = Figure.CreateDinA4OptimizedFigure;
AH1 = subplot(3, 1, 1);
AH2 = subplot(3, 1, 2);
AH3 = subplot(3, 1, 3);
%%

%% V1
[BinIndices, NumberOfValues_1]  = Statistics.SortDataIntoBins(HighStd, Bins, false, false);
BinnedLowStd                    = Statistics.ProcessBinSortedData(LowStd, BinIndices, numel(Bins), @(x) mean(x));
BinnedHighStd                   = Statistics.ProcessBinSortedData(HighStd, BinIndices, numel(Bins), @(x) mean(x));

Indices_1                       = NumberOfValues_1 >= MinValueCount;
Difference_1                    = BinnedLowStd - BinnedHighStd;
Difference_1                    = Difference_1(Indices_1);
Bins_1                          = Bins(Indices_1);

%% V2
[BinIndices, NumberOfValues_2]  = Statistics.SortDataIntoBins(LowStd, Bins, false, false);
BinnedLowStd                    = Statistics.ProcessBinSortedData(LowStd, BinIndices, numel(Bins), @(x) mean(x));
BinnedHighStd                   = Statistics.ProcessBinSortedData(HighStd, BinIndices, numel(Bins), @(x) mean(x));

Indices_2                       = NumberOfValues_2 >= MinValueCount;
Difference_2                    = BinnedHighStd - BinnedLowStd;
Difference_2                    = Difference_2(Indices_2);
Bins_2                          = Bins(Indices_2);

%% Plot

hold(AH1, 'on')
hold(AH2, 'on')
hold(AH3, 'on')

% Plot 1
plot(AH1, HighStd, 'b')
plot(AH1, LowStd, 'k')
title(AH1, '{\bf LowStd} and {\color{blue}HighStd}');
ylim(AH1, [0 25]);
xlabel(AH1, 'Time (-)');
ylabel(AH1, 'Wind speed (m/s)');

% Plot 2
plot(AH2, Bins_1, Difference_1, 'k', 'LineWidth', 2)
plot(AH2, Bins_2, Difference_2, 'b', 'LineWidth', 2)
title(AH2, '{\bf BinnedLowStd - BinnedHighStd} and {\color{blue}BinnedHighStd - BinnedLowStd}');
xlim(AH2, [0 25]);
ylim(AH2, [-2 2]);
xlabel(AH2, 'Wind speed (m/s)')
ylabel(AH2, 'Wind speed (m/s)');

% Plot 3
SH = bar(AH3, Bins', [NumberOfValues_1 NumberOfValues_2], 'grouped', 'b');
set(SH(1),'FaceColor','k'); 
set(SH(2),'FaceColor','b');
NumberOfValues_1(Indices_1) = NaN;
NumberOfValues_2(Indices_2) = NaN;
bar(AH3, Bins', [NumberOfValues_1 NumberOfValues_2], 'grouped', 'r');
title(AH3, 'Number of values of {\bf BinnedLowStd - BinnedHighStd} and {\color{blue}BinnedHighStd - BinnedLowStd}');
xlim(AH3, [0 25]);
xlabel(AH3, 'Wind speed (m/s)')
ylabel(AH3, 'Number of values (-)')

hold(AH1, 'off')
hold(AH2, 'off')
hold(AH3, 'off')

Figure.SaveAsFig(FH, 'C:\Users\vwilms\Desktop\Test')
Figure.SaveAsPng(FH, 'C:\Users\vwilms\Desktop\Test')
