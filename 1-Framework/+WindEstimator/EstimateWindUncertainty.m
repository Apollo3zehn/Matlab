function DeltaWindSpeed = EstimateWindUncertainty(AerodynamicMap, AirDensity, DeltAirDensity, PitchAngle, DeltaPitchAngle, RotorMoment, DeltaRotorMoment,  RotorSpeed, DeltaRotorSpeed)

    %% Algorithm Parameters Configuration
    pd_factor           = 0.00001;    % partial derivative width
    
    %% Partial derivations preparation
    % define the ranges on each variable to calculate the partial derivatives
    AirDensityMin       = AirDensity * (1 - pd_factor);
    AirDensityMax       = AirDensity * (1 + pd_factor);    
    RotorMomentMin      = RotorMoment * (1 - pd_factor);
    RotorMomentMax      = RotorMoment * (1 + pd_factor);
    RotorSpeedMin       = RotorSpeed * (1 - pd_factor);
    RotorSpeedMax       = RotorSpeed * (1 + pd_factor);
    
    % do not forget case where pitch = 0
    ZeroPitchIndices    = PitchAngle == 0;
    NonZeroPitchIndices = ~ZeroPitchIndices;
      
    PitchAngleMin(ZeroPitchIndices, 1)     =  pi/180 * pd_factor;
    PitchAngleMax(ZeroPitchIndices, 1)     = -pi/180 * pd_factor;
    
    PitchAngleMin(NonZeroPitchIndices, 1)  =  PitchAngle(NonZeroPitchIndices, 1) * (1 - pd_factor);
    PitchAngleMax(NonZeroPitchIndices, 1)  =  PitchAngle(NonZeroPitchIndices, 1) * (1 + pd_factor);

    %% Calculate partial derivatives
    WindSpeedMax        = WindEstimator.EstimateWindSpeed(AerodynamicMap, AirDensityMin, PitchAngle, RotorMoment, RotorSpeed);
    WindSpeedMin        = WindEstimator.EstimateWindSpeed(AerodynamicMap, AirDensityMax, PitchAngle, RotorMoment, RotorSpeed);
    pd_AirDensity       = abs((WindSpeedMax - WindSpeedMin) ./ (AirDensityMax - AirDensityMin));
 
    WindSpeedMax        = WindEstimator.EstimateWindSpeed(AerodynamicMap, AirDensity, PitchAngleMin, RotorMoment, RotorSpeed);
    WindSpeedMin        = WindEstimator.EstimateWindSpeed(AerodynamicMap, AirDensity, PitchAngleMax, RotorMoment, RotorSpeed);
    pd_PitchAngle       = abs((WindSpeedMax - WindSpeedMin) ./ (PitchAngleMax - PitchAngleMin));
    
    WindSpeedMax        = WindEstimator.EstimateWindSpeed(AerodynamicMap, AirDensity, PitchAngle, RotorMomentMin, RotorSpeed);
    WindSpeedMin        = WindEstimator.EstimateWindSpeed(AerodynamicMap, AirDensity, PitchAngle, RotorMomentMax, RotorSpeed);
    pd_RotorMoment      = abs((WindSpeedMax - WindSpeedMin) ./ (RotorMomentMax - RotorMomentMin));

    WindSpeedMax        = WindEstimator.EstimateWindSpeed(AerodynamicMap, AirDensity, PitchAngle, RotorMoment, RotorSpeedMin);
    WindSpeedMin        = WindEstimator.EstimateWindSpeed(AerodynamicMap, AirDensity, PitchAngle, RotorMoment, RotorSpeedMax);
    pd_RotorSpeed       = abs((WindSpeedMax - WindSpeedMin) ./ (RotorSpeedMax - RotorSpeedMin));
       
    %% Calculate the standard deviation
    DeltaWindSpeed      = sqrt(...
                                  (pd_AirDensity .* DeltAirDensity) .^ 2 + ...
                                  (pd_PitchAngle .* DeltaPitchAngle) .^ 2 + ...
                                  (pd_RotorMoment .* DeltaRotorMoment) .^ 2 + ...
                                  (pd_RotorSpeed .* DeltaRotorSpeed) .^ 2 ...
                               );
end
    