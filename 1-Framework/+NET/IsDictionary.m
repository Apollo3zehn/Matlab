function isDictionary = IsDictionary(input)

    type = input.GetType;
    
    if type.IsGenericType
        isDictionary = strcmp(char(NET.GetType('System.Collections.Generic.Dictionary`2').FullName), char(type.GetGenericTypeDefinition.FullName));
    else
        isDictionary = false;
    end
    
end

