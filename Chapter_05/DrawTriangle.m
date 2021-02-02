%% DRAWTRIANGLE Draw a triangle given two sides and the interior angle.
%% Form
%   DrawTriangle(a,b,C)
%% Inputs
%   a     (1,1)   First side length
%   b     (1,1)   Second side length
%   C     (1,1)   Interior angle (degrees)
%% Outputs
% None; generates a figure.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved

function DrawTriangle(a,b,C)

figure('Name','Triangle')
x = b*cosd(C);
y = b*sind(C);
f = fill([0 a x],[0 0 y],'c','faceAlpha',0.3);
hold on
la = plot([0 1],[0 0]);
lb = plot([0 x],[0 y]);
lc = plot([a x],[0 y]);

text(a,0,'a')
text(x,y,'b')
text(0.2*a,0.03*y,'C')

y = axis;
axis([y(1)-0.1*a y(2)+0.1*a y(3)-0.1*b y(4)+0.1*b])
axis equal