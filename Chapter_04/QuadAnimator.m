%% QUADANIMATOR Create a quad plot page with animation.
% This creates a 3D view and three 2D views of a trajectory in one figure. A
% menu is provided to animate the trajectory over time.
%% Form
%   QuadAnimator( t, x )
%% Input
%   t   (1,:)    Time data
%   x   (3,:)    Trajectory data
%
%% Output
% None. 

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function QuadAnimator(t,x)

if nargin == 0
  disp('Demo of QuadAnimator');
  t = linspace(0,4*pi,101);
  th = logspace(0,log10(4*pi),101);
  in = logspace(-1,0,101);
  x = [sin(th).*cos(in);cos(th).*cos(in);sin(in)];
  QuadAnimator(t,x);
  return;
end

if nargin==2
  h = figure('Name','QuadAnimator');
  set(h,'InvertHardcopy','off','menubar','none')
  ma = uimenu(h,'Label','Animate');
  ms = uimenu(ma,'Label','Start','Callback','QuadAnimator(''update'')');
  m = Plot(x);
  p = get(h,'position');
  ut = uicontrol('Style','text','String','Time: 0.0 s',...
                 'Position',[0 0 p(3) 20]); 
  d.t = t;
  d.x = x;
  d.m = m;
  d.ut = ut;
  set(h,'UserData',d);
else
  h = gcbf;
  d = get(h,'UserData');
  Animate(d);
end


function m = Plot(x)
% Use subplot to create four plots of a trajectory

subplot(2,2,3)
plot3(x(1,:),x(2,:),x(3,:));
hold on
m(3) = plot3(x(1,1),x(2,1),x(3,1),'o');
hold off
xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
title('Trajectory')

subplot(2,2,1)
plot(x(1,:),x(2,:));
hold on
m(1) = plot(x(1,1),x(2,1),'o');
hold off
xlabel('X')
ylabel('Y')
grid on
title('Along Z')

subplot(2,2,2)
plot(x(2,:),x(3,:));
hold on
m(2) = plot(x(2,1),x(3,1),'o');
hold off
xlabel('Y')
ylabel('Z')
grid on
title('Along X')

subplot(2,2,4)
plot(x(1,:),x(3,:));
hold on
m(4) = plot(x(1,1),x(3,1),'o');
hold off
xlabel('X')
ylabel('Z')
grid on
title('Along Y')
  

function Animate( d )
% Animate the markers on the subplots over time

for k = 1:length(d.t)
  x = d.x(:,k);
  set(d.m(3),'XData',x(1),'YData',x(2),'ZData',x(3));
  set(d.m(1),'XData',x(1),'YData',x(2));
  set(d.m(2),'XData',x(2),'YData',x(3));
  set(d.m(4),'XData',x(1),'YData',x(3));
  set(d.ut,'string',sprintf('Time: %f s',d.t(k)));
  drawnow;
end

 