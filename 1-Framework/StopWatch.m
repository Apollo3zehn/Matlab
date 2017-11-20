classdef StopWatch 
  
    methods(Static)
        
        function [] = Start
            tic
        end
             
        function [DateTime] = ElapsedTime()
            
            try
                DateTime = TimeSpan(0, 0, 0, toc).ToDateTime;
            catch ex
                Display.Warning(ex)
            end
            
        end
        
    end
    
end

