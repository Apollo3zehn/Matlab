function [ExtremaPositions, Types] = Extrema(Data)

    Gradient            = diff(Data);

    %% remove duplicate entries
    DuplicatePositions  = reshape(find(Gradient == 0), 1, []);
    ShrinkedGradient    = Gradient(Gradient ~= 0);
    
    %% calculate extrema
    TemporaryData       = ShrinkedGradient(1 : end - 1 ) .* ShrinkedGradient(2 : end);
       
    %% calulate extrema positions 
    ExtremaPositions    = find(TemporaryData < 0) + 1;
    
    %% determine extrema type (peak or valley)
    Types               = abs(ShrinkedGradient(ExtremaPositions(1 : end) - 1)) .* ...
                              ShrinkedGradient(ExtremaPositions(1 : end)) * -1;

    Types               = Types ./ abs(Types);

    %% correct positions (positions are incorrect due to removed duplicates
    
    for DuplicatePosition = DuplicatePositions
        ExtremaPositions(ExtremaPositions >= DuplicatePosition) = ...
            ExtremaPositions(ExtremaPositions >= DuplicatePosition) + 1;
    end
    
end