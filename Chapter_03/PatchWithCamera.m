%% Generate two cubes using patch and point a camera at the scene
% The camera parameters will be set programmatically using the cam functions.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Camera parameters
% Orbit
thetaOrbit	= 0;
phiOrbit    = 0;

% Dolly
xDolly      = 0;
yDolly      = 0;
zDolly      = 0;

% Zoom
zoom        = 1;

% Roll
roll        = 50;

% Pan
thetaPan    = 1;
phiPan      = 0;

%% Box design
x   = 1;
y   = 2;
z   = 3;

% Faces
f   = [2 3 6;3 7 6;3 4 8;3 8 7;4 5 8;4 1 5;2 6 5;2 5 1;1 3 2;1 4 3;5 6 7;5 7 8];

% Vertices
v = [-x  x  x -x -x  x  x -x;...
     -y -y  y  y -y -y  y  y;...
     -z -z -z -z  z  z  z  z]'/2;

%% Draw the object
h = figure('name','Box');

c = [0.7 0.7 0.1];
patch('vertices',v,'faces',f,'facecolor',c,'edgecolor',c,...
      'edgelighting','gouraud','facelighting','gouraud');
    
c = [0.2 0 0.9];
v      = 0.5*v;
v(:,1) = v(:,1) + 5;
patch('vertices',v,'faces',f,'facecolor',c,'edgecolor',c,...
      'edgelighting','gouraud','facelighting','gouraud');

material('metal'); 
lighting gouraud
axis equal
grid on
xlabel('x')
ylabel('y')
zlabel('z')
view(3)
rotate3d on

%% Camera commands
campan(thetaPan,phiPan)
camzoom(zoom)
camdolly(xDolly,yDolly,zDolly);
camorbit(thetaOrbit,phiOrbit);
camroll(roll);

s = sprintf('Pan %3.1f %3.1f\nZoom %3.1f\nDolly %3.1f %3.1f %3.1f\nOrbit %3.1f %3.1f\nRoll %3.1f',...
thetaPan,phiPan,zoom,xDolly,yDolly,zDolly,thetaOrbit,phiOrbit,roll);

text(2,0,0,s);

