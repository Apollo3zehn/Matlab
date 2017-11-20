% Input must be a vector
% 0 = 000 => 000 = 0
% 1 = 001 => 100 = 4
% 2 = 010 => 010 = 2
% 3 = 011 => 110 = 6
% 4 = 100 => 001 = 1
% 5 = 101 => 101 = 5
% 6 = 110 => 011 = 3
% 7 = 111 => 111 = 7

function [BitReversedIndex] = BitReversedIndex(Length)

    Index               = (0 : Length - 1)';
    BitReversedIndex    = zeros(Length, 1);
    RecursionCount      = nextpow2(Length);

    for RecursionNumber = 1 : RecursionCount;
        
        BitReversedIndex(:, 1) = bitor(BitReversedIndex(:, 1), bitshift(bitand(Index(:, 1), bitshift(1, RecursionNumber-1)), RecursionCount - RecursionNumber * 2 + 1));

    end
    
end

