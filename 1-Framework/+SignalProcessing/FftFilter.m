% Copy of fftfilt, easy to rewrite

function y = FftFilter(b, x, FftLength)

    %% Description missing

    narginchk(2,3);

    m = size(x, 1);
    if m == 1
        x = x(:);    % turn row into a column
    end

    nx = size(x,1);

    if min(size(b))>1
       if (size(b,2)~=size(x,2))&&(size(x,2)>1)
          error(message('signal:fftfilt:InvalidDimensions'))
       end
    else
       b = b(:);   % make input a column
    end
    nb = size(b,1);

    if nargin < 3
    % figure out which nfft and L to use
        if nb >= nx || nb > 2^20    % take a single FFT in this case
            nfft = 2^nextpow2(nb+nx-1);
            L = nx;
        else
            fftflops = [ 18 59 138 303 660 1441 3150 6875 14952 32373 69762 ...
           149647 319644 680105 1441974 3047619 6422736 13500637 28311786 59244791];
            n = 2.^(1:20); 
            validset = find(n>(nb-1));   % must have nfft > (nb-1)
            n = n(validset); 
            fftflops = fftflops(validset);
            % minimize (number of blocks) * (number of flops per fft)
            L = n - (nb - 1);
            [dum,ind] = min( ceil(nx./L) .* fftflops ); %#ok
            nfft = n(ind);
            L = L(ind);
        end

    else  % nfft is given
      % Cast to enforce precision rules
        nfft = signal.internal.sigcasttofloat(nfft,'double','fftfilt','N','allownumeric');
        if nfft < nb
            nfft = nb;
        end
        nfft = 2.^(ceil(log(nfft)/log(2))); % force this to a power of 2 for speed
        L = nfft - nb + 1;
    end
    
    B = fft(b,nfft);
    if length(b)==1,
         B = B(:);  % make sure fft of B is a column (might be a row if b is scalar)
    end
    if size(b,2)==1
        B = B(:,ones(1,size(x,2)));  % replicate the column B 
    end
    if size(x,2)==1
        x = x(:,ones(1,size(b,2)));  % replicate the column x 
    end
    y = zeros(size(x));

    istart = 1;
    while istart <= nx
        iend = min(istart+L-1,nx);
        if (iend - istart) == 0
            X = x(istart(ones(nfft,1)),:);  % need to fft a scalar
        else
            X = fft(x(istart:iend,:),nfft);
        end
        Y = ifft(X.*B);
        yend = min(nx,istart+nfft-1);
        y(istart:yend,:) = y(istart:yend,:) + Y(1:(yend-istart+1),:);
        istart = istart + L;
    end

    if ~(any(imag(b(:))) || any(imag(x(:))))
        y = real(y);
    end

    if (m == 1)&&(size(y,2) == 1)
        y = y(:).';    % turn column back into a row
    end

end