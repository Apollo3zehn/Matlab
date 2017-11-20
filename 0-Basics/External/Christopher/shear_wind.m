function [NewWindSpeed]  = shear_wind(ini, NewHeight)
    
NewWindSpeed = ini.v_w*(log(NewHeight/ini.shearc)/log(ini.hubheight/ini.shearc));

end

