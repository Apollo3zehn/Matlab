% Minuend (rad) and Subtrahend (rad) 
% or 
% Minuend as element vector and Subtrahend as element vector

function [AngleDifference] = AngleBetween(Minuend, Subtrahend)

    if isvector(Minuend) && ~isscalar(Minuend) && isvector(Subtrahend) && ~isscalar(Subtrahend)
        
        AngleDifference = acos(norm(dot(Minuend, Subtrahend)) / (norm(Minuend) * norm(Subtrahend)));
        
    elseif isscalar(Minuend) && isscalar(Subtrahend)
      
        Minuend         = Minuend(:);
        Subtrahend      = Subtrahend(:);

        Minuend         = [cos(Minuend) 	sin(Minuend)];
        Subtrahend      = [cos(Subtrahend)	sin(Subtrahend)];

        AngleDifference = acos(dot(Minuend, Subtrahend, 2));
        
    else
        
        error('One or both inputs does not meet the requirements: both inputs must be passed as scalar or as vector.')
        
    end
    
end


