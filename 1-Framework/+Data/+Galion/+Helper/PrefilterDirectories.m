function [Directories] = PrefilterDirectories(DateBegin, DateEnd, DateFormat, DirectoryPath)

    TopLevelFolders     = Directory.GetTopLevelFolders(DirectoryPath);
    TopLevelFolderCount = size(TopLevelFolders, 1);
    
    for TopLevelFolderNumber = 1 : TopLevelFolderCount
            
        FolderNameLength = length(TopLevelFolders{TopLevelFolderNumber});
        DateFormatLength = length(DateFormat);
        
        Date = DateTime.ParseExact(TopLevelFolders{TopLevelFolderNumber}, FolderNameLength - DateFormatLength + 1, DateFormat);
        
        if Date < DateBegin || Date > DateEnd
        
            TopLevelFolders{TopLevelFolderNumber} = [];
            
        end
            
    end
    
    Directories = TopLevelFolders(~cellfun('isempty', TopLevelFolders));

end

