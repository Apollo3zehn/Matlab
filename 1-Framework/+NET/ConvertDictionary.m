function output = ConvertDictionary(input)

	i = 0;
    enumerator = input.Values.GetEnumerator;

    while enumerator.MoveNext
        i = i + 1;
        output(i) = NET.ConvertType(enumerator.Current);
    end

end

