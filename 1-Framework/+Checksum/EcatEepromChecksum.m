clc
clear
close all

%% Settings

GeneratorPolynom    = '100000111';
Data                = '2E00 0000 0000 0000 E703 0000 0000 0000';
InitialValue        = 'FF';

%% Calculation

GeneratorPolynom    = uint16(bin2dec(GeneratorPolynom(2 : end)));
Data                = strrep(Data, ' ', '');
Register            = uint16(hex2dec(InitialValue));

for i = 0 : 13

    Register = bitxor(Register, uint16(hex2dec(Data(2*i+1 : 2*i+2))));
    
    for j = 0 : 7
       
        IsBitSet    = bitand(Register, uint16(hex2dec('80'))) > 0;
        
        if IsBitSet
            Register = bitshift(Register, 1);
            Register = bitxor(Register, GeneratorPolynom);
        else
            Register = bitshift(Register, 1);
        end
        
    end
    
end

Register = bitand(Register, uint16(hex2dec('FF')));

fprintf('Results:\n\nBase 10: %u\nBase 16: %X\n', Register, Register)