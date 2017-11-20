function BinaryString = HexStringToBinString(HexString)

    if ~isvector(HexString)
        error('Input must be a string.')
    end

    HexString       = upper(HexString(:).');
    BinaryString    = [];

    for i = 1 : numel(HexString)
        
        if strcmp(HexString(i), ' ') 
            continue
        end
        
        BinaryString = [BinaryString Convert.HexToBin(HexString(i))];
        
    end

end

