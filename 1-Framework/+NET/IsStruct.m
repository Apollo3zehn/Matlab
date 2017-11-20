function isStruct = IsStruct(input)

    type = input.GetType;

    if input.GetType.IsArray
        type = type.GetElementType;
    end
      
    isStruct    = type.IsValueType & ~type.IsPrimitive & ~type.IsEnum;
    
end

