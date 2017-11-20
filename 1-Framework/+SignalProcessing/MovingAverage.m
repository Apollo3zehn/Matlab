function [AveragedData] = MovingAverage(Data, KernelSize)

    AveragedData = filter(ones(1, KernelSize) / KernelSize, 1, Data);

end

