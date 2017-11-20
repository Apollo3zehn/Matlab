function [IsSuffixMatched] = EndsWith(String, Suffix)

    n = length(Suffix);

    if length(String) < n
        IsSuffixMatched = false;
    else
        IsSuffixMatched = strcmp(String(end - n + 1 : end), Suffix);
    end

end