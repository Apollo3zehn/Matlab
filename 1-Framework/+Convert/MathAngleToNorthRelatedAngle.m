function [NorthRelatedAngle] = MathAngleToNorthRelatedAngle(MathAngle)
    
    % Math angle to north angle conversion
    %
    % - Syntax -
    %
    % [NorthRelatedAngle] = MathAngleToNorthRelatedAngle(MathAngle)
    %
    % - Inputs -
    %
    % MathAngle         - Input of the math angle in radian
    %
    % - Outputs -
    %
    % NorthRelatedAngle - Output of the north angle in radian
    %

    if ~isnumeric(MathAngle)
        error('Input must be numeric.')
    end
    
    %                 = angle          + 360°   + 90°
    NorthRelatedAngle = mod(-MathAngle + 2 * pi + pi / 2, 2 * pi);   
        
end

