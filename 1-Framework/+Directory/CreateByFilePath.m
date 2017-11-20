function [] = CreateByFilePath(FilePath)

    [DirectoryPath, ~, ~] = fileparts(FilePath); 

    if ~isempty(DirectoryPath)

        if ~exist(DirectoryPath, 'dir')
            mkdir(DirectoryPath)
        end                 

    end
    
end