function [WindDirection] = CalculateTwoRaysModeWindDirection(RayDirection, RayWindSpeed)

    % 3D-Format:
    % [Gates, Rays, Time]

    AngleBetween    = LinearAlgebra.AngleBetween(RayDirection(1), RayDirection(2));
    WindDirection   = RayDirection(1) - atan((1 ./ sin(AngleBetween) .* (RayWindSpeed(:, 2, :) - RayWindSpeed(:, 1, :) .* cos(AngleBetween))) ./ RayWindSpeed(:, 1, :));

end

