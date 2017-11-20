close all
clear
clc

% Einstellungen

Endzeit             = datenum(0, 0, 0, 0, 15, 0); % wird später als Plotgrenze X-Achse genommen. JAhr, Monat, Tag, Stunde, Min, Sek
OutputFileName      = [pwd '\' datestr(now, 'yyyy-mm-dd hh-MM-ss') '.png'];

FigureHandle        = figure ('name', '', ...
                            'PaperPositionMode', 'manual', ...
                            'PaperUnits', 'points', ... 
                            'PaperSize', [800 600], ...        %hier die Auflösung definieren
                            'PaperPosition', [0 0 800 600], ...
                            ...
                            'Units', 'Points', ...
                            'Position',[0 0 800 600]);

figure(FigureHandle);
                        
% DaqPro

%FH = fopen('C:\Users\TH\Documents\UFO\Lasertests\DPSS 532\gut-Freitag Diode.csv');

%DaqPro              = textscan(FH, '%s %f:%f:%f %f %f %f', 'delimiter', ';', 'headerLines', 1, 'MultipleDelimsAsOne', true);

%ZeitDaqPro          = datenum(0, 0, 0, DaqPro{2}, DaqPro{3}, DaqPro{4});
%Temperatur1         = DaqPro{:, 5}; % :=alle Werte der 5. Row
%Temperatur2         = DaqPro{:, 6}; % :=alle Werte der 6. Row
%Fotodiode           = DaqPro{:, 7}; % :=alle Werte der 7. Row

% Korrelation
Korrelation1         = dlmread('2014-06-05 11-15-12 1min vernebler gut.csv', ',');   % hier Ausgangsdatei einlesen
ZeitKorr1            = Korrelation1(:, 1);   % Zeit der Korrelationsdatei alle WErte der 1. Row 
KorrKoeffizienten1   = Korrelation1(:, 2);   % Y-Werte der Korrelationsdatei, alle Werte der 2. Row

Korrelation2         = dlmread('2014-06-05 11-57-06 konstant nach 1min vernebler super.csv', ',');   % hier Ausgangsdatei einlesen
ZeitKorr2            = Korrelation2(:, 1);   % Zeit der Korrelationsdatei alle WErte der 1. Row 
KorrKoeffizienten2   = Korrelation2(:, 2);   % Y-Werte der Korrelationsdatei, alle Werte der 2. Row

% Korrektur
ZeitKorr1            = x2mdate(ZeitKorr1, 0); % x2m rechnet Zeitformat um

ZeitKorr2            = x2mdate(ZeitKorr2, 0); % x2m rechnet Zeitformat um


ZeitKorr1            = ZeitKorr1 - ZeitKorr1(1, 1);        % setzt die Anfangszeit auf Null
ZeitKorr2            = ZeitKorr2 - ZeitKorr2(1, 1);        % setzt die Anfangszeit auf Null

%ZeitKorr            = ZeitKorr1 - ZeitKorr2 + (1 / 24 / 60 * 0.9); % verbleibende Zeitdifferenz händisch ausgleichen


% % Begrenzen 
% 
% Indices             = ZeitDaqPro(:, 1) < Endzeit;
% Temperatur1         = Temperatur1(Indices);
% Temperatur2         = Temperatur1(Indices);
% Fotodiode           = Temperatur1(Indices);
% 
% Indices             = ZeitKorr(:, 1) < Endzeit;
% ZeitKorr            = ZeitKorr(Indices);
% KorrKoeffizienten   = KorrKoeffizienten(Indices);


%% Plot

AH = plotyy(ZeitKorr1, KorrKoeffizienten1, ZeitKorr2, KorrKoeffizienten2);
% AH 1

title(AH(1), '3x Aerosol', 'FontSize', 20, 'Units', 'normalized')
grid(AH(1), 'on')

xlabel(AH(1), 'Zeit in Minuten', 'FontSize', 20)
ylabel(AH(1), 'Korrelationskoeffizient', 'FontSize', 16)

xlim(AH(1), [0 Endzeit])
ylim(AH(1), [0.65 1])

set(AH(1), 'LineWidth', 2)
set(AH(1), 'FontSize', 12)
set(AH(1), 'YTick', 0 : 0.05 : 1)

datetick(AH(1), 'x', 'MM', 'keepticks')

% AH 2

ylabel(AH(2), 'Korrelationskoeffizient', 'FontSize', 16)

xlim(AH(2), [0 Endzeit])
ylim(AH(2), [0.65 1])

set(AH(2), 'FontSize', 12)
set(AH(2), 'YTick', 0 : 0.05 : 1)
set(AH(2), 'XTick', []) 

% save

saveas(FigureHandle, OutputFileName)




