
% !     To initialize the subroutine:
% !  [Err] = InflowWind_mex( 0, FileName, FileType, ReferenceHeight, ReferenceWidth )
% !
% !     To get wind speeds:
% !  [Err, V] = InflowWind_mex( 3, t, X )
% !
% !     To terminate:
% !  [Err] = InflowWind_mex( 9 )
% !
% !     Err             = INTEGER(8)         error status
% !     V               = REAL(8) ARRAY(3)   velocity
% !     FileName        = CHARACTER(*)
% !     FileType        = REAL(8)
% !     ReferenceHeight = REAL(8)
% !     ReferenceWidth  = REAL(8)
% !     t               = REAL(8)            time
% !     x               = REAL(8) ARRAY(3)   position

FileName  = '..\TestData\Periodic_Winds.bts';
FileName2 = '..\TestData\Periodic_Winds.wnd';
FileType = -1; %default -- program figures it out
ReferenceHeight = 90.6; %doesn't matter for non-hh wind files
ReferenceWidth  = 0;    %doesn't matter for non-hh wind files
t       = -61:0.025:120;
% t_shift = t +  140/(6*2);

X = [-5,5,ReferenceHeight];
%%
% initialize:
[Err] = InflowWind_mex( 0, FileName,  FileType, ReferenceHeight, ReferenceWidth );

% get wind speeds:

[Err, V ] = InflowWind_mex( 3, t, X );

% terminate:
[Err] = InflowWind_mex( 9 );

%%
[Err]     = InflowWind_mex( 0, FileName2, FileType, ReferenceHeight, ReferenceWidth );
[Err, V2] = InflowWind_mex( 3, t, X );
[Err]     = InflowWind_mex( 9 );
%% compare with old values
% [Err]     = WindInflow_mex( 0, FileName2, FileType, ReferenceHeight, ReferenceWidth );
% [Err, V3] = WindInflow_mex( 3, t, X );
% [Err]     = WindInflow_mex( 9 );


