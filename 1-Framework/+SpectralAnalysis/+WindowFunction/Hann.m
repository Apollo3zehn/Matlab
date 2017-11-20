function Hann = Hann(Length)

    if ~isequal(fix(Length), Length) 
        error('Length must be integer.')
    end

    Hann = 0.5 - 0.5*cos(2*pi * (1 : Length)' / (Length-1));
    
end
