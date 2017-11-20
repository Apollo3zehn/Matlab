function type = GetType(input)

    import System.*
    
    % Input is a string representing the class name
    % First try the static GetType method of Type handle.
    % This method can find any type from 
    % System or mscorlib assemblies
    
    type = Type.GetType(input,false,false);
    
    if isempty(type)
        % Framework's method to get the type failed.
        % Manually look for it in
        % each assembly visible to MATLAB
        assemblies = AppDomain.CurrentDomain.GetAssemblies;
        
        for i = 1:assemblies.Length
            
            asm = assemblies.Get(i-1);
            % Look for a particular type in the assembly
            type = GetType(asm,input,false,false);
            if ~isempty(type)
                % Found the type - done
                break
            end
        end
        
    end
    
end