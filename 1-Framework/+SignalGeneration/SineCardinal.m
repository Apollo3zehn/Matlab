function SineCardinal = SineCardinal(Data)

    % Normalized cardinal sine (sinc)

    Indices                 = Data==0;
    Data(Indices)           = 1;
    
    SineCardinal            = sin(pi*Data) ./ (pi*Data);
    SineCardinal(Indices)   = 1;

end

