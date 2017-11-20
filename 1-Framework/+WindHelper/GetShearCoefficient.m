function [ShearCoefficient] = GetShearCoefficient(WindSpeed1, Height1, WindSpeed2, Height2)

    ShearCoefficient = log(WindSpeed1 ./ WindSpeed2) ./ log(Height1 ./ Height2);

end

