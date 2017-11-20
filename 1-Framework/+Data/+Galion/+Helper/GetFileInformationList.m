function [FileInformationList] = GetFileInformationList(DirectoryPath, DateTimeBegin, DateTimeEnd, DirectoryDateFormat, FileDateFormat, FileType)

    DateBegin           = DateTime.ToDate(DateTimeBegin);
    DateEnd             = DateTime.ToDate(DateTimeEnd);

    TopLevelDirectories = Data.Galion.Helper.PrefilterDirectories(DateBegin, DateEnd, DirectoryDateFormat, DirectoryPath);
    
    FileInformationList = FileInformation.empty();

    CurrentFileNumber   = 1;

    for TopLevelDirectoryNumber = 1 : length(TopLevelDirectories)

        FileInformations    = FileInformation.GetFileInformations(TopLevelDirectories{TopLevelDirectoryNumber}, FileType, true);  
        FileInfoCount       = length(FileInformations);
        if FileInfoCount > 0
            FileInformationList(CurrentFileNumber : CurrentFileNumber + FileInfoCount - 1, 1) = FileInformations;
        end
        CurrentFileNumber   = CurrentFileNumber + FileInfoCount;

    end 

    FileInformationList     = FileInformationList(1 : CurrentFileNumber - 1, 1);

    for FileInfoNumber  = 1 : numel(FileInformationList)

        if length(FileInformationList(FileInfoNumber).Name) == 18
            FileInformationList(FileInfoNumber).DateTime = datenum(FileInformationList(FileInfoNumber).Name(8 : 15), FileDateFormat);
        elseif length(FileInformationList(FileInfoNumber).Name) == 19
            FileInformationList(FileInfoNumber).DateTime = datenum(FileInformationList(FileInfoNumber).Name(9 : 16), FileDateFormat);
        end

    end

    FileInformationList   	= FileInformation.FilterListByDateTime(FileInformationList, DateTimeBegin, DateTimeEnd, 1);
    
end

