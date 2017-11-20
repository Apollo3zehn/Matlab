function [NewWindSpeed] = ApplyShearCoefficient(WindSpeed, Height, NewHeight, ShearCoefficient)

    NewWindSpeed = WindSpeed .* (NewHeight ./ Height) .^ ShearCoefficient;

end