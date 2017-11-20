function [TopLevelFolders] = GetTopLevelFolders(DirectoryPath)

    % Get the first level subdirectories of DirectoryPath
    %
    % - Syntax -
    %
    % [TopLevelFolders] = GetTopLevelFolders(DirectoryPath)
    %
    % - Inputs -
    %
    % DirectoryPath     - Char array that contains the path of the requested folders
    %
    % - Outputs -
    %
    % TopLevelFolders   - Cell string array with the full path of the found folders 
    %
    % - Test -
    %
    % [TopLevelFolders] = GetTopLevelFolders(pwd)

    if ~isempty(DirectoryPath) && (~ischar(DirectoryPath) || ~isvector(DirectoryPath))
        error('DirectoryPath must a char vector.')
    end
    
    Content = dir(DirectoryPath);
    
    if isempty(Content)
        error('Path not found or directory contains no files or folders. Please make sure the directory exists and path is not relative.')
    end
    
    Content = Content([Content.isdir]');
    Content = Content(3 : end, :);
        
    TopLevelFolders = strcat([DirectoryPath '\'], {Content.name}');
    
end