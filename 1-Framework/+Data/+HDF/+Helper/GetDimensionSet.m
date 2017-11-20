function [rank, dimensionSet, maxDimensionSet] = GetDimensionSet(datasetId)

    NET.addAssembly([pwd '\1-Framework\External\HDF.PInvoke.1.10.0.3\HDF.PInvoke.dll']);
    import HDF.*
    import HDF.PInvoke.*
    import System.Runtime.InteropServices.*

    dataspaceId             = PInvoke.H5D.get_space(datasetId);
    
    rank                    = PInvoke.H5S.get_simple_extent_ndims(dataspaceId);
    dimensionSet            = NET.createArray('System.UInt64', 1);
    maxDimensionSet         = NET.createArray('System.UInt64', 1);

    PInvoke.H5S.get_simple_extent_dims(dataspaceId, dimensionSet, maxDimensionSet);   
    
    rank                    = double(rank);
    dimensionSet         	= double(dimensionSet);
    maxDimensionSet       	= double(maxDimensionSet);
    
    % clean up
    PInvoke.H5S.close(dataspaceId);
    
end

