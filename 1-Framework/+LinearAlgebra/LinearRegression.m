function [Coefficients, FittedCurve, R2] = LinearRegression(x, y, Order)

    Coefficients    = polyfit(x, y, Order);
    FittedCurve     = polyval(Coefficients, x);

    Residuals       = y - FittedCurve;

    SSresid         = sum(Residuals .^ 2);
    SStotal         = (length(y) - 1) * var(y);

    R2              = 1 - SSresid/SStotal;
   
end

