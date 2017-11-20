f       = 2.9;
f_VCO   = 4;

[b, a] = butter(8, max(f, f_VCO)*2*pi, 'low', 's');