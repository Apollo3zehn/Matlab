function [WindDirection] = WindDirection(AzimuthAngle, RelativeWindDirection) 

    WindDirection = AzimuthAngle + RelativeWindDirection;
    
    WindDirection(WindDirection < 0) = 360 + WindDirection(WindDirection < 0);
    
    WindDirection(WindDirection > 360) = WindDirection(WindDirection > 360) - 360;
    
end 

