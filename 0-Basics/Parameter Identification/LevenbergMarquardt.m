function [x, IterationCount, Success] = LevenbergMarquardt(Delegate, PartialDerivationWidth, x, Bounds, lambda, MaxIterationCount)

    % Example: [X, IterationCount, Success] = LevenbergMarquardt(Delegate, 0.001, [-4; 0; 0], [0.999 1.001], 0.1, 100);
    % https://www.igpm.rwth-aachen.de/Numa/NumaMB/SS12/grUebung12.pdf

    x               = x(:);
    beta_0          = 0.2;
    beta_1          = 0.8;
    IterationCount 	= 0;
    Success         = true;

    while true
        
        [x_New, rho_lambda] = Iteration(Delegate, PartialDerivationWidth, x, lambda);
%         fprintf('%2d %f %f x: %f %f %f\n', k, rho_lambda, lambda, x_New(1), x_New(2), x_New(3)) 
        
        while true

            if rho_lambda < beta_0

                lambda                 = 10 * lambda;
                [x_New, rho_lambda]    = Iteration(Delegate, PartialDerivationWidth, x, lambda);
                %fprintf('%2d %f %f x: %f %f %f\n', k, rho_lambda, lambda, x_New(1), x_New(3)) 

            elseif beta_0 < rho_lambda && rho_lambda < beta_1
                       
                x                      = x_New;
                break
                
            elseif beta_1 < rho_lambda
                
                lambda                 = 1/10 * lambda;
                x                      = x_New;
                break
                
            else
                
                if isnan(rho_lambda)
                    Success = false;
                end
                
                break
                
            end

        end
                
        if (Bounds(1) < rho_lambda && rho_lambda < Bounds(2))
            break
        end
               
        IterationCount = IterationCount + 1;
        
        if IterationCount == MaxIterationCount
            Success = false;
            break
        end
                
    end
        
    function [x_New, rho_lambda] = Iteration(Delegate, PartialDerivationWidth, x, lambda)

        y           = Delegate(x);
        J           = Analysis.Jacobian(Delegate, PartialDerivationWidth, x, y);
        s           = [J; lambda * eye(size(J, 2))] \ -[y; zeros(size(J, 2), 1)];
        x_New       = x + s;
        rho_lambda  = (norm(y)^2 - norm(Delegate(x_New))^2) / (norm(y)^2 - norm(y + J * s)^2);
        
    end
    
end