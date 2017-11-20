function [Power] = PowerInWind(WindSpeed)
    Power = Constants.AirDensity / 2 * WindSpeed .^ 3 * pi * (Constants.RotorDiameter / 2) .^ 2;
end

