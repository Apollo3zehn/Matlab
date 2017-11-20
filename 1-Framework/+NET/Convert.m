function output = Convert(input)

    output = [];

    for i = 1 : numel(input)

        if input.GetType.IsArray
            if (input.Length >= i)
                currentElement = input(i);
            else
                return
            end
        else
            currentElement = input;
        end
        
        for fieldName = fieldnames(currentElement).'              
            fieldName = char(fieldName);
            output(i).(fieldName) = NET.ConvertType(currentElement.(fieldName));
        end
        
    end

end

