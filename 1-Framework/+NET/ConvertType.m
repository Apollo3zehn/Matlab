function output = ConvertType(input)

    switch true
            
        case isnumeric(input)
            output = double(input);
        
        case isa(input, 'System.String')
            output = char(input);
        
        case isa(input, 'System.String[]')
            output = cell(input).';    

        case NET.IsDictionary(input)
            output = NET.ConvertDictionary(input);    
                       
        case NET.IsStruct(input) | NET.IsClass(input)
            output = NET.Convert(input);    

        otherwise
            error('not implemented')
            
    end

end

