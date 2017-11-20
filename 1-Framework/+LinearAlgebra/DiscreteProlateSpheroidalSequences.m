
function [DataTaper, Concentration] = DiscreteProlateSpheroidalSequences(DataLength, HalfTimeBandWidthProduct)

    % Calculates the discrete prolate spheroidal sequences (Slepian squences)
    % see: http://arxiv.org/pdf/1306.3184.pdf
    %
    % - Syntax -
    %
    % [DataTaper, Concentration] = DiscreteProlateSpheroidalSequences(DataLength, HalfTimeBandWidthProduct)
    %
    % - Inputs -
    %
    % DataLength                - Scalar that specifies the desired length of the sequences.
    % HalfTimeBandWidthProduct 	- Scalar that specifies the half time bandwidth product. 
    %    
    % - Outputs -
    %
    % DataTaper                 - Vector that contains the requested data tapers.
    % Concentration             - Scalar that contains the corresponding concentrations.
    %
    % - Test -
    %
    % [DataTaper, Concentration] = LinearAlgebra.DiscreteProlateSpheroidalSequences(100, 7/2)

    %% Input validation
    
    if ~isscalar(DataLength) || ~isscalar(HalfTimeBandWidthProduct)
        error('DataLength and HalfTimeBandWidthProduct must be scalars.')
    end
    
    %% Preparation
    
    SequenceCount       = min(round(2 * HalfTimeBandWidthProduct), DataLength);
    SequenceCount       = max(SequenceCount,1);
 
    W                   = HalfTimeBandWidthProduct / DataLength;
    
    %% Generate the diagonals of matrix B
        
    x                   = (0 : DataLength-1).';
    MainDiagonal        = (((DataLength - 1 - 2*x) / 2).^2) * cos(2*pi*W);
    
    x                   = (1 : DataLength-1).';
    SecondaryDiagonal   = x .* (DataLength - x) / 2;

    %% Get the eigenvalues of matrix B
    
    Eigenvalues         = LinearAlgebra.TridiagonalMatrixEigenvalues(MainDiagonal, ...
                                                                     SecondaryDiagonal, ...
                                                                     DataLength - SequenceCount + 1, ...
                                                                     DataLength);
    Eigenvalues         = flipdim(Eigenvalues, 1);
    EigenvalueCount     = length(Eigenvalues);

    %% Compute eigenvectors by inverse iteration with starting vectors of roughly the right shape.
    
    DataTaper           = zeros(DataLength, SequenceCount);
    t                   = (0 : DataLength-1).' / (DataLength-1) * pi;

	for Index = 1 : EigenvalueCount

        CharacteristicEquation = gallery('tridiag', SecondaryDiagonal, MainDiagonal-Eigenvalues(Index), SecondaryDiagonal);
        
        e = sin(Index * t);
        e = CharacteristicEquation \ e;
        e = CharacteristicEquation \ (e / norm(e));
        e = CharacteristicEquation \ (e / norm(e));

        DataTaper(:, Index) = e / norm(e);

	end

    MainDiagonal = mean(DataTaper);
    
    for Index = 1 : 2 : SequenceCount % Polarize symmetric dpss
        if MainDiagonal(Index) < 0
        	DataTaper(:, Index) = -DataTaper(:, Index); 
        end
    end
    
    for Index = 2 : 2 : SequenceCount % Polarize anti-symmetric dpss
        if DataTaper(2, Index) < 0
         	DataTaper(:, Index) = -DataTaper(:, Index); 
        end
    end

    %% Eigenvalues of sinc matrix (Percival & Walden, Exercise 8.1, p.390)

    s           = [2*W; 
                   4*W * SignalGeneration.SineCardinal(2*W*x)];
    q        	= zeros(size(DataTaper));
    BlockSize   = EigenvalueCount;  % Set to small number if out of memory
    
    for Index = 1 : BlockSize : EigenvalueCount
        BlockIndex          = Index : min(Index+BlockSize-1 , EigenvalueCount);
        q(:, BlockIndex)    = SignalProcessing.FFTFilter(DataTaper(DataLength : -1 : 1, BlockIndex), DataTaper(:, BlockIndex));
    end
    
    Concentration = q' * flipud(s);   
    Concentration = min(Concentration,1);
    Concentration = max(Concentration,0);
    
end

