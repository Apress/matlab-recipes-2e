%% Animate a cube using patch
% Create a figure and draw a cube in it. The vertices and faces are specified
% directly. We only update vertices to get a smooth animation.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

%% Box design
x   = 3;
y   = 2;
z   = 1;

% Faces
f   = [2 3 6;3 7 6;3 4 8;3 8 7;4 5 8;4 1 5;2 6 5;2 5 1;1 3 2;1 4 3;5 6 7;5 7 8];

% Vertices
v = [-x  x  x -x -x  x  x -x;...
     -y -y  y  y -y -y  y  y;...
     -z -z -z -z  z  z  z  z]'/2;

%% Draw the object
h = figure('name','Box');
p = patch('vertices',v,'faces',f,'facecolor',[0.5 0.5 0.5],...
          'linestyle','none','facelighting','gouraud');
ax = gca;
set(ax,'DataAspectRatio',[1 1 1],'DataAspectRatioMode','manual')
axis([-3 3 -3 3 -3 3])
grid on
xlabel('x')
ylabel('y')
zlabel('z')
view(3)
rotate3d on
light('position',[0 0 1])

%% Animate
% We use tic and toc to time the animation. Pause is used with a fraction of a
% second input to slow the animation down.
tic
n = 10000;
a = linspace(0,8*pi,n);

c = cos(a);
s = sin(a);

for k = 1:n
  b   = [c(k) 0 s(k);0 1 0;-s(k) 0 c(k)];
  vK  = (b*v')';
  set(p,'vertices',vK);
  pause(0.001); 
end
toc

  