function NewImage = RgbToGray(Image)

    Size                    = size(Image);

    TransformationMatrix    = inv([1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703]);
    Coefficients            = TransformationMatrix(1,:);

    Image                 	= reshape(Image(:), [], 3);
    NewImage             	= Image * Coefficients';
    NewImage             	= min(max(NewImage, 0), 1);
    NewImage            	= reshape(NewImage, Size(1 : 2));

end
