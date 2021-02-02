%% QUADPLOT Create a quad plot page using subplot.
% This creates a 3D view and three 2D views of a trajectory in one figure.
%% Form
%  QuadPlot( x )
%% Input
%   x   (3,:)    Trajectory data
%
%% Output
% None. But you may want to return the graphics handles for further programmatic
% customization.
%

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function QuadPlot(x)

if nargin == 0
  disp('Demo of QuadPlot');
  th = logspace(0,log10(4*pi),101);
  in = logspace(-1,0,101);
  x = [sin(th).*cos(in);cos(th).*cos(in);sin(in)];
  QuadPlot(x);
  return;
end

h = figure('Name','QuadPage');
set(h,'InvertHardcopy','off')

% Use subplot to create plots
subplot(2,2,3)
plot3(x(1,:),x(2,:),x(3,:));
xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
title('Trajectory')
rotate3d on

subplot(2,2,1)
plot(x(1,:),x(2,:));
xlabel('X')
ylabel('Y')
grid on
title('Along Z')

subplot(2,2,2)
plot(x(2,:),x(3,:));
xlabel('Y')
ylabel('Z')
grid on
title('Along X')

subplot(2,2,4)
plot(x(1,:),x(3,:));
xlabel('X')
ylabel('Z')
grid on
title('Along Y')

