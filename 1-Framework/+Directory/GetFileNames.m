function FileNames = GetFileNames(DirectoryPath, FileType, WithSubDirectories)

    % Fast method to find all files that matches the given file ending. Works only in Windows.
    %
    % - Syntax -
    %
    % FileNames = GetFileNames(DirectoryPath, FileType, WithSubDirectories)
    %
    % - Inputs -
    %
    % DirectoryPath         - String that contains the directory path
    % FileType              - String that contains the file ending. Asterix is possible.
    % WithSubDirectories    - Boolean that specifies if subdirectories should be included.
    %
    % - Outputs -
    %
    % FileNames             - System.String[] that contains the found file names
    %
    % - Test -
    %
    % FileNames     = GetFileNames('D:\Test', 'mat', true);
    % FileNames     = cell(FileNames).';
    
    %% Verify input data

    if ~isempty(DirectoryPath) && (~ischar(DirectoryPath) || ~isvector(DirectoryPath))
        error('DirectoryPath must a string.')
    end
    
    if ~isempty(FileType) && (~ischar(FileType) || ~isvector(FileType))
        error('FileType must a string.')
    end
    
    %% Calculation
    
    NET.addAssembly('mscorlib.dll');
    
    if WithSubDirectories
        FileNames = System.IO.Directory.GetFiles(DirectoryPath, ['*.' FileType], System.IO.SearchOption.AllDirectories);
    else
        FileNames = System.IO.Directory.GetFiles(DirectoryPath, ['*.' FileType]);
    end
               
    FileNames = cell(FileNames).';
    
end


