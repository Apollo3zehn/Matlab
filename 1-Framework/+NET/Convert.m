function output = Convert(input)
    
    isArray = false;

    if ismethod(input, 'GetType') && input.GetType.IsArray
       isArray = true;
    elseif ismethod(input, 'ToArray')
       input = input.ToArray(); 
       isArray = true;
    end

    switch true
            
        case isnumeric(input)
            output = double(input);
        
        case islogical(input)
            output = input;
            
        case isa(input, 'System.String')
            output = char(input);
                   
        case isa(input, 'System.String[]')
            output = cell(input).'; 
            
        case isArray
            
            count = input.Length;
            
            for i = count : -1 : 1
                
                currentElement = input(i);

                if count == 1
                    output = NET.Convert(currentElement);
                else
                    output(i) = NET.Convert(currentElement);
                end  

            end 
            
        case isa(input, 'System.DateTime')
            output = char(input.ToString());  
            
        case NET.IsDictionary(input)
            output = NET.ConvertDictionary(input);    
                       
        case NET.IsStruct(input) | NET.IsClass(input)
            
            for fieldName = fieldnames(input).'              
            
                fieldName = char(fieldName);

                if (strcmp(fieldName, 'Parent'))
                    continue    
                end   
               
                output.(fieldName) = NET.Convert(input.(fieldName));
            
            end

        otherwise
            error('not implemented')
            
    end
    
    if ~exist('output', 'var')
        output = [];
    end

end

