assemblyInfo            = NET.addAssembly([pwd '\1-Framework\External\HDF.PInvoke.1.10.0.3\HDF.PInvoke.dll']);
import HDF.*
import HDF.PInvoke.*
import System.Runtime.InteropServices.*

clc
clear
close all

%%

directoryPath               = 'F:\DATA';
mode                        = 3; % 1 = linear, 2 = polar, 3 = bitwise;

if mode == 1
    
    groupPath               = '/LEHE/LEHE03/GENERAL_DAQ/e5d628c9-3592-4245-92a5-deb3e678b788';
    
elseif mode == 2
    
    groupPath               = '/LEHE/LEHE03/GENERAL_DAQ/cc38c34b-cd82-4b2f-ae8a-2343f3e46636';
    polarLimit              = 3600;
    factor                  = 2 * pi / polarLimit;
    
else
    
    groupPath               = '/LEHE/LEHE03/GENERAL_DAQ/a0a94d44-d53e-4a92-94ac-7167cba8a30c';
    
end

%% RAW
rawFilePath             = [directoryPath '\RAW\2017-03\LEHE_LEHE03_GENERAL_DAQ_2017-03-01T00-00-00Z.h5'];
rawFileId               = PInvoke.H5F.open(rawFilePath, H5F.ACC_RDONLY, H5P.DEFAULT);

if (rawFileId == -1)
    error('rawFileId = -1')
end

rawData                 = Data.HDF.LoadDataset(rawFileId, [groupPath '/' '100 Hz'], 'System.Int16', 2);
statusData              = Data.HDF.LoadDataset(rawFileId, [groupPath '/' '100 Hz_status'], 'System.Byte', 1);

%% AGGREGATION
aggregationFilePath     = [directoryPath '\AGGREGATION\2017-03\LEHE_LEHE03_GENERAL_DAQ_2017-03-01T00-00-00Z.h5'];
aggregationFileId       = PInvoke.H5F.open(aggregationFilePath, H5F.ACC_RDONLY, H5P.DEFAULT);

if (aggregationFileId == -1)
    error('rawFileId = -1')
end

if mode == 1
    aggregateData_1_s_mean  = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '1 s_mean'], 'System.Double', 8);
    aggregateData_1_s_min   = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '1 s_min'], 'System.Double', 8);
    aggregateData_1_s_max   = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '1 s_max'], 'System.Double', 8);
    aggregateData_1_s_std   = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '1 s_std'], 'System.Double', 8);
    aggregateData_60_s_mean	= Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '60 s_mean'], 'System.Double', 8);
    aggregateData_60_s_min 	= Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '60 s_min'], 'System.Double', 8);
    aggregateData_60_s_max 	= Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '60 s_max'], 'System.Double', 8);
    aggregateData_60_s_std  = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '60 s_std'], 'System.Double', 8);
    aggregateData_600_s_mean= Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '600 s_mean'], 'System.Double', 8);
    aggregateData_600_s_min = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '600 s_min'], 'System.Double', 8);
    aggregateData_600_s_max = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '600 s_max'], 'System.Double', 8);
    aggregateData_600_s_std = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '600 s_std'], 'System.Double', 8);
elseif mode == 2
    aggregateData_1_s_mean_polar = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '1 s_mean_polar'], 'System.Double', 8);
    aggregateData_60_s_mean_polar = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '60 s_mean_polar'], 'System.Double', 8);
    aggregateData_600_s_mean_polar = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '600 s_mean_polar'], 'System.Double', 8);
else
    aggregateData_1_s_min_bitwise = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '1 s_min_bitwise'], 'System.Double', 8);
    aggregateData_60_s_min_bitwise = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '60 s_min_bitwise'], 'System.Double', 8);
    aggregateData_600_s_min_bitwise = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '600 s_min_bitwise'], 'System.Double', 8);
    aggregateData_1_s_max_bitwise = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '1 s_max_bitwise'], 'System.Double', 8);
    aggregateData_60_s_max_bitwise = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '60 s_max_bitwise'], 'System.Double', 8);
    aggregateData_600_s_max_bitwise = Data.HDF.LoadDataset(aggregationFileId, [groupPath '/' '600 s_max_bitwise'], 'System.Double', 8);
end

%% MATLAB

if mode == 1
   % mean
    rawDataBins             = 51 : 100 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_mean_1_s        = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) mean(x));

    rawDataBins             = 3001 : 6000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_mean_60_s       = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) mean(x));

    rawDataBins             = 30001 : 60000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_mean_600_s      = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) mean(x));

    % min
    rawDataBins             = 51 : 100 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_min_1_s         = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) min(x));

    rawDataBins             = 3001 : 6000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_min_60_s        = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) min(x));

    rawDataBins             = 30001 : 60000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_min_600_s       = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) min(x));

    % max
    rawDataBins             = 51 : 100 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_max_1_s         = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) max(x));

    rawDataBins             = 3001 : 6000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_max_60_s        = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) max(x));

    rawDataBins             = 30001 : 60000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_max_600_s       = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) max(x));

    % std
    rawDataBins             = 51 : 100 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_std_1_s         = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) std(x));

    rawDataBins             = 3001 : 6000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_std_60_s        = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) std(x));

    rawDataBins             = 30001 : 60000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_std_600_s       = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) std(x));
    
elseif mode == 2
    
    % mean_polar
    rawDataBins             = 51 : 100 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_mean_polar_1_s  = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) mod(atan2(sum(sin(x * factor)), sum(cos(x * factor))) / factor, 3600));

    rawDataBins             = 3001 : 6000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_mean_polar_60_s = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) mod(atan2(sum(sin(x * factor)), sum(cos(x * factor))) / factor, 3600));

    rawDataBins             = 30001 : 60000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_mean_polar_600_s= Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) mod(atan2(sum(sin(x * factor)), sum(cos(x * factor))) / factor, 3600));
    
else
    
    % min_bitwise
    rawDataBins             = 51 : 100 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_min_bitwise_1_s  = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) Logical.BitwiseMin(x));

    rawDataBins             = 3001 : 6000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_min_bitwise_60_s = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) Logical.BitwiseMin(x));

    rawDataBins             = 30001 : 60000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_min_bitwise_600_s= Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) Logical.BitwiseMin(x));
    
    % max_bitwise
    rawDataBins             = 51 : 100 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_max_bitwise_1_s  = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) Logical.BitwiseMax(x));

    rawDataBins             = 3001 : 6000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_max_bitwise_60_s = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) Logical.BitwiseMax(x));

    rawDataBins             = 30001 : 60000 : numel(rawData);
    [BinIndices, ~]         = Statistics.SortDataIntoBins(1 : numel(rawData), rawDataBins, false, false);
    rawData_max_bitwise_600_s = Statistics.ProcessBinSortedData(rawData, BinIndices, numel(rawDataBins), @(x) Logical.BitwiseMax(x));
    
end

%%

if mode == 1
    % mean
    figure

    subplot(4, 1, 1)
    plot(rawData)
    title('mean')
    
    subplot(4, 1, 2)
    plot(aggregateData_1_s_mean)
    hold on
    plot(rawData_mean_1_s, ':')
    hold off

    subplot(4, 1, 3)
    plot(aggregateData_60_s_mean)
    hold on
    plot(rawData_mean_60_s, ':')
    hold off

    subplot(4, 1, 4)
    plot(aggregateData_600_s_mean)
    hold on
    plot(rawData_mean_600_s, ':')
    hold off

    % min
    figure

    subplot(4, 1, 1)
    plot(rawData)
    title('min')
    
    subplot(4, 1, 2)
    plot(aggregateData_1_s_min)
    hold on
    plot(rawData_min_1_s, ':')
    hold off

    subplot(4, 1, 3)
    plot(aggregateData_60_s_min)
    hold on
    plot(rawData_min_60_s, ':')
    hold off

    subplot(4, 1, 4)
    plot(aggregateData_600_s_min)
    hold on
    plot(rawData_min_600_s, ':')
    hold off

    % max
    figure

    subplot(4, 1, 1)
    plot(rawData)
    title('max')
    
    subplot(4, 1, 2)
    plot(aggregateData_1_s_max)
    hold on
    plot(rawData_max_1_s, ':')
    hold off

    subplot(4, 1, 3)
    plot(aggregateData_60_s_max)
    hold on
    plot(rawData_max_60_s, ':')
    hold off

    subplot(4, 1, 4)
    plot(aggregateData_600_s_max)
    hold on
    plot(rawData_max_600_s, ':')
    hold off

    % std
    figure
    
    subplot(4, 1, 1)
    plot(rawData)
    title('std')
    
    subplot(4, 1, 2)
    plot(aggregateData_1_s_std)
    hold on
    plot(rawData_std_1_s, ':')
    hold off

    subplot(4, 1, 3)
    plot(aggregateData_60_s_std)
    hold on
    plot(rawData_std_60_s, ':')
    hold off

    subplot(4, 1, 4)
    plot(aggregateData_600_s_std)
    hold on
    plot(rawData_std_600_s, ':')
    hold off
elseif mode == 2
    
    % mean_polar
    figure

    subplot(4, 1, 1)
    plot(rawData)
    title('mean\_polar')
    
    subplot(4, 1, 2)
    plot(aggregateData_1_s_mean_polar)
    hold on
    plot(rawData_mean_polar_1_s, ':')
    hold off

    subplot(4, 1, 3)
    plot(aggregateData_60_s_mean_polar)
    hold on
    plot(rawData_mean_polar_60_s, ':')
    hold off

    subplot(4, 1, 4)
    plot(aggregateData_600_s_mean_polar)
    hold on
    plot(rawData_mean_polar_600_s, ':')
    hold off
    
else
    
    % min_bitwise
    figure

    subplot(4, 1, 1)
    plot(rawData)
    title('mean\_bitmin')
    
    subplot(4, 1, 2)
    plot(aggregateData_1_s_min_bitwise)
    hold on
    plot(rawData_min_bitwise_1_s, ':')
    hold off

    subplot(4, 1, 3)
    plot(aggregateData_60_s_min_bitwise)
    hold on
    plot(rawData_min_bitwise_60_s, ':')
    hold off

    subplot(4, 1, 4)
    plot(aggregateData_600_s_min_bitwise)
    hold on
    plot(rawData_min_bitwise_600_s, ':')
    hold off
    
    % max_bitwise
    figure

    subplot(4, 1, 1)
    plot(rawData)
    title('mean\_bitmax')
    
    subplot(4, 1, 2)
    plot(aggregateData_1_s_max_bitwise)
    hold on
    plot(rawData_max_bitwise_1_s, ':')
    hold off

    subplot(4, 1, 3)
    plot(aggregateData_60_s_max_bitwise)
    hold on
    plot(rawData_max_bitwise_60_s, ':')
    hold off

    subplot(4, 1, 4)
    plot(aggregateData_600_s_max_bitwise)
    hold on
    plot(rawData_max_bitwise_600_s, ':')
    hold off
    
end
