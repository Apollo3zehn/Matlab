clc
clear

%WindEstimator.VisualizeCpMap(load([M5000_116.CharacteristicMapsPath '\Kennfelder_M5000-116_Bladed.mat']));

rho             = 1.225;
AeroMap         = load([AD_5_135.CharacteristicMapsPath '\Kennfelder_M5000-135_Aerodyn.mat']);

PitchAngle      = pi/180 * 70;  
GenoMomentLSS   = 0.006e6;
OmRotor         = 2*pi/60 * 1;

FreeWind        = WindEstimator.EstimateWindSpeed(AeroMap, rho, PitchAngle, GenoMomentLSS, OmRotor);
    

% rho             = 1.225;
% AeroMap         = load([M5000_116.CharacteristicMapsPath '\Kennfelder_M5000-135_Aerodyn.mat']);
% 
% PitchAngle      = -0.09;  
% GenoMomentLSS   = 885000;
% OmRotor         = 0.65;
% 
% FreeWind        = WindEstimator.EstimateWindSpeed(AeroMap, rho, PitchAngle, GenoMomentLSS, OmRotor);
