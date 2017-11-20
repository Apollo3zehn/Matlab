function [start, stride, block, count] = GetHyperslab(epochStart, epochEnd, dateTimeBegin, dateTimeEnd, sampleRate)

    if isempty(epochStart.TimeZone) || isempty(epochEnd.TimeZone) || isempty(dateTimeBegin.TimeZone) || isempty(dateTimeEnd.TimeZone)
        error('all datetime inputs must be associated to a timezone (e.g. UTC or UTC+1)')
    end

    epochStart.TimeZone     = 'UTC';
    epochEnd.TimeZone       = 'UTC';
    dateTimeBegin.TimeZone  = 'UTC';
    dateTimeEnd.TimeZone    = 'UTC';
    
    if ~(epochStart <= dateTimeBegin && dateTimeBegin <= dateTimeEnd && dateTimeEnd <= epochEnd)
        error('requirement >> epochStart <= dateTimeBegin && dateTimeBegin <= dateTimeEnd && dateTimeBegin <= epochEnd << is not matched')
    end

    start   = uint64(datenum((dateTimeBegin - epochStart)) * 86400 * sampleRate);
    stride  = 1;
    block   = uint64(datenum((dateTimeEnd - dateTimeBegin)) * 86400 * sampleRate);
    count   = 1;

end

