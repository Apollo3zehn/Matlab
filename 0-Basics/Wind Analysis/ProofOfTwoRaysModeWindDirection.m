clc
clear
close all
    
%% Input parameters

WindDirection   = Convert.NorthRelatedAngleToMathAngle(5 / 180 * pi);
WindSpeed       = 11;

Ray1Direction   = Convert.NorthRelatedAngleToMathAngle(345 / 180 * pi);
Ray2Direction   = Convert.NorthRelatedAngleToMathAngle(15 / 180 * pi);

Ray1            = WindSpeed * cos(abs(Ray1Direction - WindDirection));
Ray2            = WindSpeed * cos(abs(Ray2Direction - WindDirection));

%% Method 1 - Vector addition

Ray1x           = Ray1 * sin(Ray1Direction);
Ray1y           = Ray1 * cos(Ray1Direction);

Ray2x           = Ray2 * sin(Ray2Direction);
Ray2y           = Ray2 * cos(Ray2Direction);

Rayx            = Ray1x + Ray2x;
Rayy            = Ray1y + Ray2y;

Angle1          = atan(Rayy / Rayx) * 180 / pi;

%% Method 2 - System of equation

AngleBetween    = Ray1Direction - Ray2Direction;

Zaehler         = 1 / sin(AngleBetween) * (Ray2 - Ray1 * cos(AngleBetween));

Angle2          = atan(Zaehler / Ray1);
Angle2          = Convert.MathAngleToNorthRelatedAngle(Ray1Direction - Angle2) * 180 / pi;
Angle2(Angle2 > 180) = Angle2(Angle2 > 180) - 360;

WindSpeed2      = Ray1 / cos(Ray1Direction - -(Angle2 - 90) / 180 * pi);

%% Method 3 - DONG

WindSpeed       = 10;
Alpha           = 15;

Alpha           = Alpha / 180 * pi;
Gamma         	= 5 / 180 * pi;

VR              = WindSpeed * cos(Alpha + Gamma);
VL              = WindSpeed * cos(Alpha - Gamma);

f               = VL / VR;

Gamma2          = atan( ...
                        (f - 1) / ...
                        (tan(Alpha) * (f + 1)) ...
                       );
Angle3          = Gamma2 * 180 / pi;
WindSpeed3      = Ray1 / cos(Alpha + Angle3 / 180 * pi);