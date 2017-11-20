% OutputPath should be the full output path without file extension.

classdef FileInformation
    
properties 
    Name            = []  
    Extension       = []  
    DirectoryPath   = [] 
    Path            = [] 
    OutputPath      = []
    Data            = []
    DateTime        = []
end 

methods(Static)

    function FilteredFileInfoList = FilterListByDateTime(FileInformationList, DateTimeBegin, DateTimeEnd, ConvertToDate)

        if ConvertToDate
            DateTimeBegin       = DateTime.ToDateTime(DateTimeBegin, 1, 1, 1, 1, 0, 0);
            DateTimeEnd         = DateTime.ToDateTime(DateTimeEnd, 1, 1, 1, 1, 0, 0);
        end

        DateTimeSet             = [FileInformationList.DateTime].';
        FilteredFileInfoList    = FileInformationList(DateTimeBegin <= DateTimeSet & DateTimeSet <= DateTimeEnd);
       
    end 
    
    function [Path] = BuildOutputFilePathByDateTime(BasePath, TechnologyName, CalculationName, DateTimeBegin, DateTimeEnd)
        
        FolderName = [];
        
        if DateTimeEnd - DateTimeBegin < 1
            FolderName = DateTime.ToString(DateTimeBegin, 'yyyy-mm-dd');
        end
        
        Path = [BasePath '\' TechnologyName '\' CalculationName '\' ...
                FolderName ... 
                '\' ...
                DateTime.ToString(DateTimeBegin, 'yyyy-mm-ddThh-MM-ss') ...
                ' - ' ...
                DateTime.ToString(DateTimeEnd, 'yyyy-mm-ddThh-MM-ss')];
    end
    
    function [FileInformations] = GetFileInformations(DirectoryPath, FileType, WithSubDirectories)
        
        FileNames           = Directory.GetFileNames(DirectoryPath, FileType, WithSubDirectories);
        FileCount           = numel(FileNames);
        FileInformations    = FileInformation.empty(FileCount, 0);
        
        for FileNumber = 1 : FileCount

            [~, FileName, FileExtension] = fileparts(FileNames{FileNumber});

            FileInformations(FileNumber, 1)                = FileInformation;
            FileInformations(FileNumber, 1).DirectoryPath	= DirectoryPath;
            FileInformations(FileNumber, 1).Name        	= FileName;
            FileInformations(FileNumber, 1).Extension   	= FileExtension;
            FileInformations(FileNumber, 1).Path        	= FileNames{FileNumber};
            FileInformations(FileNumber, 1).OutputPath   	= [];
            FileInformations(FileNumber, 1).Data         	= [];

        end
        
    end
    
end
    
end 