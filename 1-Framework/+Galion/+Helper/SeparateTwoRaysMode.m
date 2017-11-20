function [DataInfo1, DataInfo2] = SeparateTwoRaysMode(GalionExtension, NorthRelatedAngle1, NorthRelatedAngle2)

    DataInfo1       = Galion.Extension(GalionExtension.Data);
    DataInfo2       = Galion.Extension(GalionExtension.Data);

    DataInfo1.Data  = DataInfo1.Data(DataInfo1.Data(:, 5) == NorthRelatedAngle1, :);
    DataInfo2.Data  = DataInfo2.Data(DataInfo2.Data(:, 5) == NorthRelatedAngle2, :);

end

