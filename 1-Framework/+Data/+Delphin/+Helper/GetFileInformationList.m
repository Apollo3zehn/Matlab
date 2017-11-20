function FileInformationList = GetFileInformationList(DirectoryPath, DateTimeBegin, DateTimeEnd, DateFormat, FileType)

    FileInformationList             = FileInformation.GetFileInformations(DirectoryPath, FileType, true);    
    [FileInformationList.DateTime]  = deal(0);

    Indices                         = cellfun('length', {FileInformationList.Name}') == 24;
    DateTime                        = num2cell(DateTime.ParseExact(cell2mat({FileInformationList(Indices).Name}'), 9, DateFormat));
    FileInformationList             = FileInformationList(Indices);
    [FileInformationList.DateTime]  = DateTime{:};

    FileInformationList             = FileInformation.FilterListByDateTime(FileInformationList, DateTimeBegin, DateTimeEnd, 0);

end

