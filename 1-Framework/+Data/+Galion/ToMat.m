function [] = ToMat(FileInfo)

    if length(FileInfo.Name) == 18
        DateTimeBegin   = DateTime.ParseExact(FileInfo.Name, 8, 'ddmmyyhh');
    elseif length(FileInfo.Name) == 19
        DateTimeBegin   = DateTime.ParseExact(FileInfo.Name, 9, 'ddmmyyhh');
    end

    DateTimeBegin   = DateTime.ToDateTime(DateTimeBegin, 1, 1, 1, 0, 0, 0);

    FileInfo.OutputPath = [Galion.PreparedScanModePath '\' ...
                            DateTime.ToString(DateTimeBegin, 'yyyy-mm-dd') ... 
                            '\' FileInfo.Name];

    File            = fopen(FileInfo.Path);
    Data            = textscan(File,'%f %f %f %f:%f:%f %f %f %f %f', 'headerLines', 6, 'delimiter', '\t');

    fclose(File);

    Data{:, 4}      = DateTimeBegin + datenum(0, 0, 0, Data{4}, Data{5}, Data{6});
    Data{:, 2}      = -Data{:, 2};

    GalionData      = [Data{:, [1 2 3 4 7 8 9 10]}];     

    %% save data

    try

        [DirectoryPath, ~, ~] = fileparts(FileInfo.OutputPath);

        if ~isdir(DirectoryPath)
            mkdir(DirectoryPath)
        end

        save([FileInfo.OutputPath '.mat'], 'GalionData', '-mat');
        Display.Text(['Saved file ''' FileInfo.OutputPath '.mat''.'])

    catch ex

        fclose('all');
        delete(FileInfo.OutputPath)
        warning(ex.message)

    end

end