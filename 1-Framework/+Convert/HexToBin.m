function BinaryString = HexToBin(HexChar)

    switch HexChar
        case '0'
            BinaryString = '0000';
        case '1'
            BinaryString = '0001';
        case '2'
            BinaryString = '0010';
        case '3'
            BinaryString = '0011';
        case '4'
            BinaryString = '0100';
        case '5'
            BinaryString = '0101';
        case '6'
            BinaryString = '0110';
        case '7'
            BinaryString = '0111';
        case '8'
            BinaryString = '1000';
        case '9'
            BinaryString = '1001';
        case 'A'
            BinaryString = '1010';
        case 'B'
            BinaryString = '1011';
        case 'C'
            BinaryString = '1100';
        case 'D'
            BinaryString = '1101';
        case 'E'
            BinaryString = '1110';
        case 'F'
            BinaryString = '1111';
        otherwise
            error('Invalid conversion of input %s to binary.', HexChar)
    end

end

