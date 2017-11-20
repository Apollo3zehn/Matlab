function Hamming = Hamming(Length)
    
    if ~isequal(fix(Length), Length) 
        error('Length must be integer.')
    end

    alpha   = 0.54;
    beta    = 1 - alpha;

    Hamming = alpha - beta * cos(2*pi * (1 : Length)' / (Length-1));
    
end
