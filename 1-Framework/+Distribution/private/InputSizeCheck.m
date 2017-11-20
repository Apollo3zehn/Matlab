function varargout = InputSizeCheck(varargin)

    nargoutchk(nargin, nargin)
    varargout   = cell(1, nargin);
    InputSize	= size(varargin{1});

    varargout(1) = varargin(1);
    
    for i = 2 : nargin
        
        Input = varargin{i};
                
        if all(size(Input) == InputSize)
            
            varargout{i} = Input;
            
        else
           
            if isscalar(Input)
                varargout{i} = ones(InputSize) * Input;
            else
                error('All inputs must be scalars or have the same dimension as the first input.')
            end
            
        end
                
    end

end