function Eigenvalues = TridiagonalMatrixEigenvalues(MainDiagonal, SecondaryDiagonal, FirstEigenvalueIndex, LastEigenvalueIndex)
   
    % Eigenvalues of symmetric tridiagonal matrix using the bisection method. Efficient for large matrices.
    % see: http://www.maths.ed.ac.uk/~aar/papers/bamawi.pdf
    %
    % - Syntax -
    %
    % Eigenvalues = TridiagonalMatrixEigenvalues(MainDiagonal, SecondaryDiagonal, FirstEigenvalueIndex, LastEigenvalueIndex)
    %
    % - Inputs -
    %
    % MainDiagonal          - Vector of length N that contains the elements of the main diagonal.
    % SecondaryDiagonal    	- Vector of length N-1 that contains the elements of the symmetric secondary diagonals.
    % FirstEigenvalueIndex 	- Index of first eigenvalue that is computed.
    % LastEigenvalueIndex   - Index of last eigenvalue that is computed.
    %    
    % - Outputs -
    %
    % Eigenvalues           - Vector that contains the requested eigenvalues.
    %
    % - Test -
    %
    % clc
    % N                 = 10000;
    % MainDiagonal      = rand(N, 1); 
    % SecondaryDiagonal = rand(N - 1, 1);
    %
    % tic
    % Eigenvalues       = LinearAlgebra.TridiagonalMatrixEigenvalues(MainDiagonal, SecondaryDiagonal, 9994, 10000);
    % fprintf('\nTridiagonalMatrixEigenvalues(..):\n\n...\n'); fprintf('%f\n', Eigenvalues); fprintf('\n');
    % toc
    %
    % tic
    % Eigenvalues       = eig(gallery('tridiag', SecondaryDiagonal, MainDiagonal, SecondaryDiagonal));
    % fprintf('\neig(..):\n\n...\n'); fprintf('%f\n', Eigenvalues(end - 6 : end)); fprintf('\n');
    % toc
    
    %% Input checks
    
    if ~isvector(MainDiagonal) || ~isvector(SecondaryDiagonal)
        error('MainDiagonal and SecondaryDiagonal must be vectors.')
    end
    
    if numel(SecondaryDiagonal) ~= numel(MainDiagonal) - 1
        error('Length of SecondaryDiagonal is not N-1.')
    end
    
    if ~isscalar(FirstEigenvalueIndex) || ~isscalar(LastEigenvalueIndex)
        error('FirstEigenvalueIndex and LastEigenvalueIndex must be scalars.')
    end
    
    %% Bisection Method
    
    MainDiagonal        = MainDiagonal(:);
    Length           	= length(MainDiagonal);
    SecondaryDiagonal  	= [0; SecondaryDiagonal(:)];
    Beta                = SecondaryDiagonal.^2;
            
    AbsoluteMinimum     = min(...
                              MainDiagonal(Length) - abs(SecondaryDiagonal(Length)), ...
                              min(MainDiagonal(1 : Length-1) - abs(SecondaryDiagonal(1 : Length-1)) - abs(SecondaryDiagonal(2 : Length))) ...
                              );
                          
    AbsoluteMaximum     = max(...
                              MainDiagonal(Length) + abs(SecondaryDiagonal(Length)), ...
                              max(MainDiagonal(1 : Length-1) + abs(SecondaryDiagonal(1:Length-1)) + abs(SecondaryDiagonal(2:Length)))...
                              );
                          
    eps1                = eps * max(AbsoluteMaximum, -AbsoluteMinimum);

    UpperBounds(FirstEigenvalueIndex : LastEigenvalueIndex, 1) = repmat(AbsoluteMaximum, LastEigenvalueIndex - FirstEigenvalueIndex + 1, 1);
    LowerBounds(FirstEigenvalueIndex : LastEigenvalueIndex, 1) = repmat(AbsoluteMinimum, LastEigenvalueIndex - FirstEigenvalueIndex + 1, 1);
    
    CurrentUpperBound  	= AbsoluteMaximum;
        
	for Index = LastEigenvalueIndex : -1 : FirstEigenvalueIndex
        
        CurrentLowerBound = AbsoluteMinimum;
       
        for SubIndex = Index : -1 : FirstEigenvalueIndex
            if CurrentLowerBound < LowerBounds(SubIndex)
                CurrentLowerBound = LowerBounds(SubIndex);
                break
            end
        end
       
        if CurrentUpperBound > UpperBounds(Index) 
            CurrentUpperBound = UpperBounds(Index); 
        end
       
        while true
           
            % fprintf('%f %f\n', CurrentLowerBound, CurrentUpperBound)
            
            NewBound = (CurrentLowerBound + CurrentUpperBound) / 2;

            if CurrentUpperBound - CurrentLowerBound <= 2*eps * (abs(CurrentLowerBound) + abs(CurrentUpperBound)) + eps1
                break
            end
          
            a = 0;
            q = 1;
          
            for SubIndex = 1 : Length
              
                if q ~= 0
                    q = MainDiagonal(SubIndex) - NewBound - Beta(SubIndex) / q;
                else
                    q = MainDiagonal(SubIndex) - NewBound - abs(SecondaryDiagonal(SubIndex)) / eps;
                end
             
                if q < 0
                    a = a + 1;
                end
             
            end
          
            if a < Index

                if a < FirstEigenvalueIndex
                    CurrentLowerBound = NewBound;
                    LowerBounds(FirstEigenvalueIndex) = NewBound;
                else

                    CurrentLowerBound = NewBound;
                    LowerBounds(a + 1) = NewBound;

                    if UpperBounds(a) > NewBound 
                        UpperBounds(a) = NewBound; 
                    end

                end

            else
                CurrentUpperBound = NewBound;
            end
                      
        end
       
        UpperBounds(Index) = (CurrentUpperBound + CurrentLowerBound) / 2;
       
	end
    
    Eigenvalues = UpperBounds(FirstEigenvalueIndex : LastEigenvalueIndex, 1);

end

