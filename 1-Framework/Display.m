classdef Display

methods(Static)

    function [] = RemoveChars(Count)
        fprintf(repmat('\b', 1, Count))
    end
    
    function [] = Headline(String)
        clc
        display(['***** ' String ' *****'])
        Display.NewLine
    end
    
    function [] = Text(String)
        disp(String)
        Display.NewLine
    end
    
    function [] = TextWithoutBreaks(String)
        fprintf(String)
    end
    
    function [] = Done
        Display.Text('Done.')
    end
    
    function [] = NewLine()
        display(' ')
    end
    
    function [] = Finished()
        display('Finished.')
        Display.NewLine
    end
    
    function MessageLength = ProgressStatus(Category, Number, Count, ElapsedTime, RemoveCharacterCount)
        
        Display.RemoveChars(RemoveCharacterCount)
        
        Message         = ['Processing ' Category ' ' num2str(Number) ' of ' num2str(Count)];
        Message         = [Message Display.TimeInformation(Number, Count, ElapsedTime) char(10)];
       
        disp(Message)
        
        MessageLength   = numel(Message) + 1;
        
    end
    
    function MessageLength = ProcessingDateTime(DateTimeNumber, DateTimeCount, ElapsedTime, DateTimeBegin, DateTimeEnd, RemoveCharacterCount)
        
        Display.RemoveChars(RemoveCharacterCount)
        
        Format          = 'yyyy-mm-ddThh:MM:ss';
               
        Message         = ['Processing time span ' num2str(DateTimeNumber) ' of ' num2str(DateTimeCount) ...
                           ' from ' datestr(DateTimeBegin, Format) ' to ' datestr(DateTimeEnd, Format) ' ...'];
        Message         = [Message Display.TimeInformation(DateTimeNumber, DateTimeCount, ElapsedTime) char(10)];
                       
        disp(Message)
        
        MessageLength   = numel(Message) + 1;
        
    end
   
    function [] = Warning(Exception)
        warning(getReport(Exception, 'extended'))
    end
    
    function [] = NoDataAvailable()
        display('No data available to display. Skipping job.')
        Display.NewLine
    end
    
end

methods(Static, Access = private)
    
    function [Message] = TimeInformation(Number, Count, ElapsedTime)
              
        Message = [];
        
        if Number > 1
            
            RemainingTime = ElapsedTime / (Number - 1) * (Count - Number + 1);
             
            Message = [char(10) char(10) 'Elapsed time: ' DateTime.ToString(ElapsedTime, 'hh:MM:ss') ...
                       ' Time remaining: ' DateTime.ToString(RemainingTime, 'hh:MM:ss')];
                       
        end
                
    end
    
end
    
end 