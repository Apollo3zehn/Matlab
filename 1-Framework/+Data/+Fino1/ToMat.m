clc
clear
close all

try

    FileName            = 'M:\Data Analysis\Testumgebung_VWI\1-Data\FINO1\FINO1_Windrichtung_90m_20130101_20140301.dat';
    
    NumberOfHeadlines   = 6;

    FileID              = fopen(FileName, 'r');
    FormatSpec          = '%4f-%2f-%2f %2f:%2f:%2f %f %f %f %f %f';
    
    Fino1Data         	= textscan(FileID, FormatSpec, 'HeaderLines', NumberOfHeadlines, 'ReturnOnError', true);
    Fino1Data          	= [datenum(Fino1Data{:, 1}, Fino1Data{:, 2}, Fino1Data{:, 3}, Fino1Data{:, 4}, Fino1Data{:, 5}, Fino1Data{:, 6}) ...
                                    Fino1Data{:, 7 : end}];
               
    fclose(FileID);

    DateTimeBegin       = Fino1Data(1, 1);
    DateTimeEnd         = Fino1Data(end, 1);   
    FileInfo.OutputPath = FileInformation.BuildOutputFilePathByDateTime(Environment.PreparedPath, ...
                                                                        'Fino1', ...
                                                                        'Rave', ...
                                                                        DateTimeBegin, DateTimeEnd);
    
    [DirectoryPath, ~, ~] = fileparts(FileInfo.OutputPath);

    if ~isdir(DirectoryPath)
        mkdir(DirectoryPath)
    end

    save([FileInfo.OutputPath '.mat'], 'Fino1Data', '-mat');
    Display.Text(['Saved file ''' FileInfo.OutputPath '.mat''.'])

catch ex

    fclose('all');
    delete(FileInfo.OutputPath)
    warning(ex.message)

end