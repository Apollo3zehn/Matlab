function result = Bar3d(AH, x, binCentersX, y, binCentersY, scaleFactor, normalizeData)

    binEdgesX               = Statistics.CalculateBinEdges(binCentersX, false);
    result              	= zeros(numel(binCentersY), numel(binCentersX));

    for Index = 1 : numel(binEdgesX) - 1

        Indices                     = binEdgesX(Index) <= x & x <= binEdgesX(Index + 1);    
        [~, NumberOfValues]         = Statistics.SortDataIntoBins(y(Indices), binCentersY, false, false);

        if normalizeData
            result(:, Index)            = NumberOfValues ./ sum(NumberOfValues);
        else
            result(:, Index)            = NumberOfValues;
        end

    end

    result                  = result .* scaleFactor;
    
    if nargout > 0
        return
    end
    
    SH = bar3(AH, result);

    for Index = 1 : numel(SH)
        zdata               = SH(Index).ZData;
        SH(Index).CData     = zdata;
        SH(Index).FaceColor = 'interp';
        %SH(Index).FaceAlpha	= 0.6;
    end
  
    Plot.Helper.RemoveEmptyBars(SH)
    
    set(AH, 'XTick', 1 : numel(binCentersX))
    set(AH, 'XTickLabel', binCentersX)
    set(AH, 'YTick', 1 : numel(binCentersY))
    set(AH, 'YTickLabel', binCentersY)
   
end

