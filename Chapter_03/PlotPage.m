%% PLOTPAGE Create a plot page with several custom plots in one figure.
% Specify axes with custom sizes on the figure.
%% Form
%  PlotPage( t, x )
%% Input
%   t   (1,:)    Time vector
%   x   (3,:)    Trajectory data
%
%% Output
% None. But you may want to return the graphics handles for further programmatic
% customization.
%

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function PlotPage(t, x)

if nargin == 0
  disp('Demo of PlotPage');
  t  = linspace(0,100,101);
  th = logspace(0,log10(4*pi),101);
  in = logspace(-1,0,101);
  x = [sin(th).*cos(in);cos(th).*cos(in);sin(in)];
  PlotPage(t,x);
  return
end

h = figure('Name','PlotPage');
set(h,'InvertHardcopy','off')

% Specify the axes position as [left, bottom, width, height]
axes('outerposition',[0.5 0 0.5 0.5]);
plot(t,x);
xlabel('Time')
grid on

% Specify an additional axes and make a 3D plot
axes('outerposition',[0 0.5 1 0.5]);
plot3(x(1,:),x(2,:),x(3,:));
xlabel('X')
ylabel('Y')
zlabel('Z')
grid on

% add markers evenly spaced with time
hold on
for k=1:10:length(t)
  plot3(x(1,k),x(2,k),x(3,k),'x');
  % add a text label
  label = ['  ' num2str(t(k)) ' s'];
  text(x(1,k),x(2,k),x(3,k),label);
end
hold off

uh = uicontrol('Style','text','String','Description of the plots',...
          'units','normalized','position',[0.05 0.1 0.35 0.3]);
set(uh,'string',['You may wish to provide a detailed description '...
                 'of the visualization of your data or the results right on the figure '...
                 'itself in a uicontrol text box such as this.']);
set(uh,'fontsize',14);
set(uh,'foregroundcolor',[1 0 0]);
