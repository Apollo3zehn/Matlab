function [] = ToMat(FileInfo)

    load(FileInfo.Path)

    data = orderfields(data);
    
    Directory.CreateByFilePath(FileInfo.OutputPath)

    save(FileInfo.OutputPath, '-struct', 'data', '-v7.3');
    Display.NewLine
    display(['Saved file ''' FileInfo.OutputPath '''.'])

end