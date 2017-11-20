classdef Math
    
    enumeration
        RoundUp, RoundDown, RoundNearest
    end

    methods(Static)

        function [RoundedValue] = Round(Value, Precision, RoundingMode)

            switch RoundingMode
                case Math.RoundUp
                    RoundedValue = ceil(Value * 10^(-Precision)) / (10^(-Precision));
                case Math.RoundDown
                    RoundedValue = floor(Value * 10^(-Precision)) / (10^(-Precision));
                case Math.RoundNearest
                    RoundedValue = round(Value * 10^(-Precision)) / (10^(-Precision));
            end

        end

    end
    
end