function C_P = PowerCoefficient(Power, WindSpeed, AirDensity, RotorDiameter)
    C_P = Power ./ (0.5 * AirDensity .* (pi/4 * RotorDiameter.^2) .* WindSpeed.^3);
end

