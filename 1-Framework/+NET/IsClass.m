function isClass = IsClass(input)

    type = input.GetType;

    if input.GetType.IsArray
        type = type.GetElementType;
    end
      
    isClass    = type.IsClass;
    
end

