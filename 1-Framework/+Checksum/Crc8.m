clc
clear
close all

%% Settings

GeneratorPolynom    = '100000111';
Data                = '2E00 0000 0000 0000 0100 0000 0000';
InitialValue        = 'FF';

%% Calculation

Order               = numel(GeneratorPolynom) - 1;
Data                = Convert.HexStringToBinString(Data);
GeneratorPolynom    = bin2dec(GeneratorPolynom(2 : end));
AugmentedData     	= Logical.FromChar([Data repmat('0', 1, Order)]);

Register            = uint8(hex2dec(InitialValue));

IsBitSet            = true;

for i = 1 : numel(AugmentedData)
    
    IsBitSet        = bitget(Register, 8);
    Register        = bitshift(Register, 1) + uint8(AugmentedData(i));   
    
    if IsBitSet
         Register   = bitxor(Register, GeneratorPolynom);       
    end
    
end

fprintf('Results:\n\nBase 10: %u\nBase 16: %X\n', Register, Register)