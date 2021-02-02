%% Create a plot and annotate it with text
% Add text annotations evenly spaced along a curve.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Parameters
nPoints = 5; % Number of plot points to have annotations

%% Create the line
v       = [1;2;3];
t       = linspace(0,1000);
r       = [v(1)*t;v(2)*t;v(3)*t];

%% Create the figure and plot
s = 'Annotated Plot';
h = figure('name',s);
plot3(r(1,:),r(2,:),r(3,:));
xlabel('X');
ylabel('Y');
zlabel('Z');
title(s)
grid

%% Add the annotations
n    = length(t);
j    = ceil(linspace(1,n,nPoints));

for k = j
  text(r(1,k), r(2,k), r(3,k), sprintf('- Time %d',floor(t(k))));
end
