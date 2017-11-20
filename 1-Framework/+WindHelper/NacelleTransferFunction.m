function NacelleTransferFunction = NacelleTransferFunction(Dataset, ReferenceFieldName, ParameterSet, Order)

    % Calculates nacelle transfer function
    %
    % - Syntax -
    %
    % NacelleTransferFunction = NacelleTransferFunction(Dataset)
    %
    % - Inputs -
    %  
    % Dataset       - Table with the following columns:
    %                   - WindSpeed in m/s
    %                   - WindDirection in deg
    %
    % ReferenceFieldName - Name the nacelle wind speed field in table Dataset
    %
    % ParameterSet  - Structure with the following fields:
    %                   - MeasurementSectorSet: n x 2 matrix, with the following structure: 
    %                                           [MinWindDir1 MaxWindDir1]
    %                                           [MinWindDir2 MaxWindDir2]
    %                                           [MinWindDirn MaxWindDirn]
    %                   - UseMinMaxForWindDir: if false, use average of wind direction       
    %
    % - Outputs -
    %
    % NacelleTransferFunction - Structure with the following fields:
    %                   - Coefficients (1 x n matrix with coefficients)
    %                   - FittedCurve (m x 1 matrix with fitted curve)
    %                   - R2 (coefficient of determination)
  
    %%

    % filter by wind direction
    
    Indices         = zeros(size(Dataset, 1), 1);
    
    for i = 1 : size(ParameterSet.MeasurementSectorSet, 1)
        if ParameterSet.UseMinMaxForWindDir
            Indices = Indices | (ParameterSet.MeasurementSectorSet(i, 1) <= Dataset.WindDirection_min & Dataset.WindDirection_min <= ParameterSet.MeasurementSectorSet(i, 2) & ...
                                 ParameterSet.MeasurementSectorSet(i, 1) <= Dataset.WindDirection_max & Dataset.WindDirection_max <= ParameterSet.MeasurementSectorSet(i, 2));
        else
            Indices = Indices | (ParameterSet.MeasurementSectorSet(i, 1) <= Dataset.WindDirection & Dataset.WindDirection <= ParameterSet.MeasurementSectorSet(i, 2));                   
        end        
    end
    
    Dataset         = Dataset(Indices, :);
    
    % calculate slope and offset
    
    [Coefficients, FittedCurve, R2]         = LinearAlgebra.LinearRegression(Dataset.(ReferenceFieldName), Dataset.WindSpeed, Order);
   
    NacelleTransferFunction.Coefficients    = Coefficients;
    NacelleTransferFunction.FittedCurve     = FittedCurve;
    NacelleTransferFunction.R2              = R2;
    
end