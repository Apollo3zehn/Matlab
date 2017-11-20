function [RoughnessLength] = RoughnessLength(WindSpeed1, Height1, WindSpeed2, Height2)

    RoughnessLength = exp((log(Height2) .* WindSpeed1 - log(Height1) .* WindSpeed2) ./ (-WindSpeed2 + WindSpeed1));

end

