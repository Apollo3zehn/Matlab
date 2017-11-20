function [X, MetaData] = LevenbergMarquardt(Delegate, X, lambda)

    % Levenberg-Marquardt algorithm
    %
    % - Syntax -
    %
    % [X, MetaData] = LevenbergMarquardt(Delegate, X, lambda)
    %
    % - Inputs -
    %
    % Delegate              - Function delegate that represents the system whose parameters should be identified.
    % X                     - Initial guess of the solution.
    % lambda                - Initial speed of the algorithm.
    %
    % - Outputs -
    %
    % X                     - Found solution. 
    % MetaData              - Structure that gives information about the solution.
    %
    % - Test -
    %
    % Measurement             	= [0.75 0.8];
    %     
    % Delegate                 	= @(x) SystemEquation(x);
    % InitialGuess             	= [0.5 0.5];
    % lambda                   	= 0.01;
    % 
    % [Result, MetaData]       	= LevenbergMarquardt(Delegate, InitialGuess, lambda);
    % 
    % if MetaData.Success
    %     fprintf('Found parameters: X1 = %.2f, X2 = %.2f using %d iterations.\n', Result(1), Result(2), MetaData.IterationCount)
    % else
    %     fprintf('Failed to find a solution.')
    % end
    % 
    % function F = SystemEquation(Y)
    % 
    %     IntermediateResult = [  sin(Y(1)).^2 + cos(Y(2)), ...
    %                             tan(Y(1)).^3 + sin(Y(2))];
    % 
    %     F = Measurement - IntermediateResult;
    % 
    % end


    CostFunction            = feval(Delegate, X);
    CostFunction            = CostFunction(:);
    
    X_size                  = size(X);
    X                       = X(:);
    VariableCount           = numel(X);
    FunctionCount           = numel(CostFunction);
    FunctionEvaluationCount = 1;
    MaxFunctionEvaluations  = 200 * VariableCount;
    
    IterationCount          = 0;
    MaxIterations           = 400;
    
    SumOfSquares            = CostFunction' * CostFunction;
    ZeroPadding             = zeros(VariableCount, 1);
    SuccessfulStep          = true;
    Jacobian               	= zeros(FunctionCount, VariableCount);
    
    tolX                    = 1e-6;
    tolFun                  = 1e-6;
    tolOpt                  = 1e-4 * tolFun;
    
    %% this section depends on external function finitedifferences
    
    sizes.xRows             = X_size(1);
    sizes.xCols             = X_size(2);
    FiniteDifferenceFlags = struct(...
                                'fwdFinDiff', 1, ...
                                'scaleObjConstr', 0, ...
                                'chkFunEval', 0, ...
                                'chkComplexObj', 0, ...
                                'isGrad', 0, ...
                                'hasLBs', false(VariableCount, 1), ...
                                'hasUBs', false(VariableCount, 1));
	Options = struct(...
                    'DiffMinChange', 0, ...
                    'DiffMaxChange', Inf, ...
                    'FinDiffType', 'forward', ...
                    'FinDiffRelStep', ones(VariableCount, 1) * 1.49011611938477e-08, ...
                    'TypicalX', 1);
                
    [Jacobian, ~, ~, NumberOfEvaluations, IsJacobianDefined] = finitedifferences(X, Delegate, [], [], [], CostFunction, [], [], 1 : VariableCount, Options, sizes, Jacobian, [], [], FiniteDifferenceFlags, []);
    
    %%
    
    FunctionEvaluationCount        = FunctionEvaluationCount + NumberOfEvaluations;
    
    if ~IsJacobianDefined
        error('Finite difference Jacobian at initial point contains Inf or NaN values.')
    end 

    F_gradient                    	= Jacobian' * CostFunction;
    relFactor                       = max(norm(F_gradient, Inf), sqrt(eps)); 

    Done                            = TestConvergence;

    while ~Done  
    
        % begin trial
        
        ScaleMatrix               	= sqrt(lambda) * eye(VariableCount);

        if SuccessfulStep
            AugmentedJacobian    	= [Jacobian; ScaleMatrix];
            AugmentedResidual     	= [-CostFunction; ZeroPadding];
        else
            AugmentedJacobian(FunctionCount + 1 : end, :) = ScaleMatrix;
        end

        warningstate1               = warning('off', 'MATLAB:nearlySingularMatrix');
        warningstate2            	= warning('off', 'MATLAB:singularMatrix');
        warningstate3               = warning('off', 'MATLAB:rankDeficientMatrix');

        step = AugmentedJacobian \ AugmentedResidual;

        warning(warningstate1)
        warning(warningstate2)
        warning(warningstate3)

        X_trial = X + step;

        TrialCostFunction           = feval(Delegate, reshape(X_trial, X_size));
        TrialCostFunction           = TrialCostFunction(:);
        FunctionEvaluationCount   	= FunctionEvaluationCount + 1;
        TrialSumOfSquares           = TrialCostFunction' * TrialCostFunction;

        IsCurrentTrialWellDefined   = isfinite(TrialSumOfSquares) && isreal(TrialSumOfSquares);

        % check trial result (accept / decline)
        
        if IsCurrentTrialWellDefined && TrialSumOfSquares < SumOfSquares   

            CostFunction            = TrialCostFunction;
            X                       = X_trial; 

            if SuccessfulStep
                lambda              = 0.1 * lambda;      
            end
            
            [Jacobian, ~, ~, NumberOfEvaluations, IsJacobianDefined] = finitedifferences(X, Delegate,[], [], [], CostFunction, [],[], 1 : VariableCount, Options, sizes, Jacobian, [], [], FiniteDifferenceFlags, []);
            FunctionEvaluationCount	= FunctionEvaluationCount + NumberOfEvaluations;
            SuccessfulStep          = true;
            F_gradient            	= Jacobian' * CostFunction;     

            Done                    = TestConvergence;

            SumOfSquares            = TrialSumOfSquares;

        else     

            lambda                  = 10 * lambda;
            SuccessfulStep          = false;

            if norm(step) < tolX *(sqrt(eps) + norm(X_trial))

                warning('Step size is below tolerance.')
                Success             = false;
                Done                = true;

            elseif FunctionEvaluationCount > MaxFunctionEvaluations

                warning('Number of function evaluations exceeded maximum function evaluations.')
                Success             = false;
                Done                = true;

            end   

        end

    end

    X                       = reshape(X, X_size);

    MetaData.CostFunction   = CostFunction;
    MetaData.IterationCount = IterationCount;
    MetaData.Success        = Success;
    
    function Done = TestConvergence

        if ~IsJacobianDefined

            warning('Jacobian is undefined.')
            Success = false;
            Done = true;

        elseif norm(F_gradient, Inf) < tolOpt * relFactor

            Success = true;
            Done = true;

        elseif IterationCount > 0

            if norm(step) < tolX * (sqrt(eps) + norm(X))

                warning('Step size is below tolerance.')
                Success = false;
                Done = true;

            elseif abs(TrialSumOfSquares - SumOfSquares) <= tolFun * SumOfSquares

                warning('Sum of squares changes are below tolerance.')
                Success = false;
                Done = true;

            elseif FunctionEvaluationCount > MaxFunctionEvaluations

                warning('Number of function evaluations exceeded maximum function evaluations.')
                Success = false;
                Done = true;

            elseif IterationCount > MaxIterations

                warning('Iteration count exceeded maximum iteration count.')
                Success = false;
                Done = true;

            else

                IterationCount = IterationCount + 1;
                Done = false;

            end

        else

            IterationCount = IterationCount + 1;
            Done = false;

        end

    end
    
end