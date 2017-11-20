function sampleRate = GetSampleRate(datasetName)

    datasetNamePartSet = strsplit(datasetName, '_');

    switch datasetNamePartSet{1}
        case '100 Hz'
            sampleRate = 100;
        case '25 Hz'
            sampleRate = 25;
        case '5 Hz'
            sampleRate = 5;
        case '1 Hz'
            sampleRate = 1;
        case '1 s'
            sampleRate = 1 / 1;
        case '60 s'
            sampleRate = 1 / 60;
        case '600 s'
            sampleRate = 1 / 600;
        otherwise
            error('invalid argument')
    end
    
end

