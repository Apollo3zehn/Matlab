function p = lsqid(y, u, n)
% lsqid:  least squares identification
%         of an n. order process
%
%         p = lsqid(y, u, n)
%
%         where p = [ a1 a2 ... an  b1 b2 ... bn ]

% (c) 2011 Univ. Bremerhaven

N = length(y);
if length(u) ~= N
    error('*** size of u and y are not the same.');
end

mk = zeros(2*n, 1);
MTM = zeros(2*n, 2*n);
MTY = mk;
for k=n+1:N
    for h=1:n
        mk(h) = -y(k-h);
        mk(h+n) = u(k-h);
    end;
    MTM = MTM + mk * mk';
    MTY = MTY + mk * y(k);
end
p = MTM \ MTY;
