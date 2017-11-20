function ratio = THD(frequencySet, amplitudeSet, baseFrequency, width, maxHarmonic, fun)

    maxSet = [];
    offset = idivide(int32(width), 2, 'fix');
    
    for i = 1 : 2 : maxHarmonic
        index = find(frequencySet >= baseFrequency * i, 1, 'first');
        maxSet((i + 1) / 2) = fun(amplitudeSet(index - offset : index + offset));
    end

    ratio = sum(maxSet(2 : end)) / maxSet(1);
        
end
