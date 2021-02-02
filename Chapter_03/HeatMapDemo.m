%% Heat map 
% Heat map plot from random data

cD	= rand(4,3);
xV	= {'1' '2' '3'};
yV	= {'a' 'b' 'c' 'd'};

NewFigure('Heat Map')

heatmap(xV,yV,cD)


%% Copyright
% Copyright (c) 2020 Princeton Satellite Systems, Inc.
% All rights reserved.