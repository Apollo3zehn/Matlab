% http://stats.stackexchange.com/questions/137384/confidence-interval-calculation-for-power-density-estimation-in-matlab

function ConfidenceInterval = ConfidenceInterval(ConfidenceLevel, IndependentMeasurements)

    if ~isscalar(ConfidenceLevel) || ~isscalar(IndependentMeasurements)
        error('ConfidenceLevel and IndependentMeasurements must be scalars.')
    end

    DegreesOfFreedom    = 2 * IndependentMeasurements;
    Alpha               = 1 - ConfidenceLevel;
    x                   = Distribution.ChiSquaredCdfInverse([1 - Alpha/2 Alpha/2], DegreesOfFreedom);
    ConfidenceInterval 	= DegreesOfFreedom ./ x;

end