function RemoveEmptyBars(SH)

    for Index = 1 : numel(SH)
        
        ZData               = get(SH(Index), 'ZData');
        Indices             = logical(kron(ZData(2:6:end,2) == 0, ones(6,1)));
        ZData(Indices, :)   = NaN;
        set(SH(Index), 'ZData', ZData);
        
    end
    
end