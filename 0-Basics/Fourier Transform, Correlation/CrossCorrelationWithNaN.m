%   •	Angenommen wir haben ein perfekt verschobenes Signal (also ohne Verzerrung oder Ähnliches)
%   •	Jetzt werden beide Signal entsprechend der NaNs gefiltert und zusammengesetzt
%   •	Die Kreuzkorrelation möchte die oben angenommene Verschiebung rückgängig machen
%   •	Da aber das Signal gestückelt, also zeitlich nicht mehr stetig ist, ist eine exakt genauso große Verschiebung nicht sinnvoll, da dann Wertpaare entstehen, die zeitlich nicht zusammengehören. 
%   •	Dieser Fehler führt zu einer geringeren Korrelation. Der Peak der Korrelation liegt irgendwo zwischen einer Nullverschiebung und der wahren Verschiebung.

function [] = CrossCorrelationWithNaN

    clc
    clear
    close all

    Shift = +145;

    a1  = rand(10000, 1);
    a2  = a1;
    a2(rand(10000, 1) > 0.95) = NaN;
    a3  = interp1(find(~isnan(a2)), a2(~isnan(a2)), (1 : numel(a2))');
    
    if Shift > 0
        NewPart = rand(Shift, 1);
        b1 = [NewPart; a1(1 : end - Shift)];
        b2 = [NewPart; a2(1 : end - Shift)];
        b3 = [NewPart; a3(1 : end - Shift)];
    else
        NewPart = rand(abs(Shift), 1);
        b1 = [a1(abs(Shift - 1) : end); NewPart];
        b2 = [a2(abs(Shift - 1) : end); NewPart];
        b3 = [a3(abs(Shift - 1) : end); NewPart];
    end
    
    Indices = ~isnan(a2) & ~isnan(b2);
    a2 = a2(Indices);
    b2 = b2(Indices);

    Indices = ~isnan(a3) & ~isnan(b3);
    a3 = a3(Indices);
    b3 = b3(Indices);
    
    [R1, Lag1] = SignalProcessing.NormalizedCrossCorrelation(b1, a1);
    [R2, Lag2] = SignalProcessing.NormalizedCrossCorrelation(b2, a2);
    [R3, Lag3] = SignalProcessing.NormalizedCrossCorrelation(b3, a3);
       
    %%

    hold on
    plot(Lag1, R1, 'k')
    plot(Lag2, R2, 'r')
    plot(Lag3, R3, 'b')
    hold off
    
    [R1, LagPosition1] = max(R1);
    [R2, LagPosition2] = max(R2);
    [R3, LagPosition3] = max(R3);
    
    xlim([-abs(Shift) * 2 +abs(Shift) * 2]);
    xlabel('Lag (-)');
    ylabel('Correlation coefficient R (-)');
    
    text(Lag1(LagPosition1) + 10, R1, sprintf('Normal position: %.0f', Lag1(LagPosition1)), 'color', 'k');
    text(Lag2(LagPosition2) + 10, R2, sprintf('NaN position: %.0f', Lag2(LagPosition2)), 'color', 'r');
    text(Lag3(LagPosition3) + 10, R3 - 0.1, sprintf('Interpolated position: %.0f', Lag3(LagPosition3)), 'color', 'b');
    
end
