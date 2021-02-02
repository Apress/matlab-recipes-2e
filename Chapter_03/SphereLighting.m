%% Create and light a sphere

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Make the sphere surface in a new figure
[X,Y,Z] = sphere(16);
figure('Name','Sphere Demo')
s = surf(X,Y,Z);
xlabel('x')
ylabel('y')
zlabel('z')
axis equal
view(70,15)

%% Add a lighting object and display the properties
light('position',[1 0 0])
disp(s)
title('Flat Lighting')
pause

%% Change to Gouraud lighting and display again
lighting gouraud
title('Gouraud Lighting')
disp(s)