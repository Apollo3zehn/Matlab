classdef Reflection
   
methods (Static)

    function [FunctionName] = FunctionName
        
        StackInformation    = dbstack;
        
        if length(StackInformation) >= 2
            FunctionName    = StackInformation(2).name;
        else
            FunctionName    = '';
        end
        
    end
    
    function [FunctionName] = CallingFunctionName
        
        StackInformation    = dbstack;
        
        if length(StackInformation) >= 3
            FunctionName    = StackInformation(3).name;
        else
            FunctionName    = '';
        end
        
    end
    
end
    
end
