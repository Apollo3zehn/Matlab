function [RoughnessLength] = RoughnessLengthScatter(WindSpeed, Height)

    % y = m·x + b
    % 0 = m·x + b
    % x = -b / m = ln(RoughnessLength)

    Coefficients    = polyfit(log(Height), WindSpeed, 1);
    RoughnessLength = exp(-Coefficients(2) / Coefficients(1));

end

