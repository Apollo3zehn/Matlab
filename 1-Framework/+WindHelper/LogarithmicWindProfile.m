function [NewWindSpeed] = LogarithmicWindProfile(ReferenceWindSpeed, ReferenceHeight, NewHeight, RoughnessLength)

    NewWindSpeed = ReferenceWindSpeed .* log(NewHeight ./ RoughnessLength) ./ log(ReferenceHeight ./ RoughnessLength);

end

