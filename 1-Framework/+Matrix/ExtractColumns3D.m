function Data = ExtractColumns3D(Data, yIndices, zIndices)

    Data = Data(:, yIndices + size(Data, 2) .* (zIndices - 1));

end

