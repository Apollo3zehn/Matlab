classdef File
   
    methods(Static)
        
        function [IsAccessible] = CheckAccess(FilePath)

            FileID = fopen(FilePath, 'r');

            if FileID >= 3 
                IsAccessible = true;
                fclose(FileID);
            else
                IsAccessible = false;
            end

        end
        
        function [FileID] = Lock(FilePath)
            FileID = fopen(FilePath, 'w+');
        end
       
        function [] = Unlock(FileID)
            fclose(FileID);
        end
              
    end
    
end