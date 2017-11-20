function method = GetMethod(typeName, methodName, bindingFlagSet)

    import System.*
    import System.Reflection.*

    type            = NET.GetType(typeName);
    enumType        = NET.GetType('System.Reflection.BindingFlags');
    bindingFlags    = 0;
    
    for i = 1 : numel(bindingFlagSet)
        bindingFlags = bitor(bindingFlags, bindingFlagSet(i));
    end
    
    method = type.GetMethod(methodName, Enum.ToObject(enumType, bindingFlags));

end

