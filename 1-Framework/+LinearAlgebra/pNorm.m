function pNorm = pNorm(Data, Order)

    % Calculates the p-Norm for each column

    pNorm = sum(abs(Data).^Order, 1).^(1/Order);

end

