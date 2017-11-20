function Coherence = Kaimal(MeanWindSpeed, FrequencySet, DistanceSet, CoherenceDecay, CoherenceLengthScale, Component)

    FrequencySet   = FrequencySet(:);
    DistanceSet    = DistanceSet(:).';

    switch Component
        case 'u'
            Coherence = exp(-CoherenceDecay * sqrt(bsxfun(@plus, (0.12 / CoherenceLengthScale).^2, (FrequencySet / MeanWindSpeed).^2)) * DistanceSet);
        case 'v'
            Coherence = exp(-CoherenceDecay * FrequencySet * DistanceSet / MeanWindSpeed);
        case 'w'
            Coherence = exp(-CoherenceDecay * FrequencySet * DistanceSet / MeanWindSpeed);
        otherwise
            error('Wrong Component parameter. Allowed values are {''u'', ''v'', ''w''}') 
    end 
   
end