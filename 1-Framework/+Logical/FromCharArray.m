function Logical = FromCharArray(CharArray)
    Logical = logical(CharArray(:)' - '0');
end

