clc
clear
MaxIteration = 1;

%%
tic
fprintf('Dataset_2014-12-01T00-00_h5py_float16_gzip9_chunk60000_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float16_gzip9_chunk60000_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')

tic
fprintf('Dataset_2014-12-01T00-00_h5py_float16_gzip4_chunk60000_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float16_gzip4_chunk60000_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')

tic
fprintf('Dataset_2014-12-01T00-00_h5py_float32_gzip4_chunk60000_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float32_gzip4_chunk60000_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')

tic
fprintf('Dataset_2014-12-01T00-00_h5py_float32_gzip9_chunk60000_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float32_gzip9_chunk60000_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')

tic
fprintf('Dataset_2014-12-01T00-00_h5py_float32_chunk60000_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float32_chunk60000_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')

tic
fprintf('Dataset_2014-12-01T00-00_h5py_float16_chunk60000_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float16_chunk60000_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')

tic
fprintf('Dataset_2014-12-01T00-00_h5py_float16_chunk60000_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float16_chunk60000_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')

tic
fprintf('Dataset_2014-12-01T00-00_h5py_float64_chunk60000_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float64_chunk60000_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')

tic
fprintf('Dataset_2014-12-01T00-00_h5py_float_chunk60000_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float_chunk60000_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')

tic
fprintf('Dataset_2014-12-01T00-00_h5py_float_chunk60000_gzip9_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float_chunk60000_gzip9_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')

tic
fprintf('Dataset_2014-12-01T00-00_h5py_float16_chunk60000_gzip9_checksum:\n')
FileName = 'M:\Data Analysis\TestUmgebung_MHA\HDF5_TESTS\Dataset_2014-12-01T00-00_h5py_float16_chunk60000_gzip9_checksum.h5';
i = 0;
while true
    a   = h5read(char(FileName), '/C_Mast_Windspeed_10min_mean');
    i   = i + 1;
    if i == MaxIteration
        break
    end
end
toc
fprintf('\n')
