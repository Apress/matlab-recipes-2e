%% Visualize data over 2D and 3D grids
% The meshgrid function makes it easy to create grids for visualization.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% 2D example of meshgrid
figure('Name','2D Visualization');
xv = -1.5:0.1:1.5;
yv = -2:0.2:2;
[X,Y] = meshgrid(xv, yv);
Z = Y .* exp(-X.^2 - Y.^2);
surf(X,Y,Z,'edgecolor','none')
title('2D Grid Example')
zlabel('z = y exp( -x^2-y^2 )')
colormap hsv

size(X)
size(Y)

figure('Name','Contour and Quiver')
[px,py] = gradient(Z,0.1,0.2);
contour(X,Y,Z), hold on
quiver(X,Y,px,py)
title('Contour and Quiver Demo')
xlabel('x')
ylabel('y')
colormap hsv
axis equal



%% 3D example of meshgrid
% meshgrid can be used to produce 3D matrices, and slice can display selected
% planes using interpolation.
figure('Name','3D Visualization');
zv = -3:0.3:3;
[x,y,z] = meshgrid(xv, yv, zv);
v = x .* exp(-x.^2 - y.^2 - z.^2);
slice(x,y,z,v,[-1.2 -0.5 0.8],[],[-0.25 1])
title('3D Grid Example')
zlabel('v = y exp( -x^2-y^2-z^2 )')
colormap hsv
