function NewFilePath = ReplaceExtension(SourceFilePath, NewExtension)
    [FilePath, FileName, ~] = fileparts(SourceFilePath);
    NewFilePath = [FilePath '\' FileName '.' NewExtension];
end