clc
clear
close all

OriginalImage           = imread('Sobel.png');
Image                   = ImageProcessing.RgbToGray(double(OriginalImage) / 255);
Threshold               = 0.01;

[Edges, Magnitude, Gradient_x, Gradient_y] = ImageProcessing.Sobel(Image, Threshold);

Direction               = atan(Gradient_y ./ Gradient_x);
subplot(1, 3, 1)
image(OriginalImage);
title('Original image')

subplot(1, 3, 2)
image(Magnitude / max(Magnitude(:)) * 2550); colormap gray
title('Magnitude of gradient')

subplot(1, 3, 3)
image(Edges * 255); colormap gray
title('Edges')

fprintf('Direction: %.4f deg\n', NaN.Mean(Direction(Edges)) * 180 / pi);