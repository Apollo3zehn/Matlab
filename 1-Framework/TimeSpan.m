classdef TimeSpan < handle
   
properties
    Days
    Hours
    Minutes
    Seconds
end
    
methods

    function obj = TimeSpan(Days, Hours, Minutes, Seconds)
        obj.Days    = Days;
        obj.Hours   = Hours;
        obj.Minutes = Minutes;
        obj.Seconds = Seconds;
    end

    function Days = TotalDays(Me)
        Days = Me.TotalHours / 24;
    end
    
    function Hours = TotalHours(Me)
        Hours = Me.TotalMinutes / 60;
    end
    
    function Minutes = TotalMinutes(Me)
        Minutes = Me.TotalSeconds / 60;
    end

    function Seconds = TotalSeconds(Me)
        Seconds = Me.Days * 86400 + Me.Hours * 3600 + Me.Minutes * 60 + Me.Seconds;
    end

    function DateTime = ToDateTime(Me)
        DateTime = datenum(0, 0, Me.Days, Me.Hours, Me.Minutes, Me.Seconds);
    end

end
    
end