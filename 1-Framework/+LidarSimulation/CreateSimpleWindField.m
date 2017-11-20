function [u, v] = CreateSimpleWindField(x, y, MeanWindSpeed, WindDirection, WindShear)

    u    	= -MeanWindSpeed + WindShear * y;
    v    	= zeros(size(u));
    [u, v]	= Transformation2D.RotateVectorField(x, y, u, v, WindDirection/180*pi); 
    
end

