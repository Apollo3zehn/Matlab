function [Edges, Magnitude, Gradient_x, Gradient_y] = Sobel(Data, Threshold)

if ~isa(Data, 'double')
    Data = double(Data);
end
                          
Kernel_x    = [-1  0  1;
               -2  0  2;
               -1  0  1];
           
Kernel_y    = [ 1  2  1;
                0  0  0;
               -1 -2 -1];
           
% Kernel_x    = [ 2   1   0   -1  -2;
%                 3   2   0   -2  -3;
%                 4   3   0   -3  -4;
%                 3   2   0   -2  -3;
%                 2   1   0   -1  -2;
%                ];

% Kernel_x        = [ 3   2   1   0   -1  -2  -3;
%                     4   3   2   0   -2  -3  -4;
%                     5   4   3   0   -3  -4  -5;
%                     6   5   4   0   -4  -5  -6;
%                     5   4   3   0   -3  -4  -5;
%                     4   3   2   0   -2  -3  -4;
%                     3   2   1   0   -1  -2  -3];

% Expand data for convolution
Data        = [Data(:, 1) Data Data(:, end)];
Data        = [Data(1, :); Data; Data(end, :)];

% Using this, no resize of the data is required
% Gradient_x1  = imfilter(Data, Kernel_x, 'replicate');
% Gradient_y1  = imfilter(Data, Kernel_y, 'replicate');

Gradient_x  = conv2(Data, Kernel_x, 'same');
Gradient_y  = conv2(Data, Kernel_y, 'same');

Gradient_x  = Gradient_x(2 : end - 1, 2 : end - 1);
Gradient_y  = Gradient_y(2 : end - 1, 2 : end - 1);

Magnitude   = Gradient_x.^2 + Gradient_y.^2;          

Edges     	= Magnitude > Threshold;


